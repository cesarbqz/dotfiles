-- Kiro CLI tiene su propia interfaz interactiva real (`kiro-cli chat`), igual
-- que `claude`. Antes usábamos agentic.nvim (protocolo ACP/JSON-RPC) para
-- reimplementar un chat propio, pero eso trae dos problemas que la CLI real
-- resuelve sola:
--
--   1. Si no estás logueado, agentic.nvim no maneja el error AUTH_REQUIRED del
--      ACP (existe el código pero no se usa en ningún lado) y queda el
--      estado "generando" trabado.
--   2. Mandar un mensaje mientras el modelo está respondiendo ("steering")
--      no es parte del protocolo ACP en sí, es un truco del stdin de la CLI
--      interactiva. Un cliente JSON-RPC como agentic.nvim no lo puede tener.
--
-- Solución: igual que claudecode.lua, corremos el binario real (`kiro-cli
-- chat`) adentro de una terminal (snacks.nvim). El login y el steering pasan
-- a ser comportamiento nativo de la CLI, gratis. Lo que se pierde: diffs
-- inline, bloques de tool-calls estructurados y "agregar al contexto" deja
-- de ser una llamada de API prolija (ver `send_to_terminal` más abajo).

--- @type snacks.win?
local terminal = nil

--- @param extra_args string[]|nil
--- @return string[]
local function kiro_cmd(extra_args)
  local cmd = { "kiro-cli", "chat" }
  if extra_args then vim.list_extend(cmd, extra_args) end
  return cmd
end

local function is_valid(term) return term ~= nil and term:buf_valid() end

--- Escribe texto crudo en el canal de la terminal de Kiro, como si se
-- tipeara a mano. No abre la terminal: requiere que ya haya una corriendo.
--- @param text string
--- @param opts { submit?: boolean }|nil
--- @return boolean ok
local function send_to_terminal(text, opts)
  opts = opts or {}
  if not is_valid(terminal) then
    vim.notify("No hay una sesión de Kiro activa (abrila con <leader>akk)", vim.log.levels.WARN)
    return false
  end

  local bufnr = terminal.buf
  local chan = vim.b[bufnr] and vim.b[bufnr].terminal_job_id
  if not chan or chan == 0 then chan = vim.bo[bufnr].channel end
  if not chan or chan == 0 then
    vim.notify("No se pudo escribir: el canal de la terminal de Kiro no está disponible", vim.log.levels.WARN)
    return false
  end

  local normalized = text:gsub("\r\n", "\n"):gsub("\r", "\n")
  local payload = normalized
  if normalized:find("\n", 1, true) then
    -- multilínea: bracketed paste para que llegue como un solo bloque pegado
    payload = "\27[200~" .. normalized .. "\27[201~"
  end
  if opts.submit ~= false then payload = payload .. "\r" end

  local ok, written = pcall(vim.fn.chansend, chan, payload)
  if not ok or written == 0 then
    vim.notify("No se pudo escribir: el canal de la terminal de Kiro está cerrado", vim.log.levels.WARN)
    return false
  end
  return true
end

--- El proceso hijo de kiro-cli que dibuja la UI interactiva (un TUI en
--- Node/Bun, corre como nieto: kiro-cli -> kiro-cli-chat -> bun tui.js) se
--- queda pegado en "Initializing..." hasta que recibe un evento de resize.
--- Como el pty ya nace con el tamaño final, Neovim nunca dispara ese
--- resize y queda trabado para siempre (confirmado con `--resume-picker`:
--- un solo jobresize lo destraba al instante, sin tocar ninguna tecla). El
--- bun.js tarda en arrancar y no hay señal de "ya está listo", así que
--- reintentamos el nudge varias veces en los primeros segundos: si el
--- proceso todavía no instaló su listener de resize, la señal se pierde.
--- @param term snacks.win
local function nudge_render(term)
  local attempts = { 200, 600, 1200, 2200, 3500 }
  for _, delay in ipairs(attempts) do
    vim.defer_fn(function()
      if not is_valid(term) then return end
      local chan = vim.b[term.buf] and vim.b[term.buf].terminal_job_id
      local win = term.win
      if not chan or chan == 0 or not (win and vim.api.nvim_win_is_valid(win)) then return end

      local w = vim.api.nvim_win_get_width(win)
      local h = vim.api.nvim_win_get_height(win)
      pcall(vim.fn.jobresize, chan, w, math.max(1, h - 1))
      vim.schedule(function() pcall(vim.fn.jobresize, chan, w, h) end)
    end, delay)
  end
