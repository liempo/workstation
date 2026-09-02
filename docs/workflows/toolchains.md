# Toolchains

Home-manager installs JavaScript runtimes and language servers globally.
Use direnv for per-project overrides when a project needs them.

## Global defaults (Tier 1)

These packages stay on `PATH` after a rebuild (`home/packages.nix`):

| Package | Role |
|---------|------|
| `nodejs` | Default Node.js (includes npm) |
| `bun` | Bun runtime |
| `deno` | Deno runtime |

Most projects need no extra setup.
To change versions, edit `home/packages.nix` and run `drs`.

## direnv (Tier 2)

`programs.direnv` and `nix-direnv` are enabled.
They stay idle until a project has a `.envrc`.

| Situation | Action |
|-----------|--------|
| Normal JS/TS work | Use global Node, Bun, or Deno |
| Project needs Node 20 | Add `.envrc`: `use nix -p nodejs_20` |
| Project needs extra tools | Add packages to the `use nix -p ...` line |

First time in a project:

```bash
direnv allow
```

direnv loads the environment on `cd`.
nix-direnv caches builds so reloads stay fast.

## Language servers

These servers are installed globally for Neovim:

- `lua-language-server`, `nixd`
- `typescript-language-server`, `svelte-language-server`, `tailwindcss-language-server`
- Deno and SourceKit use the `deno` package and Xcode

See [neovim.md](neovim.md).

## Python virtualenvs

The `vact` shell function activates `./.venv` when that directory exists.
It deactivates when you leave the directory tree.
This path is separate from Nix and direnv.
