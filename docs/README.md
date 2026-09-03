# Documentation

Nix-darwin dotfiles for one macOS workstation (`aarch64-darwin`).

Agents start at [AGENTS.md](../AGENTS.md). That file is the router and lists the hard rules.

## Repo layout

| Path | Purpose |
|------|---------|
| `flake.nix` | Flake inputs and two darwin configurations |
| `system/configuration.nix` | System packages, Homebrew casks, fonts, Stage Manager / native tiling, ⌘` Stage Manager toggle |
| `home/liempo.nix` | Home-manager entry: imports and XDG / impurity links |
| `home/git.nix` | Multi-account git, SSH defaults, key auto-load |
| `home/shell.nix` | Zsh, helpers (`drs`, `vact`), auto tmux, fzf/zoxide/direnv |
| `home/packages.nix` | User packages (nodejs, bun, deno) |
| `home/.config/` | Neovim, tmux, Ghostty config files |
| `home/.ideavimrc` | IntelliJ/IdeaVim keybindings |

## Flake outputs

| Output | Use |
|--------|-----|
| `#workstation` | Default rebuild. Config files come from the Nix store (read-only). |
| `#workstation-impure` | Writable symlinks into this repo via [impurity.nix](https://github.com/outfoxxed/impurity.nix). |

Rebuild with the `drs` shell function. See [workflows/rebuild.md](workflows/rebuild.md).

## Workflows

| Doc | Topic |
|-----|-------|
| [development.md](workflows/development.md) | Project directory layout |
| [git.md](workflows/git.md) | Multi-account SSH and commit identity |
| [toolchains.md](workflows/toolchains.md) | Node, Bun, Deno, direnv |
| [rebuild.md](workflows/rebuild.md) | `drs` and how to apply changes |
| [shell.md](workflows/shell.md) | Shell helpers (`drs`, `vact`), auto tmux |
| [launchd.md](workflows/launchd.md) | Launchd labels in System Settings |
| [impurity.md](workflows/impurity.md) | Live editing of config in this repo |
| [neovim.md](workflows/neovim.md) | Editor setup and LSP |
