# Neovim Configuration

Modern Neovim IDE configuration — pure Lua, Lazy.nvim plugin manager, native LSP (Neovim 0.11+).

→ See [CHANGELOG.md](CHANGELOG.md) for history of changes.
→ See [docs/keymaps.md](docs/keymaps.md) for the full keymap reference.

---

## Requirements

| Dependency | Purpose |
|---|---|
| **Neovim >= 0.11** | Native `vim.lsp.config` API |
| **Git** | Lazy.nvim, plugin installation |
| **ripgrep** (`rg`) | Live grep in Telescope |
| **fd** | File finding in Telescope |
| **Node.js** | TypeScript, ESLint, YAML LSP servers |
| **Python 3** + `pynvim` | Python LSP, DAP |
| **A Nerd Font** | Icons (recommended: CaskaydiaCove Nerd Font) |
| `lazygit` _(optional)_ | Toggleterm integration |
| `lazydocker` _(optional)_ | Toggleterm integration |

Install system tools on macOS:

```bash
brew install neovim ripgrep fd node lazygit lazydocker
pip install pynvim
```

---

## Installation

This config is a [GNU Stow](https://www.gnu.org/software/stow/) package. From the dotfiles repo root:

```bash
stow -t "$HOME" nvim
# or via the bootstrap script:
./bootstrap_macos.sh
```

This symlinks `nvim/.config/nvim/` → `~/.config/nvim/`.

On first launch, Lazy.nvim auto-installs itself and all plugins. Mason then handles LSP servers, formatters, and linters (`:Mason` to open the UI).

---

## Directory Structure

```
nvim/
├── README.md               ← you are here
├── CHANGELOG.md
├── docs/
│   └── keymaps.md          ← full keymap reference
└── .config/nvim/           ← stowed into ~/.config/nvim/
    ├── init.lua            ← entry point: leader keys + bootstrap config
    ├── CLAUDE.md           ← AI assistant context
    ├── lua/
    │   ├── config/         ← core user configuration
    │   │   ├── lazy.lua    ← plugin manager setup & spec imports
    │   │   ├── options.lua ← vim options (tabs, search, display, encoding)
    │   │   ├── keymaps.lua ← global key mappings
    │   │   ├── autocmds.lua
    │   │   └── colorscheme.lua
    │   ├── util/           ← shared Lua utilities
    │   │   ├── init.lua    ← map(), path ops, LSP helpers
    │   │   ├── lsp.lua     ← capabilities, Python venv detection
    │   │   ├── lsp_keymaps.lua
    │   │   ├── icons.lua
    │   │   ├── telescope.lua / telescope-multiopen.lua
    │   │   ├── treesitter.lua
    │   │   ├── buffers.lua
    │   │   ├── root.lua    ← project root detection
    │   │   ├── colorscheme.lua
    │   │   ├── globals.lua
    │   │   └── keys.lua
    │   └── plugins/        ← plugin specs (one file per plugin/group)
    │       ├── colorscheme.lua   ← Everforest, Catppuccin, Bamboo, Tokyo Night, …
    │       ├── treesitter.lua
    │       ├── vim_plugins.lua   ← tpope collection + misc Vim plugins
    │       ├── coding/     ← completion, snippets, coding tools
    │       ├── editor/     ← file explorer, search, git, motion
    │       ├── lsp/        ← LSP, formatting, linting
    │       ├── ui/         ← statusline, bufferline, indent, folds, dashboard
    │       ├── util/       ← yanky (yank history)
    │       └── extras/     ← optional / language-specific
    │           ├── ai/     ← Avante (Claude), Copilot, CopilotChat, Codeium
    │           ├── coding/ ← harpoon, code snapshots, compiler, refactoring
    │           ├── dap/    ← Debug Adapter Protocol (nvim-dap + UI)
    │           ├── lang/   ← Go, Python, Java, Markdown, Docker, Scala
    │           └── note/   ← Obsidian vault integration
    ├── after/ftplugin/     ← filetype-specific overrides (Lua)
    └── snippets/luasnip/   ← custom LuaSnip snippets
```

---

## Leader Keys

| Key | Role |
|---|---|
| `,` | `<leader>` — primary leader |
| `<Space>` | `<localleader>` — local leader |

---

## Plugin Overview

### Core

| Category | Key Plugins |
|---|---|
| **Plugin manager** | [lazy.nvim](https://github.com/folke/lazy.nvim) |
| **Colorschemes** | Everforest, Catppuccin, Bamboo, Tokyo Night, Dracula, Gruvbox, Rose Pine |
| **Syntax** | nvim-treesitter + textobjects, refactor, playground |
| **Completion** | nvim-cmp (LSP + snippets + path + buffer + dict) |
| **Snippets** | LuaSnip + friendly-snippets |
| **LSP** | nvim-lspconfig (native 0.11+ API), Mason, lspsaga |
| **Formatting** | conform.nvim (stylua, prettier, ruff, black, google-java-format, ktlint) |
| **Linting** | nvim-lint |

### Editor

| Plugin | Purpose |
|---|---|
| **Telescope** | Fuzzy finder — files, grep, git, buffers, symbols, diagnostics |
| **neo-tree** | File tree sidebar |
| **oil.nvim** | Edit filesystem as a buffer, `-` to open parent |
| **flash.nvim** | Fast motion with label hints |
| **eyeliner.nvim** | Highlight unique `f`/`F`/`t`/`T` jump targets per word |
| **nvim-surround** | Add / change / delete surrounding characters |
| **mini.ai** | Extended text objects (functions, classes, arguments) |
| **mini.trailspace** | Trailing whitespace highlight + trim |
| **mini.indentscope** | Active indent scope with `ii`/`ai` text objects |
| **nvim-autopairs** | Auto-close brackets and quotes |
| **Comment.nvim** | `gcc`/`gcb` to comment lines and blocks |
| **spectre** | Find and replace across files |
| **trouble.nvim** | Diagnostics, quickfix, LSP references viewer |
| **todo-comments** | Highlight `TODO`, `FIXME`, `NOTE` comments |
| **outline.nvim** | LSP symbol tree sidebar |
| **diffview.nvim** | Git diff viewer with file panel |
| **Neogit** | Magit-style Git interface |
| **gitsigns** | Inline Git hunk signs and staging |
| **toggleterm** | Floating terminal (lazygit, lazydocker, node, htop, ncdu) |
| **yanky.nvim** | Yank ring history with Telescope picker |
| **which-key** | Keymap hints and leader group documentation |

### Language Support

| Language | Tools |
|---|---|
| **Go** | gopls, golangci-lint-ls, go.nvim (goimports, gofumpt, test runner, DAP) |
| **Python** | pyright, ruff, flake8 lint, DAP, venv detection |
| **TypeScript / JS** | ts_ls, eslint, prettier |
| **Java** | nvim-jdtls (jdtls), organize imports, extract method/variable |
| **Scala** | nvim-metals |
| **Lua** | lua_ls (with neodev), stylua |
| **Bash** | bashls, shfmt |
| **SQL** | sqlls, vim-dadbod-ui |
| **YAML** | yamlls |
| **JSON** | jsonls |
| **TOML** | taplo |
| **Markdown** | markdown-preview.nvim, render-markdown.nvim |
| **Docker** | hadolint via none-ls |

### AI Integration

All AI plugins live in `extras/ai/`. Enable by uncommenting the relevant line in `lua/config/lazy.lua`.

| Plugin | Status | Notes |
|---|---|---|
| **avante.nvim** | Enabled (disabled by default) | Claude API sidebar, inline diffs |
| **CopilotChat.nvim** | Optional | 15+ prompts: explain, review, tests, refactor |
| **copilot.lua** | Optional | GitHub Copilot suggestions |
| **Codeium.vim** | Optional | Free AI completion, `<C-l>` accept |
| **ChatGPT.nvim** | Optional | ChatGPT API |

To enable an AI plugin, uncomment its line in `lua/config/lazy.lua`:

```lua
-- { import = "plugins.extras.ai.copilotchat" },
-- { import = "plugins.extras.ai.codeium" },
```

---

## Common Commands

### Plugin Management

| Command | Action |
|---|---|
| `:Lazy` / `<leader>cl` | Open Lazy plugin manager |
| `:Lazy sync` | Install/update to locked versions |
| `:Lazy update` | Update plugins and lockfile |

### LSP / Tools

| Command | Action |
|---|---|
| `:Mason` / `<leader>cm` | Open Mason tool installer |
| `:LspInfo` | Show active LSP clients |
| `:ConformInfo` | Show formatter configuration |

### Useful Editor Commands

| Command | Action |
|---|---|
| `:ReindentAll` / `<localleader>R` | Re-indent entire buffer |
| `:W` | Write file with sudo (suda.vim) |
| `:TableModeToggle` / `<leader>um` | Toggle Markdown table mode |
| `:UndotreeToggle` / `<leader>uu` | Open undo history tree |

---

## Key Bindings Quick Reference

See **[docs/keymaps.md](docs/keymaps.md)** for the complete reference.

### Navigation (most used)

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>sg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader><tab>` | Alternate buffer |
| `-` | Open parent dir (oil.nvim) |
| `<leader>kk` | Focus file tree (neo-tree) |
| `m` / `'` | Set / jump to mark (harpoon) |

### LSP

| Key | Action |
|---|---|
| `K` | Hover documentation (lspsaga) |
| `gd` | Go to definition |
| `gr` | References |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code action |
| `<localleader>f` | Format buffer |
| `[d` / `]d` | Prev / next diagnostic |

### Git

| Key | Action |
|---|---|
| `<leader>gg` | Open Neogit |
| `<leader>gh` | Stage hunk |
| `<leader>gH` | Reset hunk |
| `<leader>gd` | Diff view open |

---

## References

- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [mason.nvim](https://github.com/williamboman/mason.nvim)
- [LazyVim config patterns](https://github.com/LazyVim/LazyVim) (inspiration, not a dependency)
- [ThePrimeagen dotfiles](https://github.com/ThePrimeagen/.dotfiles)
- [rafi/vim-config](https://github.com/rafi/vim-config)
