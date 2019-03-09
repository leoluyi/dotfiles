# Vim - Awesome shorcut keys

### Update vimrc

```
cd ~/.vim_runtime
git pull --rebase
```

### key mappings

- `<leader>` = `,`

### Switch modes

- `<esc>` or `<C-[>` to normal mode

### Verbs in Vim

- `d` Delete
- `c` Change
- `>` Indent
- `v` Visually select
- `y` Yank

### Nouns in Vim - Motions

Motions: `wWbBeEfFtT`

- `w` Forward to the beginning of next word
- `W` Forward to the beginning of the next WORD
- `b` Backward to the next beginning of a word
- `B` Backward to the next beginning of a WORD
- `e` Forward to the next end of word
- `E` Forward to the next end of WORD
- `<num>f<char>` Forward until (nth) `<char>`  (Inclusive)
- `<num>F<char>` backward until (nth) `<char>` (Inclusive)
- `<num>t<char>` forward unTil (nth) `<char>`  (Exclusive)
- `<num>T<char>` backward unTil (nth) `<char>` (Exclusive)

Advanced motions

- `(`, `)`    - Prev / Next sentences ("." delimited words)
- `{`, `}`    - Prev / Next paragraphs (next empty line)
- `26 G`      - Go to line `26`
- `gg`        - Go to the top of the file
- `0`         - Front of line
- `^`         - Front of line (first non-blank)
- `%`         - Matching brace/bracket/paren/tag (with matchtag plugin)
- `$`         - End of line

### Nouns in Vim - Text Objects

Text Objects: `{}[]()w<>t'"`

- `iw` inner word
- `it` inner tag
- `i"` inner quotes
- `ip` inner paragraph
- `i(` inner parentheses
- `i[` inner bracket
- `as` around sentence
- select to next char "w" `vfw`, select 'til next char "w" `vtw`

### Pen to the page

- `i` Enter insert mode at cursor
- `I` Enter insert mode at first non-blank character
- `s` Delete character under cursor and enter insert mode
- `S` Delete line and begin insert at beginning of same line
- `a` Enter insert mode _after_ cursor
- `A` Enter insert mode at the end of the line
- `o` Enter insert mode on the next line
- `O` enter insert mode on the above line
- `C` Delete from cursor to end of line and begin insert

### Searching

- `/pattern` - search forward for pattern
- `?pattern` - search backward
- `n`        - repeat forward search
- `N`        - repeat backward
- `:nohl` or `<leader><CR>` - no highlight on search result
- `:set ignorecase` - case insensitive
- `:set smartcase`  - use case if any caps used
- `:set incsearch`  - show match as search proceeds
- `:set hlsearch`   - search highlighting

More cool searching tricks:

- `*`                 - search for word currently under cursor  (bounded)
- `g*`                - search for partial word under cursor    (unbounded)
                        (repeat with n)
- `#`                 - search for word under cursor - backward (bounded)
- `g#`                - search for word under cursor - backward (unbounded)
- `ctrl-o`, `ctrl-i`  - go through jump locations
- `[I`                - show lines with matching word under cursor

### Search and Replace

- `:%s/search_for_this/replace_with_this/gc` - search whole file and replace, confirm each replace
- `:s/search_for_this/replace_with_this/gi` - replace in the current line only, with case insensitive

### Changing

- `c`          - change (Same as `d` but put me in insert mode)
- `cc` = `S`   - delete current line and enter insert mode
- `c0`         - change to begining of line
- `C`          - change to end of line
- `r`          - replace under cursor; `R` replace multiple characters
- `s`          - change under cursor, does the same thing as `x` then `i`

### Deleting

- `d`          - delete motion; `d3e` to delete 3 words
- `dd`         - delete current line; `3dd` to delete 3 lines
- `d0`         - delete to the beginning of line
- `D` or `d$`  - delete to end of line
- `x`          - delete in selection

### Cut and paste