end

--- Crea la terminal de Kiro si no existe, o la enfoca si ya está corriendo
--- (ignorando `extra_args`, igual que claudecode.nvim: "resume" solo tiene
--- sentido si todavía no hay un proceso vivo).
--- @param extra_args string[]|nil
local function open_kiro(extra_args)
  if is_valid(terminal) then
    terminal:show()
    return terminal
  end

  local term = require("snacks").terminal.open(kiro_cmd(extra_args), {
    win = {
      position = "right",
      width = 0.4,
      wo = { winbar = "" }, -- deshabilita el título automático de snacks
    },
    start_insert = true,
    auto_insert = true,
    auto_close = false,
  })

  term:on("BufWipeout", function() terminal = nil end, { buf = true })
  terminal = term
  nudge_render(term)
  return term
end

local function toggle_kiro()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
  end

  if is_valid(terminal) then
    terminal:toggle()
  else
    open_kiro()
  end
end

--- Mata la sesión actual (si existe) y lanza una nueva con los argumentos
--- dados. A diferencia de `open_kiro`, esto SIEMPRE reinicia el proceso:
--- se usa para acciones donde el usuario pidió explícitamente cambiar de
--- sesión (elegir una de una lista), no para relanzar por las dudas.
--- @param extra_args string[]|nil
local function restart_kiro(extra_args)
  if is_valid(terminal) then terminal:close() end
  terminal = nil
  open_kiro(extra_args)
end

local function destroy_kiro()
  if is_valid(terminal) then
    terminal:close()
    terminal = nil
  else
    vim.notify("No hay una sesión de Kiro activa", vim.log.levels.INFO)
  end
end

-- kiro-cli expone el listado de sesiones a nivel de CLI (`chat
-- --list-sessions`, ya filtrado por cwd si se quiere), así que lo usamos
-- para armar un picker propio y después relanzar con `--resume-id`.
local function restore_kiro_session()
  local cwd = vim.fn.getcwd()

  vim.system(
    { "kiro-cli", "chat", "--list-sessions", "-f", "json" },
    { cwd = cwd, text = true },
    vim.schedule_wrap(function(result)
      if result.code ~= 0 then
        vim.notify("kiro-cli --list-sessions falló: " .. (result.stderr or ""), vim.log.levels.WARN)
        return
      end

      local ok, decoded = pcall(vim.json.decode, result.stdout)
      if not ok or type(decoded) ~= "table" then
        vim.notify("No se pudo parsear la lista de sesiones de kiro-cli", vim.log.levels.WARN)
        return
      end

      local sessions = {}
      for _, entry in ipairs(decoded) do
        if entry.cwd == cwd then
          sessions = entry.sessions or {}
          break
        end
      end

      if #sessions == 0 then
        vim.notify("No hay sesiones de Kiro guardadas para " .. cwd, vim.log.levels.INFO)
        return
      end

      local items = {}
      for _, s in ipairs(sessions) do
        local date = s.updatedAt and s.updatedAt:sub(1, 16):gsub("T", " ") or "fecha desconocida"
        local title = (s.title and s.title ~= "") and s.title or "(sin título)"
        table.insert(items, {
          display = string.format("%s - %s (%d msgs)", date, title, s.messageCount or 0),
          sessionId = s.sessionId,
        })
      end

      -- `vim.ui.select` solo queda parchado a la ventana flotante de snacks
      -- una vez que `snacks.picker` se cargó en la sesión (lo hace en su
      -- propio `setup()`, no en el de snacks.nvim); si todavía no se abrió
      -- ningún picker, cae al fallback nativo (una lista de texto en la
      -- cmdline, fácil de no ver). Llamamos al picker directo para que
      -- siempre sea la ventana flotante.
      require("snacks").picker.select(items, {
        prompt = "Sesiones de Kiro en " .. cwd .. ":",
        format_item = function(item) return item.display end,
      }, function(choice)
        if choice then restart_kiro { "--resume-id", choice.sessionId } end
      end)
    end)
  )
