# Keymap Reference

Leaders: `,` = `<leader>` · `<Space>` = `<localleader>`

---

## Table of Contents

- [Core / Motion](#core--motion)
- [Editing](#editing)
- [Clipboard & Registers](#clipboard--registers)
- [Windows & Splits](#windows--splits)
- [Buffers](#buffers)
- [Folding](#folding)
- [Search & Replace](#search--replace)
- [File Operations](#file-operations)
- [LSP](#lsp)
- [Completion](#completion)
- [Snippets](#snippets)
- [Git](#git)
- [File Explorer](#file-explorer)
- [Telescope (Fuzzy Finder)](#telescope-fuzzy-finder)
- [Terminal](#terminal)
- [Diagnostics & Quickfix](#diagnostics--quickfix)
- [Code Actions & Refactoring](#code-actions--refactoring)
- [DAP (Debugger)](#dap-debugger)
- [UI Toggles](#ui-toggles)
- [Notes (Obsidian)](#notes-obsidian)
- [AI (CopilotChat)](#ai-copilotchat)
- [Language: Go](#language-go)
- [Language: Java](#language-java)

---

## Core / Motion

| Key | Mode | Action |
|---|---|---|
| `j` / `k` | n/x | Smart up/down (respects `gj`/`gk` for wrapped lines; adds to jumplist for counts) |
| `<C-d>` / `<C-u>` | n/x | Page down/up (adds to jumplist) |
| `n` / `N` | n | Search next/prev (centered + open folds) |
| `J` | n | Join lines (cursor stays put) |
| `0` | n | Go to column 0 or first non-blank (smart) |
| `gV` | n | Select last changed/pasted text |
| `gf` | n/x | Open file under cursor (creates if missing) |
| `/` / `?` | n/v | Search (marks position `s` first so `'s` jumps back) |
| `<localleader><localleader>` | n/x/o | Flash jump (label-based fast motion) |
| `f` / `F` / `t` / `T` | n | Jump to char (quick-scope highlights unique targets) |

---

## Editing

| Key | Mode | Action |
|---|---|---|
| `<` / `>` | v | Indent / dedent (stays in visual) |
| `<M-j>` / `<M-k>` | n/i/v | Move line(s) down / up |
| `<localleader>o` | n | Insert line below without auto-comment |
| `<localleader>O` | n | Insert line above without auto-comment |
| `Y` | n | Yank to end of line |
| `x` / `X` | n/x | Delete to black-hole register (doesn't clobber yank) |
| `<F9>` | n/i/x | Toggle fold |
| `<F10>` | n | Toggle line wrap |
| `<localleader>R` | n | Re-indent entire buffer (`:ReindentAll`) |
| `<localleader>M` | n | Remove Windows `^M` line endings |
| `<localleader>n` | n | Insert current filename at cursor |

### Insert mode readline bindings

| Key | Action |
|---|---|
| `<C-a>` | Beginning of line |
| `<C-e>` | End of line |
| `<C-b>` / `<C-f>` | Move left / right |
| `<C-d>` | Delete char (or dedent if at end of line) |

### Command-line readline bindings

| Key | Action |
|---|---|
| `<C-a>` / `<C-e>` | Home / End |
| `<C-p>` / `<C-n>` | Previous / next history |
| `<C-b>` / `<C-f>` | Move left / right |

### Surround (word under cursor / visual selection)

| Key | Mode | Action |
|---|---|---|
| `<localleader>'` | n/v | Surround with `'…'` |
| `<localleader>"` | n/v | Surround with `"…"` |
| `<localleader>\`` | n/v | Surround with `` `…` `` |
| `<localleader>(` / `)` | n/v | Surround with `(…)` |
| `<localleader>[` / `]` | n/v | Surround with `[ … ]` / `[…]` |
| `<localleader>{` / `}` | n/v | Surround with `{ … }` / `{…}` |
| `<localleader><` / `>` | n/v | Surround with `< … >` / `<…>` |

**nvim-surround** (plugin) operations:

| Key | Action |
|---|---|
| `ysiw"` | Surround word with `"` |
| `ds"` | Delete surrounding `"` |
| `cs"'` | Change surrounding `"` to `'` |

---

## Clipboard & Registers

| Key | Mode | Action |
|---|---|---|
| `y` | v | Yank (cursor stays at end of selection) |
| `p` / `P` | n/x | Paste after/before (cursor jumps to end of pasted text) |
| `<localleader>y` | n/x | Yank to system clipboard (`+`) |
| `<localleader>yy` | n/x | Yank line to system clipboard |
| `<localleader>Y` | n/x | Yank to end of line to clipboard |
| `<localleader>p` / `P` | n/x | Paste from yank register (`"0`) |
| `<localleader>d` | n/x | Delete to yank register |
| `<localleader>dd` | n/x | Delete line to yank register |
| `<localleader>D` | n/x | Delete to end of line to yank register |
| `<localleader>x` | n/x | Delete char to yank register |
| `<localleader>C` | n/x | Cut to yank register |
| `<localleader>cc` | n/x | Change line to yank register |
| `<leader>sy` | n | Open yank history (yanky + Telescope) |

---

## Windows & Splits

| Key | Mode | Action |
|---|---|---|
| `<C-h>` / `<C-l>` | n | Move to left / right window |
| `<C-S-←/→/↑/↓>` | n | Resize split (−2/+2 cols or rows) |
| `<leader>w←` / `→` / `↑` / `↓` | n | Resize split |
| `<leader>wh` | n | Rotate windows horizontal |
| `<leader>wk` | n | Rotate windows vertical |
| `<leader>ws` | n | Swap windows |
| `<leader>w=` | n | Equalize window sizes |
| `<leader>zz` | n | Zoom window in (maximize) |
| `<leader>zo` | n | Zoom window out (equalize) |
| `<C-w><Space>` | n | Window hydra (which-key) |

---

## Buffers

| Key | Mode | Action |
|---|---|---|
| `<leader><tab>` | n/x | Alternate buffer (`<C-^>`) |
| `<c-6>` | n/x | Alternate buffer |
| `<leader>bn` | n/x | New empty buffer |
| `<leader>ba` | n | Close all buffers |
| `<leader>bd` | n | Close buffer and window |
| `<leader>bc` | n | Close buffer, keep window |
| `<leader>bs` | n | Sort bufferline by directory |
| `<leader>A` | n/x | New file sibling to current buffer |
| `<leader>AA` | n/x | New file in CWD |

---

## Folding

| Key | Mode | Action |
|---|---|---|
| `z0` – `z4` | n/x | Set fold level 0–4 |
| `z9` | n/x | Expand all folds (level 999) |
| `<F9>` | n/i/x | Toggle fold |
| `za` | n | Toggle fold (native) |
| `zR` / `zM` | n | Open all / close all folds |

---

## Search & Replace

| Key | Mode | Action |
|---|---|---|
| `g/` | v | Search within visual selection |
| `<localleader>s` | v | Replace within visual selection |
| `<localleader>S` | v | Global replace of selected text |
| `<leader>sr` | n/v | Open Spectre (project-wide find & replace) |
| `<leader>sw` | n/v | Spectre search current word |

---

## File Operations

| Key | Mode | Action |
|---|---|---|
| `<leader>yf` | n | Copy filename to `"` register |
| `<leader>yc` | n | Copy current directory to clipboard |
| `<leader>yp` | n | Copy absolute file path to clipboard |
| `<leader>y.` | n | Copy relative file path to clipboard |
| `<leader>up` | n | Toggle paste mode |
| `<leader>n` | n/x | Toggle line numbers off (for copy-paste) |
| `<leader>N` | n/x | Restore line numbers and statuscolumn |

---

## LSP

These keymaps are set on LSP attach (defined in `lua/util/lsp_keymaps.lua` and lspsaga).

| Key | Mode | Action |
|---|---|---|
| `K` | n | Hover documentation (lspsaga) |
| `gd` | n | Go to definition |
| `gD` | n | Go to declaration |
| `gr` | n | References |
| `gi` | n | Go to implementation |
| `gy` | n | Go to type definition |
| `gS` | n | Go to subject (Java super implementation) |
| `<leader>cr` | n | Rename symbol (lspsaga) |
| `<leader>ca` | n/v | Code action (lspsaga) |
| `<leader>cd` | n | Show line diagnostics (lspsaga) |
| `[d` / `]d` | n | Previous / next diagnostic |
| `<localleader>f` | n | Format buffer (conform.nvim) |
| `<leader>uo` | n | Toggle symbol outline (outline.nvim) |
| `<leader>ls` | n | Toggle symbols outline (alternate) |
| `<leader>cm` | n | Open Mason |
| `<leader>ci` | n | LSP info |

---

## Completion

| Key | Mode | Action |
|---|---|---|
| `<C-Space>` | i | Trigger completion |
| `<C-j>` / `<C-k>` | i | Next / prev completion item |
| `<CR>` | i | Confirm completion |
| `<C-e>` | i | Abort completion |
| `<C-b>` / `<C-f>` | i | Scroll docs up / down |
| `<Tab>` / `<S-Tab>` | i/s | Jump between snippet placeholders |

---

## Snippets

| Key | Mode | Action |
|---|---|---|
| `<Tab>` | i/s | Expand snippet / next placeholder |
| `<S-Tab>` | i/s | Previous placeholder |
| `<C-j>` | i/s | Next choice node |
| `<C-k>` | i/s | Previous choice node |

---

## Git

| Key | Action |
|---|---|
| `<leader>gg` | Open Neogit |
| `<leader>gG` | Neogit (current dir) |
| `<leader>gc` | Neogit commits |
| `<leader>gd` | Diffview open |
| `<leader>gD` | Diffview close |
| `<leader>gf` | Diffview file history (current file) |
| `<leader>gh` | Stage hunk (gitsigns) |
| `<leader>gH` | Reset hunk (gitsigns) |
| `<leader>gb` | Git blame line |
| `<leader>gp` | Preview hunk |
| `[h` / `]h` | Previous / next hunk |
| `<leader>gw` | Git worktree switch (Telescope) |
| `<leader>gW` | Create git worktree |

---

## File Explorer

### neo-tree (sidebar)

| Key | Action |
|---|---|
| `<leader>kk` | Focus neo-tree |
| `<leader>kb` | Show neo-tree |
| `<leader>kf` | Reveal current file in neo-tree |

### oil.nvim (editable buffer)

| Key | Action |
|---|---|
| `-` | Open parent directory |
| `<localleader>-` | Open parent in floating window |
| `<CR>` | Open file / enter dir |
| `g?` | Show help |
| `<C-s>` | Save changes |

---

## Telescope (Fuzzy Finder)

### Files

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fF` | Find files (no gitignore) |
| `<leader>fr` | Recent files |
| `<leader>fb` | Buffers |
| `<leader>fe` | File browser |

### Grep / Search

| Key | Action |
|---|---|
| `<leader>sg` | Live grep |
| `<leader>sG` | Live grep (no gitignore) |
| `<leader>sw` | Grep word under cursor |
| `<leader>sc` | Search colorschemes |
| `<leader>s/` | Search in open buffers |

### Git

| Key | Action |
|---|---|
| `<leader>gc` | Git commits |
| `<leader>gS` | Git status |
| `<leader>gb` | Git branches |

### LSP / Symbols

| Key | Action |
|---|---|
| `<leader>ss` | Document symbols |
| `<leader>sS` | Workspace symbols |
| `<leader>sd` | Document diagnostics |
| `<leader>sD` | Workspace diagnostics |
| `<leader>sR` | LSP references |

### Misc

| Key | Action |
|---|---|
| `<leader>sh` | Help tags |
| `<leader>sk` | Keymaps |
| `<leader>sm` | Marks |
| `<leader>sq` | Quickfix |
| `<leader>sl` | Loclist |
| `<leader>sy` | Yank history (yanky) |
| `<leader>sp` | Projects |

### Inside Telescope

| Key | Action |
|---|---|
| `<C-j>` / `<C-k>` | Move selection |
| `<CR>` | Open |
| `<C-x>` | Open in split |
| `<C-v>` | Open in vsplit |
| `<C-t>` | Open in tab |
| `<C-q>` | Send to quickfix |
| `<Tab>` | Multi-select |

---

## Terminal

Powered by toggleterm.nvim:

| Key | Action |
|---|---|
| `<C-\>` | Toggle floating terminal |
| `<leader>tg` | lazygit |
| `<leader>td` | lazydocker |
| `<leader>tn` | node REPL |
| `<leader>tu` | ncdu |
| `<leader>th` | htop |
| `<leader>tp` | Python REPL |
| `<leader>tr` | Send line to terminal |

---

## Diagnostics & Quickfix

| Key | Action |
|---|---|
| `<leader>xx` | Toggle Trouble |
| `<leader>xw` | Workspace diagnostics (Trouble) |
| `<leader>xd` | Document diagnostics (Trouble) |
| `<leader>xq` | Quickfix (Trouble) |
| `<leader>xl` | Loclist (Trouble) |
| `gR` | LSP references (Trouble) |
| `[q` / `]q` | Previous / next quickfix |
| `[f` / `]f` | Previous / next file |
| `[ ` / `] ` | Add blank line above / below |

---

## Code Actions & Refactoring

| Key | Mode | Action |
|---|---|---|
| `<localleader>rs` | n/v | Select refactoring |
| `<localleader>re` | n/v | Extract function |
| `<localleader>rf` | n/v | Extract to file |
| `<localleader>rv` | n/v | Extract variable |
| `<localleader>ri` | n | Inline variable |
| `gC.` | n | Text case conversion (Telescope) |
| `gC` | n | Text case prefix (e.g. `gCc` = camelCase) |
| `<leader>bb` | n | Open compiler / build runner |

---

## DAP (Debugger)

| Key | Action |
|---|---|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Set conditional breakpoint |
| `<leader>dc` | Continue |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>dO` | Step over |
| `<leader>dr` | Open REPL |
| `<leader>dl` | Run last |
| `<leader>dh` | Hover variable (dap-ui) |
| `<leader>dU` | Toggle DAP UI |

---

## UI Toggles

| Key | Action |
|---|---|
| `<leader>ut` | Toggle transparency |
| `<leader>uo` | Toggle outline |
| `<leader>uu` | Toggle undotree |
| `<leader>um` | Toggle Markdown table mode |
| `<leader>n` | Hide line numbers / statuscolumn (copy-paste mode) |
| `<leader>N` | Restore line numbers / statuscolumn |
| `<F10>` | Toggle line wrap |

---

## Notes (Obsidian)

| Key | Action |
|---|---|
| `<leader>oo` | Open Obsidian vault |
| `<leader>oa` | New Obsidian note |
| `<leader>ot` | Insert template |
| `<leader>or` | Reveal file in vault |
| `<leader>ob` | Backlinks |
| `<leader>ol` | Links |
| `<leader>os` | Quick switch |
| `<leader>og` | Grep notes |

---

## AI (CopilotChat)

| Key | Action |
|---|---|
| `<leader>ah` | CopilotChat help |
| `<leader>ap` | CopilotChat prompts |
| `<leader>ae` | Explain code |
| `<leader>at` | Generate tests |
| `<leader>ar` | Code review |
| `<leader>aR` | Refactor |
| `<leader>an` | Better naming |
| `<leader>ad` | Generate docs |
| `<leader>af` | Fix diagnostics |
| `<leader>ac` | Generate commit message |
| `<leader>ai` | Inline chat |
| `<leader>aq` | Ask question |

---

## Language: Go

| Key | Action |
|---|---|
| `<leader>gr` | Run Go file |
| `<leader>gR` | Run with args |
| `<leader>gt` | Run Go tests |
| `<localleader>gc` | Generate Go comment |

---

## Language: Java

| Key | Action |
|---|---|
| `<localleader>co` | Organize imports |
| `<localleader>cx` | Extract to method |
| `<localleader>cxv` | Extract to variable |
| `gS` | Go to super implementation |
