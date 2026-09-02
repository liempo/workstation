# Toolchains

JavaScript runtimes and language servers are installed globally via home-manager. Per-project overrides use direnv when needed.

## Global defaults (Tier 1)

Always on `PATH` after rebuild (`home/packages.nix`):

| Package | Role |
|---------|------|
| `nodejs` | Default Node.js (includes npm) |
| `bun` | Bun runtime |
| `deno` | Deno runtime |

Most projects need no extra setup. Update versions by changing `home/packages.nix` and running `drs`.

## direnv (Tier 2)

`programs.direnv` and `nix-direnv` are enabled but idle until a project has a `.envrc`.

| Situation | Action |
|-----------|--------|
| Normal JS/TS work | Nothing — use global Node/Bun/Deno |
| Project needs Node 20 | Add `.envrc`: `use nix -p nodejs_20` |
| Project needs extra tools | Add packages to the `use nix -p ...` line |

First time in a project:

```bash
direnv allow
```

direnv loads the environment on `cd`. nix-direnv caches builds for faster reloads.

## Language servers

Installed globally for Neovim:

- `lua-language-server`, `nixd`
- `typescript-language-server`, `svelte-language-server`, `tailwindcss-language-server`
- Deno and SourceKit use the `deno` package and Xcode respectively

See [neovim.md](neovim.md).

## Python virtualenvs

The `vact` shell function activates `./.venv` when present and deactivates when you leave the directory tree. This is separate from Nix/direnv.
