#!/bin/sh
# enlaza ~/.config/nvim -> este directorio. si ya hay un directorio real ahí,
# se mueve a nvim.bak-<timestamp> en vez de borrarlo.
# es seguro re-ejecutarlo.
set -e

dotfiles_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
config_link="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

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

if [ ! -e "$config_link/init.lua" ]; then
  echo "$config_link/init.lua no resuelve" >&2
  exit 1
fi

echo "listo — abrí nvim; lazy.nvim sincroniza los plugins según lazy-lock.json"
