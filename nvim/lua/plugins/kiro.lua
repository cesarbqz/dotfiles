-- Kiro CLI habla el protocolo abierto ACP (Agent Client Protocol), no el
-- protocolo propietario de claudecode.nvim, asi que usamos agentic.nvim,
-- que ya trae un provider "kiro-acp" (kiro-cli acp) listo para usar.
-- Requiere kiro-cli instalado: https://kiro.dev/cli/

-- El agente ACP de kiro-cli no anuncia `sessionCapabilities.list` (solo
-- `loadSession`), asi que `agentic.restore_session()` falla con "Agent does
-- not support listing sessions". kiro-cli si expone el listado a nivel de
-- CLI (`chat --list-sessions`, ya filtrado por cwd), asi que lo usamos para
-- armar el picker y despues restauramos por ID, que si funciona.

-- kiro-cli no manda el `usage_update` estandar de ACP (por eso el header
-- nunca muestra tokens usados/tamano para Kiro), sino su propia extension
-- "_kiro.dev/metadata" con { sessionId, contextUsagePercentage }. Guardamos
-- el ultimo valor visto para poder mostrarlo en el header del chat.
local kiro_context_pct = nil

local function restore_kiro_session()
  local cwd = vim.fn.getcwd()

  vim.system(
    { "kiro-cli", "chat", "--list-sessions", "-f", "json" },
    { cwd = cwd, text = true },
    vim.schedule_wrap(function(result)
      if result.code ~= 0 then
        vim.notify("kiro-cli --list-sessions fallo: " .. (result.stderr or ""), vim.log.levels.WARN)
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
        local title = (s.title and s.title ~= "") and s.title or "(sin titulo)"
        table.insert(items, {
          display = string.format("%s - %s (%d msgs)", date, title, s.messageCount or 0),
          sessionId = s.sessionId,
        })
      end

      vim.ui.select(items, {
        prompt = "Sesiones de Kiro en " .. cwd .. ":",
        format_item = function(item) return item.display end,
      }, function(choice)
        if choice then require("agentic").restore_session_by_id(choice.sessionId) end
      end)
    end)
  )
end

return {
  {
    "carlos-algms/agentic.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = { "Agentic" },
    keys = {
      { "<leader>ak", nil, desc = "Kiro" },
      { "<leader>akk", function() require("agentic").toggle() end, mode = { "n", "v" }, desc = "Toggle Kiro" },
      { "<leader>akn", function() require("agentic").new_session() end, desc = "New Kiro session" },
      { "<leader>akl", function() require("agentic").select_session() end, desc = "List/select session" },
      { "<leader>akr", restore_kiro_session, desc = "Restore session (this dir)" },
      { "<leader>akx", function() require("agentic").destroy_session() end, desc = "Destroy session" },
      {
        "<leader>aka",
        function() require("agentic").add_selection_or_file_to_context() end,
        mode = { "n", "v" },
        desc = "Add file/selection to context",
      },
      {
        "<leader>akd",
        function() require("agentic").add_current_line_diagnostics() end,
        desc = "Add line diagnostics",
      },
      { "<leader>akD", function() require("agentic").add_buffer_diagnostics() end, desc = "Add buffer diagnostics" },
      { "<leader>aks", function() require("agentic").stop_generation() end, desc = "Stop generation" },
    },
    opts = {
      provider = "kiro-acp",
      windows = {
        position = "right",
        width = "40%",
      },
      headers = {
        -- Re-implementa el header por defecto de agentic (`provider - model -
        -- mode (used/size) $cost`) para poder sumarle el % de contexto que
        -- llega solo via la extension propietaria de Kiro (ver mas abajo).
        -- No se puede lograr con un `headers.chat` parcial: si es funcion,
        -- reemplaza el header entero en vez de mezclarse con el default.
        chat = function(parts, session_state)
          if not session_state then return parts.title end

          local segments = {}
          local function add(value)
            if value ~= nil and value ~= "" then table.insert(segments, value) end
          end
          add(session_state:get_provider_name())
          add(session_state:get_model_name() or "unknown")
          add(session_state:get_mode_name())

          local header = string.format("%s | %s", parts.title, table.concat(segments, " - "))

          local used, size = session_state:get_context_used(), session_state:get_context_size()
          if used ~= nil and size ~= nil then
            header = header .. string.format(" (%s/%s)", used, size)
          elseif kiro_context_pct ~= nil and session_state:get_provider_name() == "Kiro ACP" then
            header = header .. string.format(" (ctx %d%%)", math.floor(kiro_context_pct + 0.5))
          end

          local cost = session_state:get_cost_amount_raw()
          if cost ~= nil and cost ~= 0 then
            local amount = session_state:get_cost_amount() or ""
            local currency = session_state:get_cost_currency()
            header = header .. " " .. (currency and (currency .. " " .. amount) or amount)
          end

          -- El winbar de Neovim usa "%" como caracter de escape (%#hl#, %=,
          -- etc). Sin esto, "(ctx 12%)" rompe el formato con E542.
          return (header:gsub("%%", "%%%%"))
        end,
      },
    },
    config = function(_, opts)
      require("agentic").setup(opts)

      -- Kiro sends proprietary ACP notifications prefixed with "_kiro.dev/"
      -- (e.g. "_kiro.dev/metadata" with session/context-usage info). The ACP
      -- convention is that clients may safely ignore underscore-prefixed
      -- vendor extensions, but agentic.nvim doesn't know about them yet and
      -- warns on every one via vim.notify. Patched here (not upstream, since
      -- `:Lazy update` would overwrite a change to the plugin's own source).
      local Logger = require "agentic.utils.logger"
      local ACPClient = require "agentic.acp.acp_client"
      local handle_notification = ACPClient._handle_notification
      function ACPClient:_handle_notification(message_id, method, params)
        if type(method) == "string" and method:sub(1, 1) == "_" then
          if method == "_kiro.dev/metadata" and type(params) == "table" and params.contextUsagePercentage then
            kiro_context_pct = params.contextUsagePercentage
            -- Nada mas dispara un refresh del winbar tras esta notificacion
            -- si llega como la ultima del turno, asi que lo forzamos.
            local owner = require("agentic.session_registry").find_by_acp_session_id(params.sessionId, self)
            if owner then owner.widget:schedule_header_refresh() end
          end
          Logger.debug_to_file("Ignoring vendor ACP extension notification: ", method)
          return
        end
        return handle_notification(self, message_id, method, params)
      end
    end,
  },
}
