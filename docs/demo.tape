# Genera las capturas del README. Regenerar con:
#
#   brew install vhs && vhs docs/demo.tape
#
# Usa la config real de ~/.config (los symlinks que dejó install.sh), así que
# las imágenes reflejan lo que hay commiteado en este repo.
#
# tmux corre sobre un socket propio (-L vhs) para no tocar tus sesiones reales.

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

# --- preparación, fuera de cámara ---
# todo en un solo comando: el prompt de zsh descarta el typeahead, así que
# escribir varios comandos seguidos pierde los del medio. Cada panel arranca
# su proceso directamente en vez de usar send-keys, por el mismo motivo.
Hide
Type "export DISABLE_AUTO_UPDATE=true DISABLE_UPDATE_PROMPT=true; cd ~/.config/dotfiles; tmux -L vhs kill-server 2>/dev/null; tmux -L vhs new-session -d -s demo -x 200 -y 30 -c ~/.config/dotfiles 'git --no-pager log --oneline --graph --decorate -8; exec zsh' && tmux -L vhs split-window -h -t demo -c ~/.config/dotfiles './install.sh --no-deps; exec zsh' && tmux -L vhs split-window -v -t demo -c ~/.config/dotfiles 'git status --short --branch; exec zsh'; clear" Enter
Sleep 8s
Show

# --- tmux: barra de estado de oh-my-tmux y paneles ---
Type "tmux -L vhs attach -t demo" Enter
Sleep 4s
Screenshot docs/tmux.png

# --- neovim a ventana completa, dentro de tmux ---
Type "tmux -L vhs new-window -n editor -c ~/.config/nvim" Enter
Sleep 2s
Type "nvim lua/community.lua" Enter
Wait+Screen@40s /NORMAL/
Sleep 3s

# explorador de archivos: <Leader>e
Type " e"
Sleep 4s
Screenshot docs/nvim.png

# --- cierre ordenado ---
Hide
Escape
Type ":qa!"
Enter
Sleep 2s
Type "exit" Enter
Sleep 1s
Type "tmux -L vhs kill-server 2>/dev/null" Enter
Sleep 1s
