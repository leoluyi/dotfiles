# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

Lua-only Neovim config built on Lazy.nvim. Entry point is `init.lua`, which sets leader keys then requires `config/{lazy,options,keymaps,autocmds,colorscheme}` in order.

### Load Order

```
init.lua
  → config/lazy.lua     # bootstraps Lazy.nvim, imports all plugin specs
  → config/options.lua  # vim.opt settings
  → config/keymaps.lua  # global keymaps (non-LSP)
  → config/autocmds.lua # autocommands
  → config/colorscheme.lua
```

### Plugin Spec Layout

`config/lazy.lua` imports plugin specs from these namespaces (all under `lua/plugins/`):

| Namespace | Always loaded |
|-----------|--------------|
| `plugins`, `plugins.coding`, `plugins.editor`, `plugins.lsp`, `plugins.ui`, `plugins.util` | Yes |
| `plugins.extras.*` | Opt-in — comment/uncomment in `config/lazy.lua` |

To enable or disable an optional feature set, edit the `spec` table in `lua/config/lazy.lua`. Currently active extras: `dap`, `note`, `coding`, `lang.{docker,go,markdown,python,java}`, `ai.avante`.

### Key Configuration Patterns

**Leader keys**: `,` (leader), `<Space>` (localleader). These must be set before Lazy loads plugins.

**Adding a plugin**: Create a new file in the appropriate `lua/plugins/<category>/` subdirectory returning a Lazy spec table. Lazy auto-discovers all files within imported namespaces.

**Keymaps**: Use `require("util").map(mode, lhs, rhs, opts)` for non-LSP keymaps — it skips registration if Lazy already owns the key. For LSP keymaps, use `vim.keymap.set` directly inside `util/lsp_keymaps.lua`.

**Checking plugin presence**: `require("util").has("plugin-name")` — wraps Lazy's plugin registry.

**Debug helper**: `put(...)` is a global (defined in `util/init.lua`) that pretty-prints values via `vim.inspect`.

## LSP Configuration

LSP servers are configured using Neovim 0.11+'s **native `vim.lsp.config` API** (not the traditional `lspconfig.setup()` pattern). Each server is assigned to `vim.lsp.config.<server_name>` inside `lua/plugins/lsp/lspconfig.lua`.

All servers share a common `on_attach` from `util/lsp.lua`:
- Disables LSP formatting for all servers except `gopls` (conform.nvim handles formatting instead)
- Disables `ruff`'s hover (defers to Pyright)
- Disables `semanticTokensProvider` globally
- Calls `util/lsp_keymaps.lua` for buffer-local key bindings

**Configured servers**: `bashls`, `eslint`, `golangci_lint_ls`, `gopls`, `lua_ls`, `ruff`, `pyright`, `jsonls`, `sqlls`, `taplo`, `ts_ls`, `vimls`, `yamlls`.

**Python path detection** (`util/lsp.lua`): resolves `$VIRTUAL_ENV`, then Pipenv, then Poetry, then local `pyvenv.cfg`, then falls back to system Python.

## Formatting

conform.nvim (`lua/plugins/lsp/conform.lua`) owns all formatting. Format on save is enabled only for `python`, `lua`, `java`, and `javascript`. Trigger manually with `<localleader>f`.

Notable formatter choices:
- Python: `ruff_fix` (isort via ruff) + `ruff_format`, fallback to `isort` + `black`
- Lua: `stylua` (2-space indent, spaces not tabs)
- JS/TS: `prettierd` preferred over `prettier`

## LSP Keymaps (buffer-local, set in `util/lsp_keymaps.lua`)

| Key | Action |
|-----|--------|
| `gd` / `gD` | Definition / Declaration |
| `gr` / `gi` | References / Implementation |
| `gK` | Signature help |
| `gF` | Lspsaga finder |
| `<localleader>ca` | Code action (Lspsaga) |
| `<localleader>rn` | Rename (Lspsaga) |
| `<localleader>f` | Format buffer (conform) |
| `[d` / `]d` | Prev/next diagnostic (Lspsaga) |
| `[e` / `]e` | Prev/next error |
| `[w` / `]w` | Prev/next warning |
| `<leader>ud` | Toggle diagnostics |
| `<leader>uh` | Toggle inlay hints |

Toggle state is tracked per-buffer via `vim.b[bufnr].inlay_hints_visible` / `vim.b[bufnr].diagnostics_visible`, seeded from the actual runtime state on attach.

## Filetype-specific Settings

`after/ftplugin/<ft>.lua` — pure Lua, loaded by Neovim after the plugin runtime. Use this for buffer-local `vim.opt_local` overrides and filetype keymaps. Do not add plugin configuration here.

## Useful Commands

- `:Lazy` — plugin manager UI
- `:Mason` — LSP/tool installer
- `:LspInfo` / `:LspServerCapabilities` — diagnose LSP state
- `:ConformInfo` — show active formatters for current buffer
- `<leader>cl` — open Lazy UI
- `<leader>li` — `:LspInfo`
- `<leader>cm` — open Mason