- `I`          - insert before block (`<esc>` to finish insert)
- `A`          - append after block (`<esc>` to finish insert)
- `yy`         - copy line into paste buffer; `dd` cut line into paste buffer
- `p`          - paste buffer below cursor line; `P` paste buffer above cursor line

More cool tricks:

- `"0 p`       - paste from last yanked text
- `"+ y<CR>`   - copy to the system clipboard
- `"+ p`       - paste from the system clipboard
- `x  p`       - swap two characters (`x` to delete one character, then `p` to put it back after the cursor position)

### Files

- `ZZ`
- `:e path/to/file` - edit new file (buffer)
- `:e!`             - revert to last save (or use `:earlier 1f`)
- `:w !sudo tee %`  - force write with sudo trick. `%` (special variables) "the current file"
- `:w!`             - force write
- `:w new.txt`      - save (save content to `new.txt` while keeping `original.txt` as the opened buffe)
- `:wall`           - save all (save all changed buffers)
- `:sav new.txt`    - save as (first write content to the file `new.txt`, then hide buffer `original.txt`, finally open `new.txt` as the current buffer)
- `:sav new_name` + `:!rm <C-r>#` (expand to an alternate-file) rename files
- (mru) `<leader>f` - open recently opened files
- (NERDTree) `<leader>nn` - toggle nerdtree
- (NERDTree) `o`          - open/close folder

> Note that filename with "space" must be escaped with backslash `\`.

### Navigation

- `Ctrl-o` - old cursor position - this is a standard mapping but very useful, so included here
- `Ctrl-i` - opposite of Ctrl-O (again, this is standard)
- \`\` (two back tick) jump between previous cursor position

**Buffers**

- `<C-^>` or `:b#`          - switch between alternative files (buffer)
- `:ls`                     - list buffers
- `:b 2`                    - open buffer #2 in this window
- `:bp`                     - go to previous buffer
- `:bn`                     - go to next buffer
- `<leader>bd` or `:Bclose` - close (dismiss) current buffer
- `<leader>ba`              - close all buffers
- `<leader>o`               - open/toggle (bufexplorer)

**Windows (Panes)**

- `:split filename` / `:vsplit filename` - split / vertical split window and load another file
    - `:new` / `:vnew`
    - `<C-w> s` / `<C-w> v`
- `<C-w> up arrow` or `<C-w> [hjkl]` or `<C-hjkl>` - move cursor up a window
- `<C-w> w`            - move cursor to another window (cycle)
- `<C-w> +`, `<C-w> -` - window resize up / down (can do with number prefix)
- `<C-w> >`, `<C-w> <` - window resize left / right (can do with number prefix)
- `10 <C-w> +`         - increase window size by 10 lines
- `<C-w> c` or `:hide` - close current window
- `<C-w> _`            - maximize current window
- `<C-w> =`            - make all equal size
- `:sview file`        - same as split, but readonly
- `:only`              - keep only this window open

**Tabs**

- `<leader>tn` tab new
- switch between tabs:
    - goto next tab `gt`
    - goto prev. tab `gT`
- `<leader>tc` tab close
- `<leader>to` tab only
- `<leader>tm` tab move
- `<leader>te` open a new tab with the current buffer's path

### CWD (current working directory)

- `:pwd` show CWD
- `<leader>cd` Switch CWD to the directory of the open buffer
- `:echo @%` show current file path

### Code editing

- `<leader>pp`         - toggle paste mode
- `:set syntax=python` - change syntax highlighting
- `J`                  - join selected lines `<num>J`
- `~`                  - Toggle the case of character under cursor.
                       (Visual mode) `U` for uppercase, `u` for lowercase
