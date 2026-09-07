#!/bin/sh
# installs oh-my-tmux, links ~/.config/tmux -> this directory and generates
# tmux.conf (a symlink to oh-my-tmux, which tmux.conf.local customizes).
# if a real ~/.config/tmux is already there, it is moved to tmux.bak-<timestamp>.
# safe to re-run.
set -e

dotfiles_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
config_link="${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
oh_my_tmux="$HOME/.local/share/tmux/oh-my-tmux"

if [ ! -d "$oh_my_tmux" ]; then
  echo "installing oh-my-tmux -> $oh_my_tmux"
  mkdir -p "$(dirname "$oh_my_tmux")"
  git clone --depth 1 https://github.com/gpakosz/.tmux.git "$oh_my_tmux"
else
  echo "oh-my-tmux already present"
fi

# tmux.conf points at oh-my-tmux's .tmux.conf with an absolute path and is
# regenerated on every machine, which is why it is gitignored. it has to be a
# symlink to the real file — not a source-file wrapper — because oh-my-tmux
# runs $TMUX_CONF as a script ("cut -c3- $TMUX_CONF | sh") to manage its
# plugins, and a wrapper would leave tpm uninstalled.
if [ "$(readlink "$dotfiles_dir/tmux.conf" 2>/dev/null)" = "$oh_my_tmux/.tmux.conf" ]; then
  echo "tmux.conf already points at oh-my-tmux"
else
  echo "generating tmux.conf -> $oh_my_tmux/.tmux.conf"
  ln -sfn "$oh_my_tmux/.tmux.conf" "$dotfiles_dir/tmux.conf"
fi

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

# oh-my-tmux looks for its config in ~/.tmux.conf before $XDG_CONFIG_HOME:
# if that exists it wins and this config is ignored.
if [ -e "$HOME/.tmux.conf" ]; then
  echo "warning: $HOME/.tmux.conf exists and takes priority over $config_link/tmux.conf" >&2
fi

# tmux.conf.local calls scripts/session_age.sh through a fixed path
# (~/.config/tmux/...) because tmux's parser rejects ${XDG_CONFIG_HOME} inside
# a #(). with a non-default XDG_CONFIG_HOME the status-bar clock comes up
# empty; everything else works the same.
if [ -n "$XDG_CONFIG_HOME" ] && [ "$XDG_CONFIG_HOME" != "$HOME/.config" ]; then
  echo "warning: XDG_CONFIG_HOME=$XDG_CONFIG_HOME; the status-bar session timer will not resolve" >&2
fi

if [ ! -e "$config_link/tmux.conf" ]; then
  echo "$config_link/tmux.conf does not resolve" >&2
  exit 1
fi

echo "done — run 'tmux kill-server' and start a new session"
