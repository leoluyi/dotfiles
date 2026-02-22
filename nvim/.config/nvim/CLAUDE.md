# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a comprehensive Neovim configuration built on top of the Lazy.nvim plugin manager. The configuration is organized in a modular structure with clear separation of concerns.

### Core Structure

```
init.lua                    # Entry point: leader keys + require config modules
lua/
├── config/                 # All core user configuration
│   ├── lazy.lua            # Plugin manager setup
│   ├── options.lua         # Vim options (tabs, search, display, filetype detection)
│   ├── keymaps.lua         # Key mappings
│   ├── autocmds.lua        # Autocommands (including global statusline)
│   └── colorscheme.lua     # Theme configuration
├── util/                   # Utility functions (use require("util") for main module)
│   ├── init.lua            # Core utilities (map(), path ops, has(), fg())
│   ├── lsp.lua             # LSP utilities (Python path, capabilities, attachment)
│   ├── lsp_keymaps.lua     # LSP-specific key mappings
│   ├── icons.lua           # Icon definitions for UI elements
│   ├── telescope.lua       # Telescope helper functions
│   ├── telescope-multiopen.lua  # Multi-file opening for Telescope
│   ├── treesitter.lua      # Treesitter helpers (disable for large files)
│   ├── colorscheme.lua     # Colorscheme utilities
│   ├── buffers.lua         # Buffer utilities
│   └── root.lua            # Project root detection
└── plugins/                # Plugin specifications organized by category
    ├── colorscheme.lua     # 10+ color themes
    ├── treesitter.lua      # Syntax tree parsing
    ├── vim_plugins.lua     # Tpope collection (fugitive, surround, etc.)
    ├── coding/             # Completion, snippets, coding tools
    ├── editor/             # Editor enhancements (telescope, neo-tree, git, etc.)
    ├── lsp/                # Language Server Protocol configuration
    ├── ui/                 # UI enhancements (lualine, bufferline, etc.)
    ├── util/               # Utility plugins (yanky)
    └── extras/             # Optional feature sets:
        ├── ai/             # AI integration (Avante, Copilot, etc.)
        ├── coding/         # Refactoring, compiler, code snapshots
        ├── dap/            # Debug Adapter Protocol
        ├── lang/           # Language-specific configs (Go, Python, Java, etc.)
        └── note/           # Note-taking tools (Obsidian)
after/
└── ftplugin/               # Filetype-specific settings (Lua only)
snippets/luasnip/           # LuaSnip custom snippets
```

### Plugin Organization

Plugins are organized into logical categories under `lua/plugins/`:

- **`coding/`** - Code completion, snippets, and development tools
- **`editor/`** - Editor enhancements (file explorer, search, git integration)
- **`lsp/`** - Language Server Protocol configuration
- **`ui/`** - User interface enhancements
- **`util/`** - Utility plugins
- **`extras/`** - Optional feature sets:
  - `ai/` - AI integration (Avante, Copilot, etc.)
  - `coding/` - Extra coding tools (refactoring, compiler)
  - `dap/` - Debug Adapter Protocol
  - `lang/` - Language-specific configurations (Go, Python, Java, etc.)
  - `note/` - Note-taking tools

### Key Configuration Patterns

1. **Leader Keys**: Primary leader is `,`, local leader is `<Space>`
2. **Plugin Loading**: Uses lazy loading with the Lazy.nvim plugin manager
3. **LSP Setup**: Mason for LSP server management, configured in `lua/plugins/lsp/`
4. **Utilities**: Helper functions in `lua/util/` — `require("util")` for the main module
5. **Modular Extras**: Optional language and feature support in `extras/` directory

### Important Files

- **`lazy-lock.json`** - Plugin version lockfile (similar to package-lock.json)
- **`lua/util/init.lua`** - Main utility functions including keymap helpers
- **`lua/util/lsp.lua`** - LSP utilities (capabilities, Python path detection)
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

- Configuration uses **Lua exclusively** (no Vimscript)
- **LSP Configuration**: Uses native `vim.lsp.config` API (Neovim 0.11+)
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
- Use the helper utility functions from `lua/util/` for consistent key mappings:
  - `require("util").map(mode, lhs, rhs, opts)` - Safe keymap with Lazy handler awareness
  - `require("util.lsp")` - LSP utilities
  - `require("util.icons")` - Icon definitions
