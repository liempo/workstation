# Neovim

Config lives in `home/.config/nvim/`.
Plugin manager: [lazy.nvim](https://github.com/folke/lazy.nvim).

## Layout

| Path | Purpose |
|------|---------|
| `init.lua` | Options, keymaps, lazy bootstrap, `exrc` |
| `lua/config/lsp.lua` | LSP configs + Mason (no global enable) |
| `lua/plugins/` | lazy.nvim plugin specs |
| `.nvim.lua` (per project) | Enables LSPs and editor tools for that directory |
| `lua/config/project.lua` | Helpers for project `.nvim.lua` (conform, context comments) |

## Per-directory config

Use a trusted `.nvim.lua` at the project root for LSP and editor plugins.
Global nvim config only loads plugins; projects opt in via `.nvim.lua`.

## Per-directory LSP

`vim.o.exrc` is on. Neovim loads a trusted `.nvim.lua` from the startup cwd.

1. Add `.nvim.lua` at the project root (see examples below).
2. Open nvim from that directory.
3. Run `:trust` once when prompted (or `:trust` on the file).

No servers attach until a project file enables them.
Mason still installs the shared server list on startup.

### Examples

Dots repo (`~/.dots/.nvim.lua`):

```lua
local project = require("config.project")

project.setup_conform({
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "alejandra" },
  },
})
vim.lsp.enable({ "lua_ls", "nixd" })
```

TypeScript + Tailwind app:

```lua
vim.lsp.enable({ "ts_ls", "tailwindcss" })
```

Deno:

```lua
vim.lsp.enable({ "denols" })
```

Svelte:

```lua
vim.lsp.enable({ "svelte", "ts_ls", "tailwindcss" })
```

Swift (Xcode `sourcekit-lsp`):

```lua
vim.lsp.enable({ "sourcekit" })
```

Optional overrides in the same file:

```lua
vim.lsp.config("ts_ls", {
  settings = {
    -- project-specific settings
  },
})
vim.lsp.enable({ "ts_ls" })
```

### Formatters

Call `require("config.project").setup_conform(...)` from `.nvim.lua`.
Formatter binaries must be on `PATH` when nvim starts.

For this repo, `.envrc` adds `stylua` and `alejandra` via direnv (`direnv allow` once).
Open nvim from a shell after `cd` into the project so direnv has loaded.

Other projects use their own `.envrc` or tooling (e.g. `prettierd` for TypeScript).

## LSP servers

| Server | Source | Use |
|--------|--------|-----|
| `lua_ls` | Mason | Lua |
| `nixd` | Mason | Nix |
| `ts_ls` | Mason | TypeScript/JavaScript |
| `svelte` | Mason | Svelte |
| `tailwindcss` | Mason | Tailwind in HTML/CSS/JS/TS/Svelte |
| `denols` | system `deno` | Deno (root: `deno.json`) |
| `sourcekit` | Xcode | Swift (`sourcekit-lsp`) |

Shared defaults: cmp capabilities and `on_attach` keymaps.
Keymaps are capability-gated (code action, rename, format).

UI: `:Mason` to see or update installed servers.

## Common keymaps

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | References (Telescope) |
| `K` | Hover |
| `<leader>ca` | Code action |
| `<leader>f` | Format |
| `<leader>ff` | Find files (Telescope) |

Leader key: space.

## After rebuild

```vim
:Lazy sync
```

Mason installs missing servers on startup after plugins load.
Use `drs --impure` when lazy.nvim needs to write files under config.
See [impurity.md](impurity.md).

## Packages

Runtimes (`nodejs`, `bun`, `deno`) stay in `home/packages.nix`.
Language servers use Mason (or Xcode for SourceKit).
Do not put language servers in `home/packages.nix`.
