# Changelog

All notable changes to this Neovim configuration are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [Unreleased]

## 2026-02-22

### Removed

Plugin cleanup — removed 12 disabled/superseded/dead plugin files (~600 lines):

**Disabled files (enabled = false or all commented out):**
- `editor/hop.lua` — fully commented out, superseded by flash.nvim
- `editor/dial.lua` — disabled, increment/decrement via `<C-a>/<C-x>`
- `editor/neovim-project.lua` — disabled, project.nvim already handles roots
- `extras/lsp/none-ls.lua` — disabled, formatting handled by conform.nvim
- `extras/note/image.lua` — all commented out
- `ui/notice.lua` — noice.nvim disabled, not compatible with current setup
- `extras/lang/dbt.lua` — all keymaps commented out, not imported in lazy.lua
- `extras/lang/makefile.lua` — empty config, removed lazy.lua import

**Superseded plugins (better alternative already loaded):**
- `lsp/symbols-outline.lua` → replaced by `editor/outline.lua` (hedyhli/outline.nvim, maintained fork)
- `lsp/lsp-colors.lua` → built into Neovim 0.9+; plugin is deprecated by its author
- `lsp/lsp_signature.lua` → replaced by Neovim 0.10+ built-in signature help
- `ui/indent-blankline.lua` → replaced by `ui/mini-indentscope.lua` (adds `ii`/`ai` textobjects + scope animation)

**Removed from `vim_plugins.lua`:**
- `tpope/vim-sensible` — all settings already covered by Neovim defaults
- `danro/rename.vim` — `tpope/vim-eunuch` already provides `:Rename`
- `Asheq/close-buffers.vim` — replaced by `<leader>ba/bd/bc` buffer keymaps
- `junegunn/gv.vim` — diffview.nvim is a superset
- `PieterjanMontens/vim-pipenv` + `jmcantrell/vim-virtualenv` — pyright handles venv detection
- `plasticboy/vim-markdown` — render-markdown.nvim (treesitter-based) is the replacement

**Removed from `extras/coding/ThePrimeagen.lua`:**
- `ThePrimeagen/vim-be-good` — training game, not for daily use; harpoon kept

---

## 2025 — Lua rewrite

### Changed
- Migrated entire configuration from Vimscript + vim-plug to Lua + Lazy.nvim
- Adopted native LSP via `vim.lsp.config` API (Neovim 0.11+)
- Replaced coc.nvim with nvim-cmp + LuaSnip for completion
- Replaced vim-airline with lualine.nvim
- Replaced NERDTree with neo-tree.nvim + oil.nvim

### Added
- Mason for LSP server / formatter / linter installation
- conform.nvim for formatting (stylua, prettier, ruff, black, google-java-format)
- Telescope as primary fuzzy finder (40+ keymaps)
- Treesitter for syntax, folding, text objects
- DAP (Debug Adapter Protocol) support via nvim-dap + nvim-dap-ui
- AI integration: Avante (Claude), CopilotChat, Codeium
- Language extras: Go, Python, Java, Markdown, Docker, Scala
- Obsidian vault integration for note-taking
- Harpoon for fast file bookmarking
- Flash.nvim for motion navigation
- Neogit + gitsigns for Git workflow
