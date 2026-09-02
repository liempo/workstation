# Shell

Shell config lives in `home/shell.nix`.
Home-manager enables Zsh with oh-my-zsh (agnoster theme).
Integrations: fzf, zoxide, direnv.

SSH key auto-load at login lives in `home/git.nix` next to `gitAccounts`.
It is not in this module.

## Helpers

| Command | Alias | Purpose |
|---------|-------|---------|
| `drs` | none | Rebuild system config. Use `drs --impure` for writable symlinks. |
| `lap` | `tat` | Attach or create a tmux session named after the current directory. |
| `vact` | none | Activate or deactivate `./.venv` by directory. |

### lap / tat

1. Set the session name to the basename of `$PWD` (dots removed).
2. If the session exists, attach to it.
3. If `.envrc` exists, start the session with `direnv exec`.
4. Otherwise, start a plain new session.

### drs

F1-themed shorthand: Drag Reduction System equals deploy config changes.
See [rebuild.md](rebuild.md).

### lap

F1-themed shorthand: start or rejoin a project lap (tmux stint).

## System tools

Installed at system level (`system/configuration.nix`): tmux, neovim, zoxide, fzf, ripgrep, pi-coding-agent.

Installed via home-manager: git, direnv, zoxide (also integrated in zsh).

## GUI apps

Homebrew casks (declarative): Arc, Ghostty, Tailscale.
