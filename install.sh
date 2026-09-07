#!/bin/sh
# bootstrap de estos dotfiles: instala las dependencias externas y enlaza
# cada configuración. es seguro re-ejecutarlo.
#
#   ./install.sh              instala dependencias + enlaza todo
#   ./install.sh --no-deps    solo enlaza (no toca el gestor de paquetes)
set -e

dotfiles_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
with_deps=1

for arg in "$@"; do
  case "$arg" in
    --no-deps) with_deps=0 ;;
    -h|--help) sed -n '2,6p' "$0" | cut -c3-; exit 0 ;;
    *) echo "opción desconocida: $arg (probá --help)" >&2; exit 2 ;;
  esac
done

# comando · paquete en brew · paquete en apt ("-" = no disponible ahí)
deps='nvim neovim neovim
tmux tmux tmux
git git git
rg ripgrep ripgrep
fd fd fd-find
lazygit lazygit -'

have() {
  case "$1" in
    # en debian/ubuntu el binario de fd-find se llama fdfind
    fd) command -v fd >/dev/null 2>&1 || command -v fdfind >/dev/null 2>&1 ;;
    *) command -v "$1" >/dev/null 2>&1 ;;
  esac
}

nerd_font_installed() {
  ls "$HOME/Library/Fonts" /Library/Fonts 2>/dev/null | grep -qi nerd
}

install_deps() {
  faltan='' pkgs='' sin_paquete=''
  while read -r cmd brew_pkg apt_pkg; do
    [ -n "$cmd" ] || continue
    have "$cmd" && continue
    faltan="$faltan $cmd"
    case "$manager" in
      brew) pkg=$brew_pkg ;;
      apt) pkg=$apt_pkg ;;
    esac
    if [ "$pkg" = "-" ]; then
      sin_paquete="$sin_paquete $cmd"
    else
      pkgs="$pkgs $pkg"
    fi
  done <<EOF
$deps
EOF

  if [ -n "$pkgs" ]; then
    echo "instalando:$pkgs"
    case "$manager" in
      brew) brew install $pkgs ;;
      apt) $sudo apt-get update && $sudo apt-get install -y $pkgs ;;
    esac
  elif [ -z "$faltan" ]; then
    echo "todas las dependencias ya están instaladas"
  fi

  [ -n "$sin_paquete" ] && echo "aviso: instalá a mano:$sin_paquete" >&2

  # la config usa iconos: sin una Nerd Font se ven como cuadraditos
  if [ "$manager" = brew ] && ! nerd_font_installed; then
    echo "instalando JetBrainsMono Nerd Font"
    brew install --cask font-jetbrains-mono-nerd-font
  elif [ "$manager" != brew ] && ! nerd_font_installed; then
    echo "aviso: instalá una Nerd Font (https://nerdfonts.com) y activala en tu terminal" >&2
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
    echo "aviso: sin brew ni apt-get; instalá a mano neovim tmux git ripgrep fd lazygit" >&2
  fi
  echo
fi

for tool in nvim tmux; do
  echo "== $tool =="
  sh "$dotfiles_dir/$tool/install.sh"
  echo
done

# runtime · para qué hace falta
# no se instalan solos a propósito: suelen manejarse con nvm/pyenv/goenv, y
# meterlos por brew/apt pisaría esa configuración.
runtimes='node|LSP de bash, json, yaml, html/css y docker, y prettierd
go|gopls, delve y el resto del pack de Go
python3|debugpy, black e isort
deno|peek.nvim (preview de markdown)
cc|compilar los parsers de treesitter'

echo "== comprobación =="

# AstroNvim v5 aborta con Neovim < 0.10; en algunas distros apt trae una anterior
if command -v nvim >/dev/null 2>&1 &&
   [ "$(nvim --clean --headless -c 'lua io.write(vim.fn.has("nvim-0.10"))' -c q 2>/dev/null)" != 1 ]; then
  echo "ERROR: AstroNvim necesita Neovim >= 0.10, tenés $(nvim --version | head -1)" >&2
  echo "       instalalo desde https://github.com/neovim/neovim/releases" >&2
fi

pendientes=0
while IFS='|' read -r cmd para; do
  [ -n "$cmd" ] || continue
  command -v "$cmd" >/dev/null 2>&1 && continue
  echo "falta $cmd — sin él no van: $para"
  pendientes=1
done <<EOF
$runtimes
EOF

if [ "$pendientes" -eq 1 ]; then
  echo "(el resto funciona igual; instalá lo que uses)"
else
  echo "todos los runtimes presentes"
fi
echo

echo "todo listo."
