# Shell

Shell config lives in `home/shell.nix`.
Home-manager enables Zsh with oh-my-zsh (agnoster theme).
Integrations: fzf, zoxide, direnv.

SSH key auto-load at login lives in `home/git.nix` next to `gitAccounts`.
It is not in this module.

## Tmux

Interactive Zsh sessions that are not already inside tmux run:

`exec tmux new-session -A -s main`

This attaches to the existing `main` session, or creates it when it is missing.
The shell process is replaced. When you exit or detach from tmux, the terminal closes.

Nested tmux is avoided because the check skips when `$TMUX` is set.

Closing or detaching a terminal only drops the client. The `main` session keeps running until you kill the last pane, kill the tmux server, or reboot. The next terminal reattaches to the same live session. There is no disk save across reboot.

## Helpers

| Command | Alias | Purpose |
|---------|-------|---------|
| `drs` | none | Rebuild system config. Use `drs --impure` for writable symlinks. |
| `vact` | none | Activate or deactivate `./.venv` by directory. |

### drs

F1-themed shorthand: Drag Reduction System equals deploy config changes.
See [rebuild.md](rebuild.md).

## System tools

Installed at system level (`system/configuration.nix`): tmux, neovim, zoxide, fzf, ripgrep, pi-coding-agent.

Installed via home-manager: git, direnv, zoxide (also integrated in zsh).

## GUI apps

Homebrew casks (declarative): Arc, Ghostty, Tailscale.
