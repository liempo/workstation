# Rebuild

Apply configuration changes with the `drs` shell function.
`drs` is defined in `home/shell.nix`.

## Commands

```bash
drs              # pure rebuild — default
drs --impure     # impure rebuild — writable config symlinks
```

| Mode | Flake output | Config files |
|------|--------------|--------------|
| Pure | `#workstation` | Copied from Nix store (read-only) |
| Impure | `#workstation-impure` | Symlinked into `~/.dots` |

Impure mode needs `IMPURITY_PATH=$HOME/.dots` and `--impure`.
`drs --impure` sets both. See [impurity.md](impurity.md).

## Equivalent manual command

```bash
sudo darwin-rebuild switch --flake "$HOME/.dots#workstation"
```

## When to rebuild

Rebuild after you:

- Edit `flake.nix`, `home/liempo.nix`, or `system/configuration.nix`
- Add or remove home-manager packages
- Change shell functions or git/SSH config

In pure mode, edits under `home/.config/` also need a rebuild.
In impure mode, you can edit Neovim config live.

## Validate without applying

```bash
nix build .#darwinConfigurations.workstation.config.system.build.toplevel
```

This command creates a `result` symlink in the repo root.
The symlink is gitignored. Remove it with `rm result` when you finish.
