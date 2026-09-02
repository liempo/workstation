# Impurity

[impurity.nix](https://github.com/outfoxxed/impurity.nix) lets selected config files symlink into this repo instead of being copied from the Nix store.

## Why

Pure home-manager deploys make `~/.config/nvim` read-only. lazy.nvim and live editing need a writable tree. Impure mode symlinks config back to `~/.dots/home/.config/nvim`.

## What uses impurity

| Config | Method |
|--------|--------|
| Neovim | `impurity.link` on the whole `nvim` directory (no `recursive`) |
| Ghostty, tmux | Pure (store copy) |

Do not set `recursive = true` on an impurity-linked directory. Home-manager then manages each file and you get store copies again.

## Usage

```bash
drs --impure     # enable impure symlinks (#workstation-impure)
drs              # lock back to pure store copies (#workstation)
```

Set `IMPURITY_PATH` to the repo root (`$HOME/.dots`). The `drs --impure` function does this automatically.

## Workflow

1. If `~/.config/nvim` is a messy mix of files and store links, remove it once: `rm -rf ~/.config/nvim`
2. `drs --impure` while editing Neovim config or running `:Lazy sync`
3. Confirm: `readlink ~/.config/nvim` points at `~/.dots/home/.config/nvim`
4. Edit files in `~/.dots/home/.config/nvim/` (or via the live symlink)
5. Commit changes in this repo
6. `drs` to return to reproducible pure mode

## lazy.nvim lockfile

In pure mode, the lockfile lives at `~/.local/state/nvim/lazy-lock.json` (writable). It is not stored in this repo.

In impure mode, lazy.nvim can write into the repo if configured to use the default lockfile path.
