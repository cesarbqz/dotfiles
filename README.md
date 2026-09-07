# dotfiles

Configuración de **Neovim** (AstroNvim) y **tmux** (oh-my-tmux), pensada para
levantarse en cualquier máquina con un solo comando.

## Instalación

```shell
git clone git@github.com:cesarbqz/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles
./install.sh
```

El repo puede vivir en cualquier ruta (`~/dotfiles`, `~/code/dotfiles`, …): los
enlaces se calculan desde la ubicación real del script.

`./install.sh` hace tres cosas, y es seguro re-ejecutarlo:

1. **Instala las dependencias** que falten con `brew` o `apt-get`:
   `neovim`, `tmux`, `git`, `ripgrep`, `fd`, `lazygit`, y una Nerd Font en macOS.
   Con `--no-deps` se saltea este paso y no se toca el gestor de paquetes.
2. **Enlaza** `~/.config/nvim` y `~/.config/tmux` a los directorios de este repo.
   Si ya había una config real ahí, se mueve a `<nombre>.bak-<timestamp>`; nunca
   se borra nada.
3. **Instala oh-my-tmux** en `~/.local/share/tmux/oh-my-tmux` y genera
   `tmux/tmux.conf` apuntando a él.

Después: abrí `nvim` (lazy.nvim sincroniza los plugins según `lazy-lock.json`) y
corré `tmux kill-server` antes de abrir una sesión nueva.

Cada herramienta tiene su instalador suelto (`nvim/install.sh`, `tmux/install.sh`)
por si querés enlazar solo una.

## Qué hay acá

| Ruta | Qué es |
| --- | --- |
| `nvim/` | Config de AstroNvim v5. Atajos documentados en [nvim/README.md](nvim/README.md). |
| `nvim/lazy-lock.json` | Versiones exactas de los plugins. Commiteálo para que todas las máquinas queden iguales. |
| `tmux/tmux.conf.local` | Tus personalizaciones de oh-my-tmux (tema, barra de estado, plugins). |
| `tmux/scripts/` | Scripts que usa la barra de estado. |

## Qué no se versiona

- `tmux/tmux.conf` — es un symlink con ruta absoluta al oh-my-tmux de cada
  máquina, así que lo genera `tmux/install.sh`. Tiene que ser un symlink al
  archivo real (no un `source-file`): oh-my-tmux ejecuta el propio `tmux.conf`
  como script para gestionar sus plugins.
- `tmux/plugins/` — ahí clona oh-my-tmux sus plugins (tpm, resurrect, …).

## Mantenerse sincronizado

```shell
cd ~/.config/dotfiles && git pull && ./install.sh
```

Al cambiar plugins de Neovim, commiteá `lazy-lock.json` junto con el cambio.

## Detalles a tener en cuenta

- Si existe `~/.tmux.conf`, tmux le da prioridad y esta config queda ignorada.
  El instalador avisa.
- `tmux.conf.local` llama a `scripts/session_age.sh` por la ruta fija
  `~/.config/tmux/...`, porque el parser de tmux rechaza `${XDG_CONFIG_HOME}`
  dentro de un `#()`. Con un `XDG_CONFIG_HOME` no estándar el contador de la
  barra queda vacío y el resto anda igual; el instalador también avisa.
- En Debian/Ubuntu `lazygit` no está en apt: se instala aparte.
