# dotfiles

**Neovim** (AstroNvim v5) and **tmux** (oh-my-tmux) configuration, built to come
up on any machine with a single command.

## How it looks

Neovim (AstroNvim + catppuccin) with the file explorer open, running inside tmux:

![Neovim with neo-tree, tabline and statusline, inside tmux](docs/nvim.png)

tmux with the oh-my-tmux status bar and three panes — git history, the installer,
and repo status:

![tmux with three panes and the oh-my-tmux status bar](docs/tmux.png)

Both screenshots are generated from [`docs/demo.tape`](docs/demo.tape), so they
can be remade whenever the config changes:

```shell
brew install vhs
vhs docs/demo.tape
```

It uses the symlinks `install.sh` created, which means it reflects what is
actually committed here. It runs tmux on its own socket (`-L vhs`) so it never
touches your sessions.

## Requirements

### Before you start

The only things you strictly need to get going:

| Requirement | Why |
| --- | --- |
| **git ≥ 2.19** | To clone the repo, and because lazy.nvim uses *partial clone* (`--filter=blob:none`). |
| **A true-color terminal with a Nerd Font enabled** | The status bar and Neovim's icons need it; without the font you get boxes. |
| **`TERM=xterm-256color`** outside tmux | oh-my-tmux requires it for colors to come out right. |
| **awk, perl, grep, sed** | Used by oh-my-tmux. Present out of the box on macOS and any Linux. |
| **`brew` or `apt-get`** | Only if you want `install.sh` to install the dependencies. With neither, it warns and you install them by hand. |

### What `./install.sh` installs for you

| Package | What for |
| --- | --- |
| `neovim` **≥ 0.10** | AstroNvim v5 aborts on anything older. |
| `tmux` **≥ 2.6** | The minimum oh-my-tmux requires. |
| `git` | See above. |
| `ripgrep` (`rg`) | grug-far and Telescope's live grep. |
| `fd` | Speeds up file searching. |
| `lazygit` | Git TUI (`<Leader>gg`). Not in apt: on Debian/Ubuntu install it separately. |
| JetBrainsMono Nerd Font | macOS only, via brew, and only if no Nerd Font is already installed. |

> **Careful with Neovim on Linux:** `apt` on stable distros often ships a version
> older than 0.10, which AstroNvim refuses to start on. `install.sh` checks the
> version and warns; if it falls short, use the binary from
> [Neovim releases](https://github.com/neovim/neovim/releases), a PPA, or brew.

### Runtimes the plugins need

These are **deliberately not installed for you**: you normally manage them with
nvm, pyenv or goenv, and installing them over brew/apt would shadow that setup.
`install.sh` only checks whether they are there and tells you what is missing.

Anything you don't have simply doesn't work; the rest of the editor is fine.

| Runtime | What stops working without it |
| --- | --- |
| **node** / npm | The LSPs Mason installs through npm: bash, json, yaml, html/css, docker, emmet, and `prettierd`. |
| **go** | `gopls`, `delve`, `goimports` and the rest of the Go pack (Mason builds them with `go install`). |
| **python3** + pip | `debugpy`, `black`, `isort`. |
| **deno** | `peek.nvim`, the markdown preview (its `build` runs `deno task`). |
| **A C compiler** (`cc`/`gcc`/`clang`) | Compiling the treesitter parsers. On macOS it comes with the Xcode Command Line Tools (`xcode-select --install`); on Debian/Ubuntu, `build-essential`. |
| `curl`, `unzip`, `tar` | Mason uses them to download and unpack prebuilt binaries. Usually present already. |

On Linux, the system clipboard in Neovim needs `xclip` (X11) or `wl-clipboard`
(Wayland).

## Install

```shell
git clone git@github.com:cesarbqz/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles
./install.sh
```

The repo can live anywhere (`~/dotfiles`, `~/code/dotfiles`, …): the links are
resolved from the script's real location.

`./install.sh` does four things, and is safe to re-run:

1. **Installs the missing dependencies** with `brew` or `apt-get` (the second
   table above). `--no-deps` skips this step and never touches the package
   manager.
2. **Links** `~/.config/nvim` and `~/.config/tmux` to this repo's directories.
   If a real config was already there, it is moved to `<name>.bak-<timestamp>`;
   nothing is ever deleted.
3. **Installs oh-my-tmux** into `~/.local/share/tmux/oh-my-tmux` and generates
   `tmux/tmux.conf` pointing at it.
4. **Checks** the Neovim version and which runtimes are missing, without
   installing them.

Then: open `nvim` (lazy.nvim syncs the plugins from `lazy-lock.json` and Mason
installs the LSPs) and run `tmux kill-server` before starting a new session.

Each tool also has a standalone installer (`nvim/install.sh`, `tmux/install.sh`)
in case you only want to link one.

## What's in here

| Path | What it is |
| --- | --- |
| `nvim/` | AstroNvim v5 config. Keymaps documented in [nvim/README.md](nvim/README.md). |
| `nvim/lua/community.lua` | Active language packs: Lua, YAML, Go, Bash, Docker, Terraform, Python, JSON, HTML/CSS, Helm. These are what determine which runtimes you need. |
| `nvim/lazy-lock.json` | Exact plugin versions. Commit it so every machine ends up identical. |
| `tmux/tmux.conf.local` | Your oh-my-tmux customizations (theme, status bar, plugins). |
| `tmux/scripts/` | Scripts used by the status bar. |

## What isn't versioned

- `tmux/tmux.conf` — a symlink with an absolute path to each machine's
  oh-my-tmux, so `tmux/install.sh` generates it. It has to be a symlink to the
  real file (not a `source-file` wrapper): oh-my-tmux runs `tmux.conf` itself as
  a script to manage its plugins.
- `tmux/plugins/` — where oh-my-tmux clones its plugins (tpm, resurrect, …).

## Staying in sync

```shell
cd ~/.config/dotfiles && git pull && ./install.sh
```

When you change Neovim plugins, commit `lazy-lock.json` along with the change.

## Things to keep in mind

- If `~/.tmux.conf` exists, tmux gives it priority and this config is ignored.
  The installer warns about it.
- `tmux.conf.local` calls `scripts/session_age.sh` through the fixed path
  `~/.config/tmux/...`, because tmux's parser rejects `${XDG_CONFIG_HOME}` inside
  a `#()`. With a non-default `XDG_CONFIG_HOME` the status-bar timer comes up
  empty and everything else works the same; the installer warns about this too.
