# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

Lua-only Neovim config built on Lazy.nvim. Entry point is `init.lua`, which sets leader keys then requires `config/{lazy,options,keymaps,autocmds,colorscheme}` in order.

### Load Order

```
init.lua
  → config/lazy.lua       # bootstraps Lazy.nvim, imports all plugin specs
  → config/options.lua    # vim.opt settings
  → config/keymaps.lua    # global keymaps (non-LSP)
  → config/autocmds.lua   # autocommands
  → config/colorscheme.lua
```

`init.lua` also sets escape aliases: `<localleader><Space>` → `<Space>` and `<leader>,` → `,`.

### Plugin Spec Layout

`config/lazy.lua` imports plugin specs from these namespaces (all under `lua/plugins/`):

| Namespace | Always loaded |
|-----------|--------------|
| `plugins`, `plugins.coding`, `plugins.editor`, `plugins.lsp`, `plugins.ui`, `plugins.util` | Yes |
| `plugins.extras.*` | Opt-in — comment/uncomment in `config/lazy.lua` |

To enable or disable an optional feature set, edit the `spec` table in `lua/config/lazy.lua`. Currently active extras:
- `dap`, `note`, `coding`
- `lang.{docker,go,markdown,python,java}`
- `ai.{avante,claude-code,supermaven}`

Commented-out extras (available but disabled): `ai.copilot`.

### Key Configuration Patterns

**Leader keys**: `,` (leader), `<Space>` (localleader). These must be set before Lazy loads plugins.

**Adding a plugin**: Create a new file in the appropriate `lua/plugins/<category>/` subdirectory returning a Lazy spec table. Lazy auto-discovers all files within imported namespaces.

**Keymaps**: Use `require("util").map(mode, lhs, rhs, opts)` for non-LSP keymaps — it skips registration if Lazy already owns the key. For LSP keymaps, use the local `map` wrapper inside `util/lsp_keymaps.lua` (which sets `buffer = bufnr` automatically).

**Checking plugin presence**: `require("util").has("plugin-name")` — wraps Lazy's plugin registry.

**Debug helper**: `put(...)` is a global (defined in `util/init.lua`) that pretty-prints values via `vim.inspect`.

## LSP Configuration

LSP servers are configured using Neovim 0.11+'s **native `vim.lsp.config` API** (not the traditional `lspconfig.setup()` pattern). Each server is assigned to `vim.lsp.config.<server_name>` inside `lua/plugins/lsp/lspconfig.lua`.

**Auto-start mechanism**: `nvim-lspconfig` is loaded eagerly (`lazy = false`). It detects all servers configured via `vim.lsp.config` and calls `vim.lsp.enable()` for each automatically. There are no explicit `vim.lsp.enable()` calls in this config — lspconfig handles that.

**Dependencies**: nvim-lspconfig depends on `neoconf.nvim` (project-local LSP config via `.neoconf.json`), `lsp-colors.nvim`, and `mason.nvim`. These are declared in the `dependencies` field of the lspconfig spec.

All servers share a common `on_attach` from `util/lsp.lua`:
- Disables LSP formatting for all servers except `gopls` (conform.nvim handles formatting instead)
- Disables `ruff`'s hover (defers to Pyright)
- Disables `semanticTokensProvider` globally
- Sets up document highlight on `CursorHold` / `CursorMoved` (if server supports it)
- Calls `util/lsp_keymaps.lua` for buffer-local key bindings
- Calls `lsp_signature.nvim`'s `on_attach` for signature help popups

**Configured servers**: `bashls`, `eslint`, `golangci_lint_ls`, `gopls`, `lua_ls`, `ruff`, `pyright`, `jsonls`, `sqlls`, `taplo`, `ts_ls`, `vimls`, `yamlls`.

**Python path detection** (`util/lsp.lua`): resolves `$VIRTUAL_ENV`, then Pipenv, then Poetry, then local `pyvenv.cfg`, then falls back to `python3` then `python` on system PATH.

