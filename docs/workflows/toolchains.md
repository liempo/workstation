# Toolchains

Home-manager installs JavaScript runtimes globally.
Language servers for Neovim come from Mason (see [neovim.md](neovim.md)).
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

This repo adds formatters and `nixd` via `.envrc` (not global packages):

```bash
use nix -p stylua alejandra nixd
```

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

Mason installs most Neovim LSPs (`lua_ls`, `ts_ls`, `svelte`, `tailwindcss`).
`nixd` is not in Mason — use direnv or system PATH (this repo's `.envrc`).
`denols` uses the global `deno` package; SourceKit uses Xcode.

See [neovim.md](neovim.md).

## Xcode and Android

| Tool | How |
|------|-----|
| Xcode | Manual App Store install (not in `drs`; needed for SourceKit / iOS builds) |
| Android Studio | Homebrew cask `android-studio` |
| Android SDK / `adb` | Studio installs under `~/Library/Android/sdk`; home-manager sets `ANDROID_HOME`, `ANDROID_SDK_ROOT`, and `platform-tools` on `PATH` (`home/shell.nix`) |

The SDK is not a Nix package. After Studio installs platform-tools, `adb` is on `PATH` in new shells.

## Python virtualenvs

The `vact` shell function activates `./.venv` when that directory exists.
It deactivates when you leave the directory tree.
This path is separate from Nix and direnv.
