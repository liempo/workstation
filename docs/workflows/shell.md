# Shell

Shell config lives in `home/shell.nix`.
Home-manager enables Zsh with oh-my-zsh (afowler theme).
Afowler shows the short hostname, working directory, and repository status; the right prompt shows failed exit codes.
Integrations: fzf, zoxide, direnv. `EDITOR` and `VISUAL` default to `nvim`.
Zsh prepends `/opt/homebrew/bin` to `PATH` so Homebrew tools such as Podman are available.
Zsh exports `DOCKER_HOST` using the socket from `podman machine inspect podman-machine-default`.
The machine must exist for this lookup to succeed.
After changing this configuration, run `drs` and open a new shell.

SSH key auto-load at login lives in `home/git.nix` next to `gitAccounts`.
It is not in this module.

## Tmux

Zsh does not start or attach to tmux automatically. Run `tat` to attach to or create
a session for the current directory, with new sessions starting in that directory.
Session names use the physical directory path, with the home prefix shortened to `~`
and dots/colons replaced by underscores (for example, `~/.dots` becomes `~/_dots`).
There is no hash suffix. Symlink paths share a session; paths differing only in
replaced characters can collide. Old hash-named sessions are not renamed.
There is no menu or shared `main` session; existing sessions are left untouched.
Inside tmux it does nothing. `TMUX_AUTO` and `TMUX_AUTO_MAIN` are no longer used.
`tat` replaces the shell with tmux, so detaching or exiting tmux closes that shell.

Tmux uses built-in status formatting (no TPM/plugins); `PREFIX` appears while the prefix is active.

The tmux prefix is **Ctrl+Space**, followed by a command key (for example, `c`
creates a window). Ghostty sends it as CSI-u (`csi:32;5u`), rather than a NUL
byte through its `text` action. After changing Ghostty config, run `drs` and
reload Ghostty configuration with **Cmd+Shift+,**.

`system/configuration.nix` disables macOS input-source shortcuts (symbolic
hotkeys 60 and 61) so macOS does not intercept the prefix. These are per-user
preferences and apply to built-in and external keyboards; apply with `drs`.

Closing or detaching a terminal only drops the client. Sessions keep running until you kill the last pane, kill the tmux server, or reboot.

### SSH windows (no nested tmux)

| Keys after Ctrl+Space | Action |
|----------------------|--------|
| `%` | Side-by-side split; inherit this window's SSH host |
| `"` | Top/bottom split; inherit this window's SSH host |
| `c` | Standard new **local** window, even from an SSH window |

The former prefix + Shift+S popup binding is removed. To create an SSH window manually,
run `tmux-ssh-window new "$TMUX_PANE"` inside tmux.
Enter `devstation`, another SSH alias, or `user@host`; blank input or Ctrl+C cancels.
Put ports, keys, and jump hosts in `~/.ssh/config`, not the prompt.
Each SSH window records its destination in the window-local `@ssh-host` option;
its new splits open independent SSH shells on that host. Other windows are unaffected.
Local splits inherit the current pane's local directory. Remote splits start in the
remote login directory, not the current remote directory. Existing Ctrl+H/J/K/L
navigation, mouse support, H/L window switching, and theme remain unchanged.

This is opt-in: manually typing `ssh` in a local window does not mark it as remote.
Only the `%`/`"` bindings use inheritance; raw `tmux split-window` or other bindings
are not intercepted. There is no remote tmux and no helper to install on devstation.
Failed SSH panes remain visible (`remain-on-exit failed`); close with prefix `x`,
or retry with `:respawn-pane` from the tmux command prompt. Normal logout closes
the pane. SSH disconnection does not preserve remote processes as remote tmux would.

`home/scripts/tmux-ssh-window.sh` is packaged by Home Manager as `tmux-ssh-window`.
It uses tmux and OpenSSH only—no TPM, additional session manager, or SSH plugin.
After rebuilding, use a new tmux server or reload with
`tmux source-file ~/.config/tmux/tmux.conf` from the updated shell environment.
Validate the helper without real SSH connections or touching live sessions:

```sh
python3 tests/tmux-ssh-window.py  # requires Python 3, Bash, tmux
```

## Helpers

| Command | Alias | Purpose |
|---------|-------|---------|
| `drs` | none | Rebuild system config. Use `drs --impure` for writable symlinks. |
| `vact` | none | Activate or deactivate `./.venv` by directory. |
| `tat` | none | Attach to/create a tmux session for the current directory. |

### drs

`drs` means **darwin rebuild switch**.
See [rebuild.md](rebuild.md).

## System tools

Installed at system level (`system/configuration.nix`): tmux, neovim, zoxide, fzf, ripgrep, pi-coding-agent.

Installed via home-manager: git, gh, direnv, nodejs, bun, deno, fzf, zoxide.
Fzf and zoxide also have Zsh integrations.

## GUI apps

Declared in `system/configuration.nix` via Homebrew:

| Source | Apps |
|--------|------|
| Casks | Arc, Ghostty, MonitorControl, Stats, Tailscale, Android Studio, Tinycast, Zoom |

Amphetamine is declared in `homebrew.masApps`; run `drs` while signed into the
Mac App Store to install it.

Xcode is installed manually from the App Store (not managed by `drs`).
Use it for SourceKit in Neovim and native Apple builds.

Android SDK lives at `~/Library/Android/sdk` (Studio default). Home-manager sets `ANDROID_HOME` / `ANDROID_SDK_ROOT` and puts `platform-tools` on `PATH` for `adb`.