- `gUiw` Change current word to uppercase
- [(vim-commentary)](https://github.com/tpope/vim-commentary)
    - `gcc` comment out a line (takes a count)
    - `gc` comment out the selection
    - `gcap` comment out a paragraph
- (surround.vim)
    - `ysiw"` add quotes in word
    - `ds"` remove the delimiters entirely
    - `cs"'` change surrounding

Other settings

- `:set nonumber` disable line number
- `:set norelativenumber` disable relative line number

### Advanced Editing: jump-select-copy-paste

http://vim.wikia.com/wiki/Moving_around

- cuts to first non-whitespace character `df `
- replace a word with yanked text: `yiw` in "first" then `viwp` on "second"
- `N[jk]` jump N lines up/down
- `''` jump to previous line
- `[(` jump cursor N times back to unmatched parentheses, forward `])`
- `[{` jump cursor N times back to unmatched braces, forward `]}`
- `]]` jump to next section (Depending on your current filetype this may move between functions)
- `[[` jump to previous section

### Folding

- fold selected lines `zf` (manual mode)
- open/close fold in file `zr`/`zm`. `zR`/`zM` for all levels
- toggle/open/close single fold `za`/`zo`/`zc`. `zA`/`zO`/`zC` for all levels

### Sublime flavor select (vim-multiple-cursors)

- start: `<C-n>` start multicursor and add a _virtual cursor + selection_ on the match
- next: `<C-n>` add a new virtual cursor + selection on the next match
- skip: `<C-x>` skip the next match
- prev: `<C-p>` remove current virtual cursor + selection and go back on previous match
- select all: `<A-n>` start muticursor and directly select all matches

### Commands

- `!`    - turn a command into a toggle command, e.g., `:set cursorline <-> :set nocursorline` == `:set cursorline!`
- `q:`   - show command-line history window
- `q/`   - show searches history
- Type `:` or `/` to start entering a command or search, then press the 'cedit' key (default is `Ctrl-f`)
- Press `Enter` to execute the current line (and close the command-line window); or Press `Ctrl-c twice` to close the command-line window (cancel).

### Registers

When you copy and cut stuff, it gets saved to registers. You can pull stuff from those registers at a later time.

- `:reg`     - show named registers and what's in them
- `"5p`      - paste what's in register `"5`

**Special registers**

- `""` no-name register (quotation register) - last cut / delete by `dcsxy`
- `"0` last yanked register
- `"0` to `"9` Nth-yanked register
- `"_` blackhole register --> `"_ d` delete and throw to blackhole
- `"/` last search pattern
- `".` last inserted text (read only)
- `"%` current filename (read only)
- `"#` alternate file name (last edited file) (read only)
- `":` last command (read only)

**Recording**

You can also record a whole series of edits to a register, and then apply them over and over.

- `qk`       - records edits into register k 
               (q again to stop recording)
- `@k`       - execute recorded edits (macro)
- `@@`       - repeat last one
- `5@@`      - repeat 5 times
- `"kp`      - print macro k 
               (e.g., to edit or add to .vimrc)
- `"kd`      - replace register k with what cursor is on

### Misc

- `u` - Undo (See :help undo, it's complicated)
- `<C-r>` - Redo
- `.` - Redo last change

## References

- [buffers vs tabs?](https://stackoverflow.com/a/26710166/3744499)
- [vim--buffers-and-windows](https://www.openfoundry.org/tw/tech-column/2383-vim--buffers-and-windows)
- [Huckleberry Vim](https://github.com/shawncplus/vim-classes/blob/master/expert-1.md)
- [vimrc](https://github.com/amix/vimrc)
- [most-used vim commands/keypresses](https://stackoverflow.com/a/5400978)
- https://stackoverflow.com/a/9927057/3744499
- [Vim registers: The basics and beyond](https://www.brianstorti.com/vim-registers/)
- [skwp/dotfiles#vim](https://github.com/skwp/dotfiles#vim---whats-included)
- [vim help](https://www.cs.swarthmore.edu/oldhelp/vim/)

**Videos**

- [Vim Basics in 8 Minutes](https://www.youtube.com/watch?v=ggSyF1SVFr4)
- [A Vid in which Vim Saves Me Hours & Hundreds of Clicks](https://www.youtube.com/watch?v=hraHAZ1-RaM)
