# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a comprehensive Neovim configuration built on top of the Lazy.nvim plugin manager. The configuration is organized in a modular structure with clear separation of concerns:

### Core Structure

- **`init.lua`** - Main entry point that sets leader keys and requires all core modules
- **`lua/core/`** - Core Neovim functionality:
  - `lazy.lua` - Plugin manager setup and configuration
  - `options.lua` - Vim options and settings (tabs, search, display, etc.)
  - `autocmds.lua` - Autocommands
- **`lua/config/`** - Configuration modules:
  - `keymaps.lua` - Key mappings
  - `colorscheme.lua` - Theme configuration
  - `global_statusline.lua` - Status line setup
  - `vimrc.lua` - Additional vim settings

### Plugin Organization

Plugins are organized into logical categories under `lua/plugins/`:

- **`coding/`** - Code completion, snippets, and development tools
- **`editor/`** - Editor enhancements (file explorer, search, git integration)
- **`lsp/`** - Language Server Protocol configuration
- **`ui/`** - User interface enhancements
- **`util/`** - Utility plugins
- **`extras/`** - Optional feature sets:
  - `ai/` - AI integration (Avante, Copilot, etc.)
  - `dap/` - Debug Adapter Protocol
  - `lang/` - Language-specific configurations (Go, Python, Java, etc.)
  - `note/` - Note-taking tools

### Key Configuration Patterns

1. **Leader Keys**: Primary leader is `,`, local leader is `<Space>`
2. **Plugin Loading**: Uses lazy loading with the Lazy.nvim plugin manager
3. **LSP Setup**: Mason for LSP server management, configured in `lua/plugins/lsp/`
4. **Modular Extras**: Optional language and feature support in `extras/` directory

### Important Files

- **`lazy-lock.json`** - Plugin version lockfile (similar to package-lock.json)
- **`lua/helpers/util.lua`** - Utility functions including keymap helpers
- **`snippets/luasnip/`** - Custom code snippets for various languages

## Common Development Commands

### Plugin Management
- `:Lazy` - Open plugin manager
- `:Lazy sync` - Update plugins to locked versions
- `:Lazy update` - Update plugins and update lockfile

### LSP and Tools
- `:Mason` - Open Mason tool installer
- `:LspInfo` - Show LSP client information
- `:ConformInfo` - Show formatter configuration

### Key Mappings
- `<leader>cl` - Open Lazy plugin manager
- `<leader>cm` - Open Mason
- `<leader>qq` - Quit all
- `<leader>ww` - Save all
- `<leader><tab>` - Switch to alternate buffer

## Development Notes

- Configuration uses Lua exclusively (no Vimscript)
- **LSP Configuration**: Uses native `vim.lsp.config` API (Neovim 0.11+) instead of deprecated nvim-lspconfig
- Folding is configured with marker-based folding (`fdm=marker:fdl=1` or `fdm=marker:fdl=2`)
- Mouse is completely disabled for keyboard-centric workflow
- Uses relative line numbers with absolute current line
- Supports multiple colorschemes (Catppuccin, Dracula, Everforest, Bamboo)
- Includes extensive language support through extras modules

## File Structure Convention

When adding new plugins or configurations:
- Place core functionality in appropriate `lua/plugins/` subdirectory
- Use `lua/plugins/extras/` for optional or language-specific features
- Follow the existing pattern of one plugin per file with descriptive names
- Use the helper utility functions from `lua/helpers/util.lua` for consistent key mappings