**Lua API completions**: `lazydev.nvim` (loaded for `ft = "lua"`) injects the Neovim runtime library into `lua_ls`, providing accurate `vim.*` completions. It replaced `neodev.nvim` and hooks via `LspAttach` — compatible with the native `vim.lsp.config` API.

## Formatting

conform.nvim (`lua/plugins/lsp/conform.lua`) owns all formatting. **Format on save** is enabled only for `python`, `lua`, `java`, and `javascript`. Other filetypes (typescript, yaml, toml, markdown, etc.) have formatters configured but are NOT triggered on save — use `<localleader>f` manually.

Trigger manually with `<localleader>f` (global keymap defined in conform's `keys` spec — not a buffer-local LSP keymap). Works in normal and visual mode.

Formatter choices by filetype:
- **Python**: `ruff_fix` (isort via ruff) + `ruff_format`, fallback to `isort` + `black`
- **Lua**: `stylua` (2-space indent, spaces not tabs)
- **JS/TS/JSX/TSX/JSON/CSS/SCSS/GraphQL**: `prettierd` preferred, falls back to `prettier`
- **sh**: `shfmt` (2-space indent)
- **bash**: `beautysh`
- **YAML**: `yamlfix`
- **TOML**: `taplo`
- **Markdown**: `markdownlint-cli2`, then `prettierd`/`prettier`
- **Java**: `google-java-format`

## Linting

nvim-lint (`lua/plugins/lsp/nvim-lint.lua`) handles linting for filetypes not covered by LSP servers:
- `sh` / `bash`: `shellcheck`

All other linting is handled by LSP servers directly (ruff for Python, golangci-lint-langserver for Go, eslint for JS/TS).

## Mason

`lua/plugins/lsp/mason.lua` manages tool installation. `ensure_installed` is split into three sections:
- **LSP servers** — language server binaries
- **Linters** — standalone linters (including `golangci-lint`, which `golangci-lint-langserver` shells out to)
- **Formatters** — standalone formatters used by conform.nvim

When adding a new tool, place it in the appropriate section in alphabetical order.

## LSP Keymaps (buffer-local, set in `util/lsp_keymaps.lua`)

| Key | Action |
|-----|--------|
| `cl` | LspInfo (buffer-local; also available globally as `<leader>li`) |
| `gd` / `gD` | Definition / Declaration |
| `gr` / `gi` | References / Implementation |
| `gK` | Signature help |
| `gF` | Lspsaga finder |
| `<localleader>ca` | Code action (Lspsaga) — normal and visual |
| `<localleader>rn` | Rename (Lspsaga) |
| `[d` / `]d` | Prev/next diagnostic (Lspsaga) |
| `[e` / `]e` | Prev/next error |
| `[w` / `]w` | Prev/next warning |
| `<leader>dd` | Open diagnostic float (current line) |
| `<leader>ud` | Toggle diagnostics |
| `<leader>uh` | Toggle inlay hints |
| `<leader>wa` / `<leader>wr` / `<leader>wl` | Workspace: add / remove / list folders |
| `<leader>lci` / `<leader>lco` | Incoming / outgoing calls (conditional on `documentHighlightProvider`) |

Toggle state is tracked per-buffer via `vim.b[bufnr].inlay_hints_visible` / `vim.b[bufnr].diagnostics_visible`, seeded from the actual runtime state on attach.

## Filetype-specific Settings

`after/ftplugin/<ft>.lua` — pure Lua, loaded by Neovim after the plugin runtime. Use this for buffer-local `vim.opt_local` overrides and filetype keymaps. Do not add plugin configuration here.

## Useful Commands

- `:Lazy` — plugin manager UI
- `:Mason` — LSP/tool installer
- `:LspInfo` / `:LspServerCapabilities` — diagnose LSP state
- `:ConformInfo` — show active formatters for current buffer
- `<leader>cl` — open Lazy UI
- `<leader>li` — `:LspInfo` (global); `cl` does the same buffer-locally after LSP attach
- `<leader>cm` — open Mason
