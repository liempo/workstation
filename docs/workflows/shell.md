# Shell

Shell config lives in `home/shell.nix`.
Home-manager enables Zsh with oh-my-zsh (agnoster theme).
Integrations: fzf, zoxide, direnv. `EDITOR` and `VISUAL` default to `nvim`.

SSH key auto-load at login lives in `home/git.nix` next to `gitAccounts`.
It is not in this module.

## Tmux

Interactive zsh (not already inside tmux) runs `_tmux_auto_attach` on startup.

| Situation | Behavior |
|-----------|----------|
| No tmux server | Create session `main` |
| tmux already running | fzf menu: attach `main`, pick a session, new session, or shell only |
| `TMUX_AUTO_MAIN=1` | Always attach/create `main` (old behavior) |
| `TMUX_AUTO=0` | Skip auto tmux |

**Menu options** (when tmux is already running):

- **Attach to main** — join the existing `main` session
- **Attach to session…** — fzf pick from `tmux list-sessions`
- **New session** — name it, or leave blank for `main-2`, `main-3`, …
- **Shell only** — stay in zsh without tmux (Esc / cancel on fzf does the same)

The shell process is replaced when you attach or create a session.
When you exit or detach from tmux, the terminal window closes.

Nested tmux is avoided because the check skips when `$TMUX` is set.

The tmux prefix is **Ctrl+Space**, followed by a command key (for example, `c`
creates a window). Ghostty sends it as CSI-u (`csi:32;5u`), rather than a NUL
byte through its `text` action. After changing Ghostty config, run `drs` and
reload Ghostty configuration with **Cmd+Shift+,**.

Closing or detaching a terminal only drops the client. Sessions keep running until you kill the last pane, kill the tmux server, or reboot.

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

Declared in `system/configuration.nix` via Homebrew:

| Source | Apps |
|--------|------|
| Casks | Arc, Ghostty, Stats, Tailscale, Android Studio, Tinycast, Zoom |

Xcode is installed manually from the App Store (not managed by `drs`).
Use it for SourceKit in Neovim and native Apple builds.

Android SDK lives at `~/Library/Android/sdk` (Studio default). Home-manager sets `ANDROID_HOME` / `ANDROID_SDK_ROOT` and puts `platform-tools` on `PATH` for `adb`.
