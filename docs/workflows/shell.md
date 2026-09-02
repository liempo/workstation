# Shell

Defined in `home/shell.nix`. Zsh via home-manager with oh-my-zsh (agnoster theme). Integrations: fzf, zoxide, direnv.

SSH key auto-load at login lives in `home/git.nix` (next to `gitAccounts`), not in this module.

## Helpers

| Command | Alias | Purpose |
|---------|-------|---------|
| `drs` | — | Rebuild system config. `drs --impure` for writable symlinks. |
| `lap` | `tat` | Attach or create a tmux session named after the current directory. |
| `vact` | — | Activate/deactivate `./.venv` Python virtualenv by directory. |

### lap / tat

1. Session name = basename of `$PWD` (dots stripped).
2. If session exists → attach.
3. If `.envrc` exists → start session with `direnv exec`.
4. Otherwise → plain new session.

### drs

F1-themed shorthand: **D**rag **R**eduction **S**ystem = deploy config changes. See [rebuild.md](rebuild.md).

### lap

F1-themed shorthand: start or rejoin a project **lap** (tmux stint).

## System tools

Installed at system level (`system/configuration.nix`): tmux, neovim, zoxide, fzf, ripgrep, pi-coding-agent.

Installed via home-manager: git, direnv, zoxide (also integrated in zsh).

## GUI apps

Homebrew casks (declarative): Arc, Ghostty, Tailscale.