end

--- Manda la ruta del buffer actual como mención "@archivo". No se auto-envía
--- (`submit = false`): queda escrito en el prompt de Kiro para revisar antes
--- de mandar. NOTA: no está confirmado que kiro-cli soporte menciones "@" (es
--- la convención más común entre CLIs de agentes, pero verificar una vez
--- logueado); si no la soporta, igual queda la ruta como texto plano.
local function add_current_file()
  local path = vim.fn.expand "%:."
  if path == "" then
    vim.notify("El buffer actual no tiene archivo", vim.log.levels.WARN)
    return
  end
  send_to_terminal("@" .. path, { submit = false })
end

local function get_visual_selection()
  local srow, scol = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local erow, ecol = unpack(vim.api.nvim_buf_get_mark(0, ">"))
  local lines = vim.api.nvim_buf_get_lines(0, srow - 1, erow, false)
  if #lines == 0 then return nil end
  lines[#lines] = lines[#lines]:sub(1, ecol + 1)
  lines[1] = lines[1]:sub(scol + 1)
  return table.concat(lines, "\n")
end

local function add_visual_selection()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
  local text = get_visual_selection()
  if not text or text == "" then
    vim.notify("No hay selección para mandar", vim.log.levels.WARN)
    return
  end
  local path = vim.fn.expand "%:."
  local ft = vim.bo.filetype
  local payload = string.format("%s:\n```%s\n%s\n```", path, ft, text)
  send_to_terminal(payload, { submit = false })
end

--- @param d vim.Diagnostic
local function format_diagnostic(d)
  local sev = vim.diagnostic.severity[d.severity] or "?"
  return string.format("[%s] L%d: %s", sev, d.lnum + 1, d.message)
end

--- @param diags vim.Diagnostic[]
local function send_diagnostics(diags)
  if #diags == 0 then
    vim.notify("No hay diagnósticos", vim.log.levels.INFO)
    return
  end
  local lines = { "Diagnósticos en " .. vim.fn.expand "%:." .. ":" }
  for _, d in ipairs(diags) do
    table.insert(lines, format_diagnostic(d))
  end
  send_to_terminal(table.concat(lines, "\n"), { submit = false })
end

local function add_current_line_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
  send_diagnostics(vim.diagnostic.get(bufnr, { lnum = lnum }))
end

local function add_buffer_diagnostics() send_diagnostics(vim.diagnostic.get(vim.api.nvim_get_current_buf())) end

return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>ak", nil, desc = "Kiro" },
      { "<leader>akk", toggle_kiro, mode = { "n", "v" }, desc = "Toggle Kiro" },
      { "<leader>akn", function() restart_kiro() end, desc = "New Kiro session" },
      { "<leader>akr", function() open_kiro { "--resume" } end, desc = "Resume most recent session" },
      { "<leader>akl", function() restart_kiro { "--resume-picker" } end, desc = "List/select session (kiro-cli)" },
      { "<leader>akR", restore_kiro_session, desc = "Restore session (this dir)" },
      { "<leader>akx", destroy_kiro, desc = "Destroy session" },
      { "<leader>aka", add_current_file, mode = "n", desc = "Add current file to Kiro" },
      { "<leader>aka", add_visual_selection, mode = "v", desc = "Add selection to Kiro" },
      { "<leader>akd", add_current_line_diagnostics, desc = "Add line diagnostics to Kiro" },
      { "<leader>akD", add_buffer_diagnostics, desc = "Add buffer diagnostics to Kiro" },
    },
  },
}
