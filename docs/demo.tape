# Generates the README screenshots. Regenerate with:
#
#   brew install vhs && vhs docs/demo.tape
#
# Uses the real config in ~/.config (the symlinks install.sh created), so the
# images reflect what is actually committed in this repo.
#
# tmux runs on its own socket (-L vhs) so it never touches your real sessions.

Require nvim
Require tmux

Output docs/demo.gif

Set Shell "zsh"
Set FontFamily "JetBrainsMono Nerd Font"
Set FontSize 13
Set Width 1500
Set Height 700
Set Padding 15
Set Theme "Catppuccin Mocha"
Set TypingSpeed 50ms

# --- setup, off camera ---
# All in a single command: the zsh prompt discards typeahead, so typing several
# commands in a row loses the ones in between. Each pane starts its own process
# directly instead of being driven with send-keys, for the same reason.
# DISABLE_AUTO_UPDATE keeps oh-my-zsh from interrupting the panes with its
# update prompt.
Hide
Type "export DISABLE_AUTO_UPDATE=true DISABLE_UPDATE_PROMPT=true; cd ~/.config/dotfiles; tmux -L vhs kill-server 2>/dev/null; tmux -L vhs new-session -d -s demo -x 200 -y 30 -c ~/.config/dotfiles 'git --no-pager log --oneline --graph --decorate -8; exec zsh' && tmux -L vhs split-window -h -t demo -c ~/.config/dotfiles './install.sh --no-deps; exec zsh' && tmux -L vhs split-window -v -t demo -c ~/.config/dotfiles 'nvim --version | head -1; tmux -V; rg --version | head -1; exec zsh'; clear" Enter
Sleep 8s
Show

# --- tmux: oh-my-tmux status bar and panes ---
Type "tmux -L vhs attach -t demo" Enter
Sleep 4s
Screenshot docs/tmux.png

# --- neovim full window, inside tmux ---
Type "tmux -L vhs new-window -n editor -c ~/.config/nvim" Enter
Sleep 2s
Type "nvim lua/community.lua" Enter
Wait+Screen@40s /NORMAL/
Sleep 3s

# file explorer: <Leader>e
Type " e"
Sleep 4s
Screenshot docs/nvim.png

# --- clean shutdown ---
Hide
Escape
Type ":qa!"
Enter
Sleep 2s
Type "exit" Enter
Sleep 1s
Type "tmux -L vhs kill-server 2>/dev/null" Enter
Sleep 1s
