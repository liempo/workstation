# Agent guide

Nix-darwin / home-manager dotfiles for one macOS workstation (`aarch64-darwin`).
This file is the router for agents. Prefer the workflow docs for full procedures.

## Documents router

| Need | Read |
|------|------|
| Repo layout and flake outputs | [docs/README.md](docs/README.md) |
| Project dirs (`~/Development/…`) | [docs/workflows/development.md](docs/workflows/development.md) |
| Git accounts, `core.sshCommand`, remotes | [docs/workflows/git.md](docs/workflows/git.md) |
| Node / Bun / Deno / direnv | [docs/workflows/toolchains.md](docs/workflows/toolchains.md) |
| Rebuild (`drs`, `drs --impure`) | [docs/workflows/rebuild.md](docs/workflows/rebuild.md) |
| Shell helpers (`drs`, `vact`), auto tmux | [docs/workflows/shell.md](docs/workflows/shell.md) |
| Launchd / System Settings labels | [docs/workflows/launchd.md](docs/workflows/launchd.md) |
| Impurity / live nvim edits | [docs/workflows/impurity.md](docs/workflows/impurity.md) |
| Neovim / LSP | [docs/workflows/neovim.md](docs/workflows/neovim.md) |

Start at [docs/README.md](docs/README.md). Do not invent workflows that contradict those files.

## Hard rules

1. Edit Nix and config in this repo (`~/.dots`). Do not hand-edit generated files under `/nix/store`.
2. Prefer **pure** rebuilds: `drs` → `#workstation`. Use `drs --impure` only when the user asks.
3. Never commit Nix store symlinks as config source. If `home/.config/nvim/*` becomes a symlink into `/nix/store`, restore real files from git before editing or committing. Nvim uses one directory-level `impurity.link` (no `recursive`).
4. Ignore `*.backup` (home-manager backups) and `result` / `result-*` (`nix build` symlinks; already in `.gitignore`).
5. Git identity and SSH keys follow repo location. See [git.md](docs/workflows/git.md). Remotes use `git@github.com:...` (Option A / `core.sshCommand`).
6. This repo (`~/.dots`) is personal account. Project code lives under `~/Development/personal/` or `~/Development/astra/`.
7. Keep docs short and accurate. Update the matching file under `docs/workflows/` when behavior changes.
8. Validate Nix changes with `nix build .#darwinConfigurations.workstation.config.system.build.toplevel` when `drs` / sudo is unavailable.

## Key paths

| Path | Role |
|------|------|
| `flake.nix` | Inputs, `#workstation`, `#workstation-impure` |
| `system/configuration.nix` | System packages, Homebrew casks |
| `home/liempo.nix` | Home-manager entry: imports + XDG / impurity links |
| `home/git.nix` | Multi-account git, SSH defaults, key auto-load |
| `home/shell.nix` | Zsh, oh-my-zsh, fzf/zoxide/direnv, auto tmux, `drs`/`vact` |
| `home/packages.nix` | User packages (nodejs, bun, deno, LSPs) |
| `home/.config/nvim/` | Neovim (may use `impurity.link`) |

## Impurity

Default: pure mode. Config is copied from the Nix store.

Impure mode (`drs --impure`) is for live Neovim edits and writable lazy.nvim when the user requests it. Details: [impurity.md](docs/workflows/impurity.md).

After impure work: commit real source files in this repo, then return to pure with `drs` when the user wants a locked deploy.
