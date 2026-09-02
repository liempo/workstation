# Rebuild

Apply configuration changes with the `drs` shell function (defined in `home/liempo.nix`).

## Commands

```bash
drs              # pure rebuild — default
drs --impure     # impure rebuild — writable config symlinks
```

| Mode | Flake output | Config files |
|------|--------------|--------------|
| Pure | `#workstation` | Copied from Nix store (read-only) |
| Impure | `#workstation-impure` | Symlinked into `~/.dots` |

Impure mode requires `IMPURITY_PATH=$HOME/.dots` and `--impure` (handled by `drs --impure`). See [impurity.md](impurity.md).

## Equivalent manual command

```bash
sudo darwin-rebuild switch --flake "$HOME/.dots#workstation"
```

## When to rebuild

- After editing `flake.nix`, `home/liempo.nix`, or `system/configuration.nix`
- After adding or removing home-manager packages
- To pick up new shell functions or git/SSH config

Config file edits under `home/.config/` in pure mode also require a rebuild. In impure mode, Neovim config can be edited live.

## Validate without applying

```bash
nix build .#darwinConfigurations.workstation.config.system.build.toplevel
```
