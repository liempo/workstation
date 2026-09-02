# Impurity

[impurity.nix](https://github.com/outfoxxed/impurity.nix) lets selected config files symlink into this repo.
Without impurity, home-manager copies those files from the Nix store.

## Why

Pure home-manager deploys make `~/.config/nvim` read-only.
lazy.nvim and live editing need a writable tree.
Impure mode symlinks config back to `~/.dots/home/.config/nvim`.

## What uses impurity

| Config | Method |
|--------|--------|
| Neovim | `impurity.link` on the whole `nvim` directory (no `recursive`) |
| Ghostty, tmux | Pure (store copy) |

Do not set `recursive = true` on an impurity-linked directory.
Home-manager then manages each file and you get store copies again.

## Usage

```bash
drs --impure     # enable impure symlinks (#workstation-impure)
drs              # lock back to pure store copies (#workstation)
```

Set `IMPURITY_PATH` to the repo root (`$HOME/.dots`).
The `drs --impure` function does this for you.

## Workflow

1. If `~/.config/nvim` mixes files and store links, remove it once: `rm -rf ~/.config/nvim`.
2. Run `drs --impure` while you edit Neovim config or run `:Lazy sync`.
3. Confirm the link: `readlink ~/.config/nvim` must point at `~/.dots/home/.config/nvim`.
4. Edit files under `~/.dots/home/.config/nvim/` (or through the live symlink).
5. Commit the changes in this repo.
6. Run `drs` to return to reproducible pure mode.

## lazy.nvim lockfile

In pure mode, the lockfile lives at `~/.local/state/nvim/lazy-lock.json` (writable).
It is not stored in this repo.

In impure mode, lazy.nvim can write into the repo if it uses the default lockfile path.
