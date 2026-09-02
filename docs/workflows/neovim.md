# Neovim

Config lives in `home/.config/nvim/`.
Plugin manager: [lazy.nvim](https://github.com/folke/lazy.nvim).

## Layout

| Path | Purpose |
|------|---------|
| `init.lua` | Options, keymaps, lazy bootstrap |
| `lua/config/lsp.lua` | LSP setup (Neovim 0.11+ API) |
| `lua/plugins/` | lazy.nvim plugin specs |

## LSP servers

Enabled in `lua/config/lsp.lua`:

| Server | Use |
|--------|-----|
| `lua_ls` | Lua |
| `nixd` | Nix |
| `denols` | Deno (root: `deno.json`) |
| `ts_ls` | TypeScript/JavaScript |
| `svelte` | Svelte |
| `tailwindcss` | Tailwind in HTML/CSS/JS/TS/Svelte |
| `sourcekit` | Swift (via Xcode `sourcekit-lsp`) |

Shared defaults: cmp capabilities and `on_attach` keymaps.
Keymaps are capability-gated (code action, rename, format).

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

Use `drs --impure` when lazy.nvim needs to write files under config.
See [impurity.md](impurity.md).

## Packages

Language servers are installed through `home/packages.nix`.
Do not install them with Mason.
