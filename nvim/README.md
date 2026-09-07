# Configuración de Neovim (AstroNvim v5+)

Config personal basada en [AstroNvim](https://github.com/AstroNvim/AstroNvim) con `lazy.nvim`.

Este README está pensado para **buscar por función**: usá <kbd>Ctrl</kbd>+<kbd>F</kbd>
(o `/` en el navegador/GitHub) y escribí lo que querés hacer —por ejemplo
`saltar`, `reemplazar`, `diff`, `renombrar archivo`, `comentar`, `terminal`—
y vas a caer directo en la tecla correspondiente. Cada fila tiene palabras
clave en la columna "Para qué / buscar".

## Convenciones

- **`<Leader>`** = <kbd>Espacio</kbd> (barra espaciadora).
- **`<LocalLeader>`** = <kbd>,</kbd> (coma).
- Notación: `<C-h>` = <kbd>Ctrl</kbd>+<kbd>h</kbd> · `<M-j>` = <kbd>Alt</kbd>+<kbd>j</kbd> ·
  `<S-Tab>` = <kbd>Shift</kbd>+<kbd>Tab</kbd> · `<CR>` = <kbd>Enter</kbd>.
- **Modo** indica dónde funciona la tecla: `n` normal · `v/x` visual · `o` operator-pending ·
  `i` insert · `t` terminal.
- Descubrimiento en vivo: apretá <kbd>Espacio</kbd> y esperá — **which-key**
  muestra un menú con todo lo que cuelga del leader. `<Leader>fk` busca cualquier keymap.

---

## Índice por tarea

- [Moverse por la pantalla (saltar, Flash)](#moverse-por-la-pantalla-saltar)
- [Buscar y reemplazar (grug-far)](#buscar-y-reemplazar-grug-far)
- [Buscar cosas (Telescope / find)](#buscar-cosas-telescope--find)
- [Archivos y explorador (Neo-tree, Oil)](#archivos-y-explorador-neo-tree-oil)
- [Git (status, commits, diff, blame)](#git-status-commits-diff-blame)
- [Diff y merge conflicts (Diffview)](#diff-y-merge-conflicts-diffview)
- [Buffers y pestañas](#buffers-y-pestañas)
- [Ventanas / splits](#ventanas--splits)
- [Editar texto (comentar, rodear, mover, multicursor)](#editar-texto)
- [LSP: código, diagnósticos, símbolos](#lsp-código-diagnósticos-símbolos)
- [Debug (DAP)](#debug-dap)
- [Terminal](#terminal)
- [IA (Kiro / Claude Code)](#ia-kiro--claude-code)
- [Toggles y UI (`<Leader>u`)](#toggles-y-ui)
- [Sesiones](#sesiones)
- [Plugins y paquetes (`<Leader>p`)](#plugins-y-paquetes)
- [Archivo / general](#archivo--general)

---

## Moverse por la pantalla (saltar)

Plugin: **flash.nvim**. Palabras clave: *saltar, salto, jump, ir a, motion, navegar rápido, treesitter*.

| Tecla | Modo | Para qué / buscar |
|-------|------|-------------------|
| `s` + caracteres | n, x, o | **Saltar a cualquier lugar visible** — escribí 1-2 chars y elegí la etiqueta |
| `S` | n, x, o | **Saltar por bloque Treesitter** (funciones, if, tablas) — selección de nodo AST |
| `R` | x, o | **Búsqueda Treesitter** — extender selección a nodos con etiqueta |
| `r` | o | **Remote Flash** — aplicar un operador (ej. `yr`) en un lugar remoto sin mover el cursor |
| `f` `t` `F` `T` | n | Motions de carácter clásicos, mejorados con etiquetas de Flash |
| `/` `?` | n | Búsqueda normal; Flash agrega etiquetas para saltar a cualquier match |

> Nota: en modo visual `s` pasa a ser "Flash" (antes borraba la selección). Usá `c` para "cambiar".

## Buscar y reemplazar (grug-far)

Plugin: **grug-far.nvim**. Palabras clave: *reemplazar, replace, buscar y reemplazar, sustituir, refactor nombre, find and replace, cambiar en todo el proyecto*.

| Tecla | Modo | Para qué / buscar |
|-------|------|-------------------|
| `<Leader>ss` | n | **Buscar/Reemplazar en todo el workspace** (proyecto entero, con preview en vivo) |
| `<Leader>se` | n | Buscar/Reemplazar **solo en archivos del mismo tipo** que el actual (ej. `*.tf`) |
| `<Leader>sf` | n | Buscar/Reemplazar **solo en el archivo actual** |
| `<Leader>sw` | n | **Reemplazar la palabra bajo el cursor** en el proyecto |
| `<Leader>s` | v/x | **Reemplazar el texto seleccionado** en el proyecto |
| `gS` | n | Dentro de **Neo-tree** o **Oil**: reemplazar en el directorio bajo el cursor |

> El buffer de grug-far se edita como texto: cambiás el término de búsqueda/reemplazo
> arriba y aplicás. Requiere `ripgrep` (`rg`) instalado.

## Buscar cosas (Telescope / find)

Palabras clave: *buscar archivo, abrir archivo, grep, buscar palabra, buscar en proyecto, buscar comando, fuzzy finder, historial, marks, keymap*.

| Tecla | Para qué / buscar |
|-------|-------------------|
| `<Leader>ff` | **Buscar archivos** (fuzzy) en el proyecto |
| `<Leader>fF` | Buscar **todos** los archivos (incluye ocultos/ignorados) |
| `<Leader>fw` | **Buscar palabra/texto** en el proyecto (live grep) |
| `<Leader>fW` | Buscar texto en **todos** los archivos |
| `<Leader>fc` | Buscar la **palabra bajo el cursor** en el proyecto |
| `<Leader>fb` | Buscar entre **buffers** abiertos |
| `<Leader>fo` | Archivos **recientes** (old files) |
| `<Leader>fp` | Buscar / cambiar de **proyecto** |
| `<Leader>fh` | Buscar en la **ayuda** (`:help`) |
| `<Leader>fk` | **Buscar keymaps** — el atajo para encontrar cualquier atajo |
| `<Leader>fC` | Buscar **comandos** |
| `<Leader>fT` | Buscar **TODOs** del proyecto |
| `<Leader>ft` | Cambiar de **tema** (colorscheme) |
| `<Leader>fr` | Buscar en **registros** |
| `<Leader>fu` | Historial de **undo** |
| `<Leader>f'` | Buscar **marks** |
| `<Leader>fn` | Buscar **notificaciones** pasadas |
| `<Leader>f<CR>` | **Reanudar** la última búsqueda |

## Archivos y explorador (Neo-tree, Oil)

Palabras clave: *explorador, árbol de archivos, file tree, sidebar, renombrar archivo, crear archivo, borrar archivo, mover archivo, navegar carpetas*.

| Tecla | Para qué / buscar |
|-------|-------------------|
| `<Leader>e` | **Abrir/cerrar el explorador** (Neo-tree, sidebar) |
| `<Leader>o` | Enfocar el explorador (o volver al editor) |
| `<Leader>O` | **Abrir la carpeta actual en Oil** (editar el filesystem como buffer) |
| `<Leader>n` | **Nuevo archivo** |
| `<Leader>R` | **Renombrar** el archivo actual |

**Oil** (plugin `oil.nvim`) — palabras clave: *editar filesystem, renombrar como texto, gestionar archivos con buffer*.
Abrís con `<Leader>O`, y dentro editás la lista de archivos como si fuera texto normal:
- Escribí un nombre nuevo y guardá (`:w`) para **crear** un archivo/carpeta.
- Editá una línea para **renombrar**.
- Borrá la línea para **eliminar**.
- `-` sube al directorio padre; `<CR>` entra a la carpeta/archivo.
- `gS` (si está grug-far) para buscar/reemplazar en ese directorio.

## Git (status, commits, diff, blame)

Palabras clave: *git, commit, branch, rama, stash, status, blame, hunk, stage, lazygit*.

| Tecla | Para qué / buscar |
|-------|-------------------|
| `<Leader>gg` | **Abrir lazygit** (TUI completa de git: stage, commit, branch, rebase) |
| `<Leader>gt` | Git **status** (Telescope) |
| `<Leader>gb` | Git **branches** (ramas) |
| `<Leader>gc` | Git **commits** del repositorio |
| `<Leader>gC` | Git commits **del archivo actual** |
| `<Leader>gT` | Git **stash** |
| `<Leader>go` | **Abrir en el navegador** (git browse) — funciona también en visual sobre un rango |

**Gitsigns** (marcadores en la columna, hunks) — usá los saltos entre cambios:

| Tecla | Para qué / buscar |
|-------|-------------------|
| `]r` / `[r` | Ir a la **siguiente/anterior referencia** (word highlight) |

> Para staging/reset de hunks y blame inline, gitsigns expone comandos y `<Leader>g` en which-key; explorá el menú con <kbd>Espacio</kbd>`g`.

## Diff y merge conflicts (Diffview)

Plugin: **diffview.nvim**. **No usa keymaps de leader**, se maneja por comandos (`:`).
Palabras clave: *diff, comparar cambios, revisar cambios, historial de archivo, merge conflict, resolver conflicto, review*.

| Comando | Para qué / buscar |
|---------|-------------------|
| `:DiffviewOpen` | **Abrir el diff** de todos los archivos modificados (working tree) |
| `:DiffviewOpen main..HEAD` | Comparar contra otra rama/rev |
| `:DiffviewOpen HEAD~2` | Comparar contra un commit anterior |
| `:DiffviewFileHistory %` | **Historial del archivo actual** (quién cambió qué) |
| `:DiffviewFileHistory` | Historial de todo el repositorio |
| `:DiffviewClose` | Cerrar la vista de diff |
| `:DiffviewToggleFiles` | Mostrar/ocultar el panel lateral de archivos |

> Para **resolver conflictos de merge**: abrí `:DiffviewOpen` durante un merge/rebase con
> conflictos y vas a ver las versiones lado a lado para elegir.

## Buffers y pestañas

Palabras clave: *buffer, cerrar buffer, cambiar de archivo abierto, tab, pestaña, siguiente buffer*.

| Tecla | Para qué / buscar |
|-------|-------------------|
| `]b` / `[b` | Buffer **siguiente / anterior** |
| `>b` / `<b` | **Mover** la pestaña del buffer a la derecha / izquierda |
| `<Leader>c` | **Cerrar** el buffer actual |
| `<Leader>C` | Cerrar el buffer **a la fuerza** (descarta cambios) |
| `<Leader>bb` | **Seleccionar** un buffer desde la tabline |
| `<Leader>bd` | Cerrar un buffer eligiéndolo desde la tabline |
| `<Leader>bc` | Cerrar **todos menos el actual** |
| `<Leader>bC` | Cerrar **todos** los buffers |
| `<Leader>bl` / `<Leader>br` | Cerrar todos los buffers **a la izquierda / derecha** |
| `<Leader>b\` / `<Leader>b|` | Abrir el buffer en split **horizontal / vertical** |
| `]t` / `[t` | Pestaña (tab) **siguiente / anterior** |

## Ventanas / splits

Palabras clave: *split, dividir ventana, panel, moverse entre ventanas, redimensionar, resize*.

| Tecla | Para qué / buscar |
|-------|-------------------|
| `\` | **Split horizontal** |
| `|` | **Split vertical** |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | **Moverse** al split de la izquierda / abajo / arriba / derecha |
| `<C-Left>` / `<C-Right>` | **Redimensionar** el split (ancho) |
| `<C-Up>` / `<C-Down>` | Multicursor: agregar cursor **arriba / abajo** (ver Editar texto) |
| `<Leader>q` | Cerrar la ventana |

> Nota: `<C-h/j/k/l>` sirven tanto para moverse entre splits como dentro de la terminal.

## Editar texto

Palabras clave: *comentar, comentario, rodear, comillas, paréntesis, surround, mover línea, multicursor, indentar, línea vacía*.

**Comentarios** (`gc`):

| Tecla | Modo | Para qué / buscar |
|-------|------|-------------------|
| `gcc` | n | **Comentar/descomentar la línea** |
| `gc` | v/x | **Comentar/descomentar la selección** |
| `gc` + movimiento | n | Comentar un textobject (ej. `gcap` un párrafo) |
| `gco` / `gcO` | n | Agregar comentario **debajo / arriba** |
| `<Leader>/` | n, v | Comentar línea / selección (alias) |

**Rodear con pares** (mini.surround, `gz`) — *comillas, brackets, tags*:

| Tecla | Para qué / buscar |
|-------|-------------------|
| `gza` | **Agregar** un par alrededor (ej. `gzaiw"` rodea la palabra con comillas) |
| `gzd` | **Borrar** el par que rodea |
| `gzr` | **Reemplazar** el par que rodea (ej. `"` por `'`) |
| `gzf` / `gzF` | Buscar el par a la derecha / izquierda |
| `gzh` | Resaltar el par que rodea |

**Mover texto** (mini.move):

| Tecla | Modo | Para qué / buscar |
|-------|------|-------------------|
| `<M-h>` `<M-j>` `<M-k>` `<M-l>` | n | Mover la **línea** izquierda/abajo/arriba/derecha |
| `<M-h>` `<M-j>` `<M-k>` `<M-l>` | v/x | Mover la **selección** |

**Múltiples cursores** (vim-visual-multi):

| Tecla | Para qué / buscar |
|-------|-------------------|
| `<C-Up>` / `<C-Down>` | Agregar un **cursor arriba / abajo** |

**Líneas e indentación:**

| Tecla | Modo | Para qué / buscar |
|-------|------|-------------------|
| `[ ` (espacio) | n | Insertar **línea vacía arriba** |
| `] ` (espacio) | n | Insertar **línea vacía abajo** |
| `<Tab>` / `<S-Tab>` | v/x | **Indentar / des-indentar** la selección |

## LSP: código, diagnósticos, símbolos

Palabras clave: *ir a definición, referencias, renombrar símbolo, code action, error, warning, diagnóstico, hover, autocompletar, formatear, implementación*.

| Tecla | Modo | Para qué / buscar |
|-------|------|-------------------|
| `grn` | n | **Renombrar** el símbolo bajo el cursor (en todo el proyecto) |
| `gra` | n, v/x | **Code action** (arreglos rápidos, refactors) |
| `grr` | n | Buscar **referencias** del símbolo |
| `gri` | n | Ir a la **implementación** |
| `grt` | n | Ir a la **definición de tipo** |
| `gD` | n | Ir a la **declaración** |
| `gO` | n | **Símbolos del documento** |
| `gl` / `<Leader>ld` | n | **Hover de diagnósticos** (ver el error/warning en el punto) |
| `<Leader>ls` | n | Buscar **símbolos** (Telescope) |
| `<Leader>lS` | n | **Outline** de símbolos (aerial) |
| `<Leader>lD` | n | Buscar **diagnósticos** del proyecto |
| `]d` / `[d` | n | Ir al **siguiente / anterior diagnóstico** |
| `]e` / `[e` | n | Ir al siguiente / anterior **error** |
| `]w` / `[w` | n | Ir al siguiente / anterior **warning** |
| `[D` / `]D` | n | Ir al **primer / último** diagnóstico del buffer |
| `<C-w>d` | n | Mostrar el diagnóstico bajo el cursor en una ventana |

> El **formateo al guardar** está activado globalmente (AstroLSP). La autocompletación
> usa **blink.cmp**.

## Debug (DAP)

Palabras clave: *debug, depurar, breakpoint, punto de interrupción, step, paso a paso, REPL, watch, inspeccionar*.

| Tecla | Para qué / buscar | Alt. tecla F |
|-------|-------------------|--------------|
| `<Leader>db` | **Toggle breakpoint** | `<F9>` |
| `<Leader>dC` | Breakpoint **condicional** | `<S-F9>` |
| `<Leader>dB` | **Limpiar** todos los breakpoints | |
| `<Leader>dc` | **Iniciar / continuar** | `<F5>` |
| `<Leader>di` | **Step into** (entrar) | `<F11>` |
| `<Leader>do` | **Step over** (siguiente) | `<F10>` |
| `<Leader>dO` | **Step out** (salir) | `<S-F11>` |
| `<Leader>dp` | **Pausar** | `<F6>` |
| `<Leader>dr` | **Reiniciar** sesión | `<C-F5>` |
| `<Leader>dQ` | **Terminar** sesión | `<S-F5>` |
| `<Leader>dq` | Cerrar sesión | |
| `<Leader>ds` | Ejecutar **hasta el cursor** | |
| `<Leader>dh` | **Hover** del debugger (ver valor) | |
| `<Leader>dE` | **Evaluar** una expresión (input) | |
| `<Leader>dR` | Toggle **REPL** | |
| `<Leader>du` | Toggle **UI del debugger** | |

## Terminal

Palabras clave: *terminal, consola, shell, flotante, lazygit, python, node*.

| Tecla | Modo | Para qué / buscar |
|-------|------|-------------------|
| `<C-'>` / `<F7>` | n, i, t | **Toggle terminal** rápido |
| `<Leader>tf` | n | Terminal **flotante** (NvZone Floaterm) |
| `<Leader>tF` | n | Terminal flotante (ToggleTerm) |
| `<Leader>th` | n | Terminal en split **horizontal** |
| `<Leader>tv` | n | Terminal en split **vertical** |
| `<Leader>tl` / `<Leader>gg` | n | **lazygit** en terminal |
| `<Leader>tn` | n | Terminal **node** |
| `<Leader>tp` | n | Terminal **python** |
| `<C-h/j/k/l>` | t | Moverse a otra ventana desde la terminal |

## IA (Kiro / Claude Code)

Palabras clave: *IA, AI, asistente, chat, kiro, claude, copilot, agregar contexto, diagnósticos al chat*.

**Kiro CLI** (`<Leader>ak`):

| Tecla | Modo | Para qué / buscar |
|-------|------|-------------------|
| `<Leader>akk` | n, v | **Toggle** la sesión de Kiro (abrir/ocultar) |
| `<Leader>akn` | n | **Nueva** sesión de Kiro |
| `<Leader>akr` | n | **Reanudar** la sesión más reciente |
| `<Leader>akl` | n | **Listar/elegir** sesión (picker de kiro-cli) |
| `<Leader>akR` | n | **Restaurar** sesión de este directorio |
| `<Leader>akx` | n | **Cerrar/destruir** la sesión |
| `<Leader>aka` | n | **Agregar el archivo actual** al chat |
| `<Leader>aka` | v | **Agregar la selección** al chat |
| `<Leader>akd` | n | Agregar **diagnósticos de la línea** al chat |
| `<Leader>akD` | n | Agregar **diagnósticos del buffer** al chat |

**Claude Code** (`<Leader>a`):

| Tecla | Modo | Para qué / buscar |
|-------|------|-------------------|
| `<Leader>ac` | n | **Toggle** Claude |
| `<Leader>af` | n | **Enfocar** Claude |
| `<Leader>ar` | n | **Reanudar** Claude |
| `<Leader>aC` | n | **Continuar** Claude |
| `<Leader>am` | n | **Elegir modelo** de Claude |
| `<Leader>ab` | n | Agregar el **buffer actual** |
| `<Leader>as` | v | **Enviar la selección** a Claude |
| `<Leader>aa` | n | **Aceptar** el diff propuesto |
| `<Leader>ad` | n | **Rechazar** el diff |

## Toggles y UI

Palabras clave: *activar, desactivar, toggle, número de línea, wrap, spell, zen, tema oscuro, indent, conceal, diagnósticos on/off*.

| Tecla | Para qué / buscar |
|-------|-------------------|
| `<Leader>uZ` | **Zen mode** (foco, sin distracciones) |
| `<Leader>uw` | Toggle **wrap** (ajuste de línea) |
| `<Leader>un` | Cambiar **numeración** de línea |
| `<Leader>us` | Toggle **spellcheck** (corrector) |
| `<Leader>ud` | Toggle **diagnósticos** |
| `<Leader>uv` | Toggle **virtual text** de diagnósticos |
| `<Leader>uV` | Toggle **virtual lines** de diagnósticos |
| `<Leader>ub` | Toggle fondo **claro/oscuro** |
| `<Leader>uC` / `<Leader>uc` | Toggle **autocompletado** (global / buffer) |
| `<Leader>ua` | Toggle **autopairs** |
| `<Leader>ui` | Cambiar el **indent** |
| `<Leader>u\|` | Toggle **guías de indentación** |
| `<Leader>uS` | Toggle **conceal** |
| `<Leader>uz` | Toggle **resaltado de colores** |
| `<Leader>uD` | **Descartar** notificaciones |
| `<Leader>ul` | Toggle **statusline** |
| `<Leader>ut` | Toggle **tabline** |
| `<Leader>ug` | Toggle **signcolumn** |
| `<Leader>uy` | Toggle **syntax highlight** (buffer) |
| `<Leader>uu` | Toggle **resaltado de URLs** |

## Sesiones

Palabras clave: *sesión, guardar sesión, restaurar workspace, dirsession, retomar proyecto*.

| Tecla | Para qué / buscar |
|-------|-------------------|
| `<Leader>Ss` | **Guardar** esta sesión |
| `<Leader>Sl` | Cargar la **última** sesión |
| `<Leader>Sf` | **Cargar** una sesión |
| `<Leader>Sd` | **Borrar** una sesión |
| `<Leader>St` | Guardar la sesión **de esta pestaña** |
| `<Leader>SS` | Guardar la **dirsession** (por directorio) |
| `<Leader>S.` | Cargar la dirsession del directorio actual |
| `<Leader>SF` | Cargar una dirsession |
| `<Leader>SD` | Borrar una dirsession |

## Plugins y paquetes

Palabras clave: *lazy, mason, instalar plugin, actualizar, update, sync, LSP install*.

| Tecla | Para qué / buscar |
|-------|-------------------|
| `<Leader>pi` | **Instalar** plugins (Lazy) |
| `<Leader>ps` | **Estado** de plugins (Lazy) |
| `<Leader>pS` | **Sync** de plugins |
| `<Leader>pu` | Chequear **actualizaciones** |
| `<Leader>pU` | **Actualizar** plugins |
| `<Leader>pa` | Actualizar **Lazy y Mason** juntos |
| `<Leader>pm` | Abrir **Mason** (instalador de LSP/formatters/DAP) |
| `<Leader>pM` | **Actualizar** paquetes de Mason |

## Archivo / general

Palabras clave: *guardar, salir, quit, nuevo archivo, home, dashboard, quickfix*.

| Tecla | Para qué / buscar |
|-------|-------------------|
| `<Leader>w` | **Guardar** el archivo |
| `<C-s>` | **Guardar** a la fuerza |
| `<Leader>n` | **Nuevo** archivo |
| `<Leader>h` | Pantalla de inicio (**dashboard**) |
| `<Leader>q` | Cerrar ventana |
| `<Leader>Q` | **Salir** de Neovim |
| `<C-q>` | Salir a la fuerza |
| `<Leader>xq` | Lista **quickfix** |
| `<Leader>xl` | Lista de **ubicaciones** (location list) |
| `]q` / `[q` | Siguiente / anterior en el quickfix |

---

## Plugins destacados de esta config

| Plugin | Qué aporta |
|--------|------------|
| **flash.nvim** | Saltos en pantalla con etiquetas (`s`, `S`) |
| **grug-far.nvim** | Buscar/reemplazar en el proyecto con preview (`<Leader>s…`) |
| **diffview.nvim** | Vista de diffs, historial y merge conflicts (`:DiffviewOpen`) |
| **oil.nvim** | Editar el filesystem como buffer (`<Leader>O`) |
| **snacks.nvim** | Dashboard, terminal, picker, notificaciones, lazygit |
| **neo-tree** | Explorador de archivos en sidebar (`<Leader>e`) |
| **gitsigns** | Marcadores de git en la columna, hunks, blame |
| **which-key** | Menú de descubrimiento de keymaps (apretá `<Leader>`) |
| **mini.surround / mini.move** | Rodear con pares (`gz`), mover líneas (`<M-…>`) |
| **vim-visual-multi** | Múltiples cursores (`<C-Up>`/`<C-Down>`) |

Packs de lenguaje activos (LSP + formato + debug): Lua, YAML, Go, Bash, Docker,
Terraform, Python, JSON, HTML/CSS, Helm.

## Instalación

Esta config es parte del repo de dotfiles: el instalador de la raíz enlaza
`~/.config/nvim` acá y ya instala las herramientas externas.

```shell
git clone git@github.com:cesarbqz/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles
./install.sh
```

Para enlazar solo Neovim, sin tocar tmux ni el gestor de paquetes:

```shell
./nvim/install.sh
```

Si ya tenías un `~/.config/nvim`, el instalador lo mueve a
`~/.config/nvim.bak-<timestamp>` en vez de borrarlo. El estado de los plugins
(`~/.local/share/nvim`, `~/.local/state/nvim`, `~/.cache/nvim`) queda intacto; si
venís de otra config y algo se comporta raro, moveé esos tres directorios a
`.bak` y arrancá `nvim` de nuevo.

La primera vez que abras `nvim`, lazy.nvim instala los plugins en las versiones
fijadas en `lazy-lock.json`. Cuando agregues o actualices plugins, commiteá ese
archivo para que las demás máquinas queden idénticas.

## Requisitos

La lista completa está en el [README de la raíz](../README.md#requisitos). En
resumen, para esta config de Neovim:

`install.sh` instala con `brew` o `apt-get`:

- **Neovim ≥ 0.10** — AstroNvim v5 no arranca con una versión anterior.
- **ripgrep** (`rg`) — necesario para grug-far y el live grep de Telescope.
- **fd** — acelera la búsqueda de archivos.
- **lazygit** — TUI de git (`<Leader>gg`).
- Una **Nerd Font** activa en la terminal — si no, los iconos se ven como cuadraditos.

Y estos los tenés que tener vos, porque los maneja tu gestor de versiones
(nvm, pyenv, goenv). `install.sh` solo comprueba si están:

- **node** — los LSP que Mason instala por npm: bash, json, yaml, html/css, docker, emmet, `prettierd`.
- **go** — `gopls`, `delve`, `goimports` y el resto del pack de Go.
- **python3** — `debugpy`, `black`, `isort`.
- **deno** — `peek.nvim`, el preview de markdown.
- **Un compilador de C** — para los parsers de treesitter.

Falta uno, no funciona esa parte y el resto anda igual. Los packs de lenguaje
activos están en [`lua/community.lua`](lua/community.lua): si sacás uno, dejás de
necesitar su runtime.
