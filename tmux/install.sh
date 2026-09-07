#!/bin/sh
# instala oh-my-tmux, enlaza ~/.config/tmux -> este directorio y genera
# tmux.conf (symlink a oh-my-tmux, que tmux.conf.local personaliza).
# si ya hay un ~/.config/tmux real, se mueve a tmux.bak-<timestamp>.
# es seguro re-ejecutarlo.
set -e

dotfiles_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
config_link="${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
oh_my_tmux="$HOME/.local/share/tmux/oh-my-tmux"

if [ ! -d "$oh_my_tmux" ]; then
  echo "instalando oh-my-tmux -> $oh_my_tmux"
  mkdir -p "$(dirname "$oh_my_tmux")"
  git clone --depth 1 https://github.com/gpakosz/.tmux.git "$oh_my_tmux"
else
  echo "oh-my-tmux ya presente"
fi

# tmux.conf apunta al .tmux.conf de oh-my-tmux con una ruta absoluta, y se
# regenera en cada máquina: por eso está en .gitignore. tiene que ser un
# symlink al archivo real —no un wrapper con source-file— porque oh-my-tmux
# ejecuta $TMUX_CONF como script ("cut -c3- $TMUX_CONF | sh") para gestionar
# los plugins, y un wrapper dejaría a tpm sin instalar.
if [ "$(readlink "$dotfiles_dir/tmux.conf" 2>/dev/null)" = "$oh_my_tmux/.tmux.conf" ]; then
  echo "tmux.conf ya apunta a oh-my-tmux"
else
  echo "generando tmux.conf -> $oh_my_tmux/.tmux.conf"
  ln -sfn "$oh_my_tmux/.tmux.conf" "$dotfiles_dir/tmux.conf"
fi

if [ "$(readlink "$config_link" 2>/dev/null)" = "$dotfiles_dir" ]; then
  echo "$config_link ya enlazado"
else
  if [ -e "$config_link" ] || [ -L "$config_link" ]; then
    backup="$config_link.bak-$(date +%Y%m%d%H%M%S)"
    echo "moviendo $config_link -> $backup"
    mv "$config_link" "$backup"
  fi
  echo "enlazando $config_link -> $dotfiles_dir"
  mkdir -p "$(dirname "$config_link")"
  ln -s "$dotfiles_dir" "$config_link"
fi

# oh-my-tmux busca su config en ~/.tmux.conf antes que en $XDG_CONFIG_HOME:
# si existe, gana y esta configuración queda ignorada.
if [ -e "$HOME/.tmux.conf" ]; then
  echo "aviso: $HOME/.tmux.conf existe y tiene prioridad sobre $config_link/tmux.conf" >&2
fi

# tmux.conf.local llama a scripts/session_age.sh por una ruta fija
# (~/.config/tmux/...) porque el parser de tmux rechaza ${XDG_CONFIG_HOME}
# dentro de un #(). con un XDG_CONFIG_HOME no estándar el reloj de la barra
# de estado queda vacío; todo lo demás funciona igual.
if [ -n "$XDG_CONFIG_HOME" ] && [ "$XDG_CONFIG_HOME" != "$HOME/.config" ]; then
  echo "aviso: XDG_CONFIG_HOME=$XDG_CONFIG_HOME; el contador de sesión de la barra no va a resolver" >&2
fi

if [ ! -e "$config_link/tmux.conf" ]; then
  echo "$config_link/tmux.conf no resuelve" >&2
  exit 1
fi

echo "listo — corré 'tmux kill-server' y abrí una sesión nueva"
