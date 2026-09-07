#!/bin/sh
# links ~/.config/nvim -> this directory. if a real directory is already there,
# it is moved to nvim.bak-<timestamp> instead of being deleted.
# safe to re-run.
set -e

dotfiles_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
config_link="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

if [ "$(readlink "$config_link" 2>/dev/null)" = "$dotfiles_dir" ]; then
  echo "$config_link already linked"
else
  if [ -e "$config_link" ] || [ -L "$config_link" ]; then
    backup="$config_link.bak-$(date +%Y%m%d%H%M%S)"
    echo "moving $config_link -> $backup"
    mv "$config_link" "$backup"
  fi
  echo "linking $config_link -> $dotfiles_dir"
  mkdir -p "$(dirname "$config_link")"
  ln -s "$dotfiles_dir" "$config_link"
fi

if [ ! -e "$config_link/init.lua" ]; then
  echo "$config_link/init.lua does not resolve" >&2
  exit 1
fi

echo "done — open nvim; lazy.nvim syncs the plugins from lazy-lock.json"
