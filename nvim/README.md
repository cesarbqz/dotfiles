# Neovim configuration (AstroNvim v5+)

Personal config based on [AstroNvim](https://github.com/AstroNvim/AstroNvim) with `lazy.nvim`.

This README is meant to be **searched by task**: hit <kbd>Ctrl</kbd>+<kbd>F</kbd>
(or `/` in the browser/GitHub) and type what you want to do — for example
`jump`, `replace`, `diff`, `rename file`, `comment`, `terminal` — and you land
straight on the key that does it. Every row carries keywords in the
"What for / search" column.

## Conventions

- **`<Leader>`** = <kbd>Space</kbd>.
- **`<LocalLeader>`** = <kbd>,</kbd> (comma).
- Notation: `<C-h>` = <kbd>Ctrl</kbd>+<kbd>h</kbd> · `<M-j>` = <kbd>Alt</kbd>+<kbd>j</kbd> ·
  `<S-Tab>` = <kbd>Shift</kbd>+<kbd>Tab</kbd> · `<CR>` = <kbd>Enter</kbd>.
- **Mode** says where the key works: `n` normal · `v/x` visual · `o` operator-pending ·
  `i` insert · `t` terminal.
- Live discovery: press <kbd>Space</kbd> and wait — **which-key** shows a menu of
  everything hanging off the leader. `<Leader>fk` searches any keymap.

---

## Index by task

- [Moving around the screen (jump, Flash)](#moving-around-the-screen-jump)
- [Search and replace (grug-far)](#search-and-replace-grug-far)
- [Finding things (Telescope / find)](#finding-things-telescope--find)
- [Files and explorer (Neo-tree, Oil)](#files-and-explorer-neo-tree-oil)
- [Git (status, commits, diff, blame)](#git-status-commits-diff-blame)
- [Diff and merge conflicts (Diffview)](#diff-and-merge-conflicts-diffview)
- [Buffers and tabs](#buffers-and-tabs)
- [Windows / splits](#windows--splits)
- [Editing text (comment, surround, move, multicursor)](#editing-text)
- [LSP: code, diagnostics, symbols](#lsp-code-diagnostics-symbols)
- [Debug (DAP)](#debug-dap)
- [Terminal](#terminal)
- [AI (Kiro / Claude Code)](#ai-kiro--claude-code)
- [Toggles and UI (`<Leader>u`)](#toggles-and-ui)
- [Sessions](#sessions)
- [Plugins and packages (`<Leader>p`)](#plugins-and-packages)
- [File / general](#file--general)

---

## Moving around the screen (jump)

Plugin: **flash.nvim**. Keywords: *jump, leap, go to, motion, navigate fast, treesitter*.

| Key | Mode | What for / search |
|-----|------|-------------------|
| `s` + characters | n, x, o | **Jump anywhere on screen** — type 1-2 chars and pick the label |
| `S` | n, x, o | **Jump by Treesitter block** (functions, if, tables) — AST node selection |
| `R` | x, o | **Treesitter search** — extend the selection to labelled nodes |
| `r` | o | **Remote Flash** — apply an operator (e.g. `yr`) somewhere remote without moving the cursor |
| `f` `t` `F` `T` | n | Classic character motions, enhanced with Flash labels |
| `/` `?` | n | Normal search; Flash adds labels to jump to any match |

> Note: in visual mode `s` becomes "Flash" (it used to delete the selection). Use `c` to change.

## Search and replace (grug-far)

Plugin: **grug-far.nvim**. Keywords: *replace, search and replace, substitute, rename refactor, find and replace, change across the project*.

| Key | Mode | What for / search |
|-----|------|-------------------|
| `<Leader>ss` | n | **Search/Replace across the whole workspace** (entire project, live preview) |
| `<Leader>se` | n | Search/Replace **only in files of the same type** as the current one (e.g. `*.tf`) |
| `<Leader>sf` | n | Search/Replace **only in the current file** |
| `<Leader>sw` | n | **Replace the word under the cursor** across the project |
| `<Leader>s` | v/x | **Replace the selected text** across the project |
| `gS` | n | Inside **Neo-tree** or **Oil**: replace within the directory under the cursor |

> The grug-far buffer is edited as text: change the search/replace terms at the
> top and apply. Requires `ripgrep` (`rg`) installed.

## Finding things (Telescope / find)

Keywords: *find file, open file, grep, find word, search project, find command, fuzzy finder, history, marks, keymap*.

| Key | What for / search |
|-----|-------------------|
| `<Leader>ff` | **Find files** (fuzzy) in the project |
| `<Leader>fF` | Find **all** files (including hidden/ignored) |
| `<Leader>fw` | **Find word/text** across the project (live grep) |
| `<Leader>fW` | Find text in **all** files |
| `<Leader>fc` | Find the **word under the cursor** across the project |
| `<Leader>fb` | Find among open **buffers** |
| `<Leader>fo` | **Recent** files (old files) |
| `<Leader>fp` | Find / switch **project** |
| `<Leader>fh` | Search the **help** (`:help`) |
| `<Leader>fk` | **Find keymaps** — the shortcut for finding any shortcut |
| `<Leader>fC` | Find **commands** |
| `<Leader>fT` | Find the project's **TODOs** |
| `<Leader>ft` | Switch **theme** (colorscheme) |
| `<Leader>fr` | Search **registers** |
| `<Leader>fu` | **Undo** history |
| `<Leader>f'` | Find **marks** |
| `<Leader>fn` | Find past **notifications** |
| `<Leader>f<CR>` | **Resume** the last search |

## Files and explorer (Neo-tree, Oil)

Keywords: *explorer, file tree, sidebar, rename file, create file, delete file, move file, browse folders*.

| Key | What for / search |
|-----|-------------------|
| `<Leader>e` | **Open/close the explorer** (Neo-tree, sidebar) |
| `<Leader>o` | Focus the explorer (or go back to the editor) |
| `<Leader>O` | **Open the current folder in Oil** (edit the filesystem as a buffer) |
| `<Leader>n` | **New file** |
| `<Leader>R` | **Rename** the current file |

**Oil** (`oil.nvim`) — keywords: *edit filesystem, rename as text, manage files in a buffer*.
Open it with `<Leader>O` and edit the file listing as if it were plain text:
- Type a new name and save (`:w`) to **create** a file/folder.
- Edit a line to **rename**.
- Delete the line to **remove**.
- `-` goes up to the parent directory; `<CR>` enters the folder/file.
- `gS` (with grug-far) to search/replace inside that directory.

## Git (status, commits, diff, blame)

Keywords: *git, commit, branch, stash, status, blame, hunk, stage, lazygit*.

| Key | What for / search |
|-----|-------------------|
| `<Leader>gg` | **Open lazygit** (full git TUI: stage, commit, branch, rebase) |
| `<Leader>gt` | Git **status** (Telescope) |
| `<Leader>gb` | Git **branches** |
| `<Leader>gc` | Git **commits** for the repository |
| `<Leader>gC` | Git commits **for the current file** |
| `<Leader>gT` | Git **stash** |
| `<Leader>go` | **Open in the browser** (git browse) — also works on a visual range |

**Gitsigns** (column markers, hunks) — use the jumps between changes:

| Key | What for / search |
|-----|-------------------|
| `]r` / `[r` | Go to the **next/previous reference** (word highlight) |

> For hunk staging/reset and inline blame, gitsigns exposes commands and `<Leader>g` in which-key; explore the menu with <kbd>Space</kbd>`g`.

## Diff and merge conflicts (Diffview)

Plugin: **diffview.nvim**. It uses **no leader keymaps**, it's driven by commands (`:`).
Keywords: *diff, compare changes, review changes, file history, merge conflict, resolve conflict, review*.

| Command | What for / search |
|---------|-------------------|
| `:DiffviewOpen` | **Open the diff** of every modified file (working tree) |
| `:DiffviewOpen main..HEAD` | Compare against another branch/rev |
| `:DiffviewOpen HEAD~2` | Compare against an earlier commit |
| `:DiffviewFileHistory %` | **History of the current file** (who changed what) |
| `:DiffviewFileHistory` | History of the whole repository |
| `:DiffviewClose` | Close the diff view |
| `:DiffviewToggleFiles` | Show/hide the side file panel |

> To **resolve merge conflicts**: run `:DiffviewOpen` during a merge/rebase with
> conflicts and you get the versions side by side to choose from.

## Buffers and tabs

Keywords: *buffer, close buffer, switch open file, tab, next buffer*.

| Key | What for / search |
|-----|-------------------|
| `]b` / `[b` | **Next / previous** buffer |
| `>b` / `<b` | **Move** the buffer tab right / left |
| `<Leader>c` | **Close** the current buffer |
| `<Leader>C` | **Force close** the buffer (discards changes) |
| `<Leader>bb` | **Pick** a buffer from the tabline |
| `<Leader>bd` | Close a buffer by picking it from the tabline |
| `<Leader>bc` | Close **all but the current one** |
| `<Leader>bC` | Close **all** buffers |
| `<Leader>bl` / `<Leader>br` | Close every buffer **to the left / right** |
| `<Leader>b\` / `<Leader>b|` | Open the buffer in a **horizontal / vertical** split |
| `]t` / `[t` | **Next / previous** tab |

## Windows / splits

Keywords: *split, divide window, pane, move between windows, resize*.

| Key | What for / search |
|-----|-------------------|
| `\` | **Horizontal split** |
| `|` | **Vertical split** |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | **Move** to the split left / down / up / right |
| `<C-Left>` / `<C-Right>` | **Resize** the split (width) |
| `<C-Up>` / `<C-Down>` | Multicursor: add a cursor **above / below** (see Editing text) |
| `<Leader>q` | Close the window |

> Note: `<C-h/j/k/l>` work both for moving between splits and inside the terminal.

## Editing text

Keywords: *comment, surround, quotes, parentheses, move line, multicursor, indent, blank line*.

**Comments** (`gc`):

| Key | Mode | What for / search |
|-----|------|-------------------|
| `gcc` | n | **Comment/uncomment the line** |
| `gc` | v/x | **Comment/uncomment the selection** |
| `gc` + motion | n | Comment a textobject (e.g. `gcap` for a paragraph) |
| `gco` / `gcO` | n | Add a comment **below / above** |
| `<Leader>/` | n, v | Comment line / selection (alias) |

**Surround with pairs** (mini.surround, `gz`) — *quotes, brackets, tags*:

| Key | What for / search |
|-----|-------------------|
| `gza` | **Add** a surrounding pair (e.g. `gzaiw"` wraps the word in quotes) |
| `gzd` | **Delete** the surrounding pair |
| `gzr` | **Replace** the surrounding pair (e.g. `"` with `'`) |
| `gzf` / `gzF` | Find the pair to the right / left |
| `gzh` | Highlight the surrounding pair |

**Move text** (mini.move):

| Key | Mode | What for / search |
|-----|------|-------------------|
| `<M-h>` `<M-j>` `<M-k>` `<M-l>` | n | Move the **line** left/down/up/right |
| `<M-h>` `<M-j>` `<M-k>` `<M-l>` | v/x | Move the **selection** |

**Multiple cursors** (vim-visual-multi):

| Key | What for / search |
|-----|-------------------|
| `<C-Up>` / `<C-Down>` | Add a **cursor above / below** |

**Lines and indentation:**

| Key | Mode | What for / search |
|-----|------|-------------------|
| `[ ` (space) | n | Insert a **blank line above** |
| `] ` (space) | n | Insert a **blank line below** |
| `<Tab>` / `<S-Tab>` | v/x | **Indent / unindent** the selection |

## LSP: code, diagnostics, symbols

Keywords: *go to definition, references, rename symbol, code action, error, warning, diagnostic, hover, autocomplete, format, implementation*.

| Key | Mode | What for / search |
|-----|------|-------------------|
| `grn` | n | **Rename** the symbol under the cursor (project-wide) |
| `gra` | n, v/x | **Code action** (quick fixes, refactors) |
| `grr` | n | Find **references** to the symbol |
| `gri` | n | Go to the **implementation** |
| `grt` | n | Go to the **type definition** |
| `gD` | n | Go to the **declaration** |
| `gO` | n | **Document symbols** |
| `gl` / `<Leader>ld` | n | **Diagnostic hover** (see the error/warning at point) |
| `<Leader>ls` | n | Find **symbols** (Telescope) |
| `<Leader>lS` | n | Symbol **outline** (aerial) |
| `<Leader>lD` | n | Find the project's **diagnostics** |
| `]d` / `[d` | n | Go to the **next / previous diagnostic** |
| `]e` / `[e` | n | Go to the next / previous **error** |
| `]w` / `[w` | n | Go to the next / previous **warning** |
| `[D` / `]D` | n | Go to the **first / last** diagnostic in the buffer |
| `<C-w>d` | n | Show the diagnostic under the cursor in a window |

> **Format on save** is enabled globally (AstroLSP). Completion uses **blink.cmp**.

## Debug (DAP)

Keywords: *debug, breakpoint, step, step by step, REPL, watch, inspect*.

| Key | What for / search | Alt. F key |
|-----|-------------------|------------|
| `<Leader>db` | **Toggle breakpoint** | `<F9>` |
| `<Leader>dC` | **Conditional** breakpoint | `<S-F9>` |
| `<Leader>dB` | **Clear** all breakpoints | |
| `<Leader>dc` | **Start / continue** | `<F5>` |
| `<Leader>di` | **Step into** | `<F11>` |
| `<Leader>do` | **Step over** | `<F10>` |
| `<Leader>dO` | **Step out** | `<S-F11>` |
| `<Leader>dp` | **Pause** | `<F6>` |
| `<Leader>dr` | **Restart** session | `<C-F5>` |
| `<Leader>dQ` | **Terminate** session | `<S-F5>` |
| `<Leader>dq` | Close session | |
| `<Leader>ds` | Run **to cursor** | |
| `<Leader>dh` | Debugger **hover** (inspect a value) | |
| `<Leader>dE` | **Evaluate** an expression (input) | |
| `<Leader>dR` | Toggle **REPL** | |
| `<Leader>du` | Toggle **debugger UI** | |

## Terminal

Keywords: *terminal, console, shell, floating, lazygit, python, node*.

| Key | Mode | What for / search |
|-----|------|-------------------|
| `<C-'>` / `<F7>` | n, i, t | Quick **terminal toggle** |
| `<Leader>tf` | n | **Floating** terminal (NvZone Floaterm) |
| `<Leader>tF` | n | Floating terminal (ToggleTerm) |
| `<Leader>th` | n | Terminal in a **horizontal** split |
| `<Leader>tv` | n | Terminal in a **vertical** split |
| `<Leader>tl` / `<Leader>gg` | n | **lazygit** in a terminal |
| `<Leader>tn` | n | **node** terminal |
| `<Leader>tp` | n | **python** terminal |
| `<C-h/j/k/l>` | t | Move to another window from the terminal |

## AI (Kiro / Claude Code)

Keywords: *AI, assistant, chat, kiro, claude, copilot, add context, diagnostics to chat*.

**Kiro CLI** (`<Leader>ak`):

| Key | Mode | What for / search |
|-----|------|-------------------|
| `<Leader>akk` | n, v | **Toggle** the Kiro session (show/hide) |
| `<Leader>akn` | n | **New** Kiro session |
| `<Leader>akr` | n | **Resume** the most recent session |
| `<Leader>akl` | n | **List/pick** a session (kiro-cli picker) |
| `<Leader>akR` | n | **Restore** this directory's session |
| `<Leader>akx` | n | **Close/destroy** the session |
| `<Leader>aka` | n | **Add the current file** to the chat |
| `<Leader>aka` | v | **Add the selection** to the chat |
| `<Leader>akd` | n | Add the **line's diagnostics** to the chat |
| `<Leader>akD` | n | Add the **buffer's diagnostics** to the chat |

**Claude Code** (`<Leader>a`):

| Key | Mode | What for / search |
|-----|------|-------------------|
| `<Leader>ac` | n | **Toggle** Claude |
| `<Leader>af` | n | **Focus** Claude |
| `<Leader>ar` | n | **Resume** Claude |
| `<Leader>aC` | n | **Continue** Claude |
| `<Leader>am` | n | **Pick a model** |
| `<Leader>ab` | n | Add the **current buffer** |
| `<Leader>as` | v | **Send the selection** |
| `<Leader>aa` | n | **Accept** the proposed diff |
| `<Leader>ad` | n | **Reject** the diff |

## Toggles and UI

Keywords: *enable, disable, toggle, line numbers, wrap, spell, zen, dark theme, indent, conceal, diagnostics on/off*.

| Key | What for / search |
|-----|-------------------|
| `<Leader>uZ` | **Zen mode** (focus, no distractions) |
| `<Leader>uw` | Toggle **wrap** |
| `<Leader>un` | Change line **numbering** |
| `<Leader>us` | Toggle **spellcheck** |
| `<Leader>ud` | Toggle **diagnostics** |
| `<Leader>uv` | Toggle diagnostic **virtual text** |
| `<Leader>uV` | Toggle diagnostic **virtual lines** |
| `<Leader>ub` | Toggle **light/dark** background |
| `<Leader>uC` / `<Leader>uc` | Toggle **completion** (global / buffer) |
| `<Leader>ua` | Toggle **autopairs** |
| `<Leader>ui` | Change the **indent** |
| `<Leader>u\|` | Toggle **indent guides** |
| `<Leader>uS` | Toggle **conceal** |
| `<Leader>uz` | Toggle **color highlighting** |
| `<Leader>uD` | **Dismiss** notifications |
| `<Leader>ul` | Toggle **statusline** |
| `<Leader>ut` | Toggle **tabline** |
| `<Leader>ug` | Toggle **signcolumn** |
| `<Leader>uy` | Toggle **syntax highlight** (buffer) |
| `<Leader>uu` | Toggle **URL highlighting** |

## Sessions

Keywords: *session, save session, restore workspace, dirsession, resume project*.

| Key | What for / search |
|-----|-------------------|
| `<Leader>Ss` | **Save** this session |
| `<Leader>Sl` | Load the **last** session |
| `<Leader>Sf` | **Load** a session |
| `<Leader>Sd` | **Delete** a session |
| `<Leader>St` | Save **this tab's** session |
| `<Leader>SS` | Save the **dirsession** (per directory) |
| `<Leader>S.` | Load the current directory's dirsession |
| `<Leader>SF` | Load a dirsession |
| `<Leader>SD` | Delete a dirsession |

## Plugins and packages

Keywords: *lazy, mason, install plugin, update, sync, LSP install*.

| Key | What for / search |
|-----|-------------------|
| `<Leader>pi` | **Install** plugins (Lazy) |
| `<Leader>ps` | Plugin **status** (Lazy) |
| `<Leader>pS` | Plugin **sync** |
| `<Leader>pu` | Check for **updates** |
| `<Leader>pU` | **Update** plugins |
| `<Leader>pa` | Update **Lazy and Mason** together |
| `<Leader>pm` | Open **Mason** (LSP/formatter/DAP installer) |
| `<Leader>pM` | **Update** Mason packages |

## File / general

Keywords: *save, quit, new file, home, dashboard, quickfix*.

| Key | What for / search |
|-----|-------------------|
| `<Leader>w` | **Save** the file |
| `<C-s>` | **Force save** |
| `<Leader>n` | **New** file |
| `<Leader>h` | Home screen (**dashboard**) |
| `<Leader>q` | Close the window |
| `<Leader>Q` | **Quit** Neovim |
| `<C-q>` | Force quit |
| `<Leader>xq` | **Quickfix** list |
| `<Leader>xl` | **Location** list |
| `]q` / `[q` | Next / previous quickfix entry |

---

## Notable plugins in this config

| Plugin | What it adds |
|--------|--------------|
| **flash.nvim** | Labelled on-screen jumps (`s`, `S`) |
| **grug-far.nvim** | Project-wide search/replace with preview (`<Leader>s…`) |
| **diffview.nvim** | Diff view, file history and merge conflicts (`:DiffviewOpen`) |
| **oil.nvim** | Edit the filesystem as a buffer (`<Leader>O`) |
| **snacks.nvim** | Dashboard, terminal, picker, notifications, lazygit |
| **neo-tree** | File explorer in a sidebar (`<Leader>e`) |
| **gitsigns** | Git markers in the column, hunks, blame |
| **which-key** | Keymap discovery menu (press `<Leader>`) |
| **mini.surround / mini.move** | Surround with pairs (`gz`), move lines (`<M-…>`) |
| **vim-visual-multi** | Multiple cursors (`<C-Up>`/`<C-Down>`) |

Active language packs (LSP + formatting + debug): Lua, YAML, Go, Bash, Docker,
Terraform, Python, JSON, HTML/CSS, Helm.

## Install

This config is part of the dotfiles repo: the root installer links
`~/.config/nvim` here and installs the external tools for you.

```shell
git clone git@github.com:cesarbqz/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles
./install.sh
```

To link only Neovim, without touching tmux or the package manager:

```shell
./nvim/install.sh
```

If you already had a `~/.config/nvim`, the installer moves it to
`~/.config/nvim.bak-<timestamp>` instead of deleting it. Plugin state
(`~/.local/share/nvim`, `~/.local/state/nvim`, `~/.cache/nvim`) is left
untouched; if you are coming from another config and something behaves oddly,
move those three directories to `.bak` and start `nvim` again.

The first time you open `nvim`, lazy.nvim installs the plugins at the versions
pinned in `lazy-lock.json`. When you add or update plugins, commit that file so
every other machine ends up identical.

## Requirements

The full list is in the [root README](../README.md#requirements). In short, for
this Neovim config:

`install.sh` installs with `brew` or `apt-get`:

- **Neovim ≥ 0.10** — AstroNvim v5 won't start on anything older.
- **ripgrep** (`rg`) — needed by grug-far and Telescope's live grep.
- **fd** — speeds up file searching.
- **lazygit** — git TUI (`<Leader>gg`).
- A **Nerd Font** enabled in the terminal — otherwise the icons render as boxes.

And these you provide yourself, because your version manager owns them (nvm,
pyenv, goenv). `install.sh` only checks whether they are present:

- **node** — the LSPs Mason installs through npm: bash, json, yaml, html/css, docker, emmet, `prettierd`.
- **go** — `gopls`, `delve`, `goimports` and the rest of the Go pack.
- **python3** — `debugpy`, `black`, `isort`.
- **deno** — `peek.nvim`, the markdown preview.
- **A C compiler** — for the treesitter parsers.

Miss one and that part stops working while everything else is fine. The active
language packs live in [`lua/community.lua`](lua/community.lua): drop one and you
no longer need its runtime.
