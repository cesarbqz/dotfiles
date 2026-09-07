#!/bin/sh
# bootstrap for these dotfiles: installs the external dependencies and links
# every config. safe to re-run.
#
#   ./install.sh              install dependencies + link everything
#   ./install.sh --no-deps    link only (never touches the package manager)
set -e

dotfiles_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
with_deps=1

for arg in "$@"; do
  case "$arg" in
    --no-deps) with_deps=0 ;;
    -h|--help) sed -n '2,6p' "$0" | cut -c3-; exit 0 ;;
    *) echo "unknown option: $arg (try --help)" >&2; exit 2 ;;
  esac
done

# command · brew package · apt package ("-" = not available there)
deps='nvim neovim neovim
tmux tmux tmux
git git git
rg ripgrep ripgrep
fd fd fd-find
lazygit lazygit -'

have() {
  case "$1" in
    # on debian/ubuntu the fd-find binary is called fdfind
    fd) command -v fd >/dev/null 2>&1 || command -v fdfind >/dev/null 2>&1 ;;
    *) command -v "$1" >/dev/null 2>&1 ;;
  esac
}

nerd_font_installed() {
  ls "$HOME/Library/Fonts" /Library/Fonts 2>/dev/null | grep -qi nerd
}

install_deps() {
  missing='' pkgs='' unpackaged=''
  while read -r cmd brew_pkg apt_pkg; do
    [ -n "$cmd" ] || continue
    have "$cmd" && continue
    missing="$missing $cmd"
    case "$manager" in
      brew) pkg=$brew_pkg ;;
      apt) pkg=$apt_pkg ;;
    esac
    if [ "$pkg" = "-" ]; then
      unpackaged="$unpackaged $cmd"
    else
      pkgs="$pkgs $pkg"
    fi
  done <<EOF
$deps
EOF

  if [ -n "$pkgs" ]; then
    echo "installing:$pkgs"
    case "$manager" in
      brew) brew install $pkgs ;;
      apt) $sudo apt-get update && $sudo apt-get install -y $pkgs ;;
    esac
  elif [ -z "$missing" ]; then
    echo "all dependencies already installed"
  fi

  [ -n "$unpackaged" ] && echo "warning: install by hand:$unpackaged" >&2

  # the config uses icons: without a Nerd Font they render as boxes
  if [ "$manager" = brew ] && ! nerd_font_installed; then
    echo "installing JetBrainsMono Nerd Font"
    brew install --cask font-jetbrains-mono-nerd-font
  elif [ "$manager" != brew ] && ! nerd_font_installed; then
    echo "warning: install a Nerd Font (https://nerdfonts.com) and enable it in your terminal" >&2
  fi
}

if [ "$with_deps" -eq 1 ]; then
  sudo=''
  [ "$(id -u)" -ne 0 ] && command -v sudo >/dev/null 2>&1 && sudo=sudo

  if command -v brew >/dev/null 2>&1; then
    manager=brew
  elif command -v apt-get >/dev/null 2>&1; then
    manager=apt
  else
    manager=''
  fi

  if [ -n "$manager" ]; then
    install_deps
  else
    echo "warning: no brew or apt-get; install neovim tmux git ripgrep fd lazygit by hand" >&2
  fi
  echo
fi

for tool in nvim tmux; do
  echo "== $tool =="
  sh "$dotfiles_dir/$tool/install.sh"
  echo
done

# runtime · what needs it
# deliberately not installed for you: these are usually managed by
# nvm/pyenv/goenv, and installing them over brew/apt would shadow that setup.
runtimes='node|the bash, json, yaml, html/css and docker LSPs, and prettierd
go|gopls, delve and the rest of the Go pack
python3|debugpy, black and isort
deno|peek.nvim (markdown preview)
cc|compiling the treesitter parsers'

echo "== checks =="

# AstroNvim v5 aborts on Neovim < 0.10; apt on some distros ships an older one
if command -v nvim >/dev/null 2>&1 &&
   [ "$(nvim --clean --headless -c 'lua io.write(vim.fn.has("nvim-0.10"))' -c q 2>/dev/null)" != 1 ]; then
  echo "ERROR: AstroNvim needs Neovim >= 0.10, you have $(nvim --version | head -1)" >&2
  echo "       get it from https://github.com/neovim/neovim/releases" >&2
fi

pending=0
while IFS='|' read -r cmd needed_for; do
  [ -n "$cmd" ] || continue
  command -v "$cmd" >/dev/null 2>&1 && continue
  echo "missing $cmd — without it you lose: $needed_for"
  pending=1
done <<EOF
$runtimes
EOF

if [ "$pending" -eq 1 ]; then
  echo "(everything else still works; install what you use)"
else
  echo "all runtimes present"
fi
echo

echo "all done."
