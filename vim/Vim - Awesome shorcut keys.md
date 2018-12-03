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
- `[n]f<o>` Forward until (nth) (o)  (Inclusive)
- `[n]F<o>` Backward until (nth) (o) (Inclusive)
- `[n]t<o>` Forward until (nth) (o)  (Exclusive)
- `[n]T<o>` Backward until (nth) (o) (Exclusive)

Advanced motions

- `()` Next sentences  ("." delimited words)
- `{}` Next paragraphs (Next empty line)
- `[n]G` Go to line [n]
- `gg` Go to the top of the file
- `0` Front of line
- `^` Front of line (first non-blank)
- `%` Matching brace/bracket/paren/tag (with matchtag plugin)
- `$` End of line

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

- `/`  Forward
- `?`  Backward
- `*`  Word under cursor - forward  (bounded)
- `g*` Word under cursor - forward  (unbounded)
- `#`  Word under cursor - backward (bounded)
- `g#` Word under cursor - backward (unbounded)
- `n`  Next result, forward
- `N`  Next result, backward
- no highlight on search result `:noh` or `<leader><CR>`

### Find and Replace

- `:%s/foo/bar/g` replace 'foo' (in all lines) it with 'bar'.
- `:s/foo/bar/gi` replace 'foo' (in the current line only) it with 'bar'. (case insensitive)

### Changing

- `c` Change (Same as d but put me in insert mode)
- `cc` = `S` Delete current line and enter insert mode
- `C` change to end of line
- `r` replace single character; `R` replace multiple characters
- `s` change single character, does the same thing as `x` then `i`

### Deleting

- `d` delete motion `[range]d<motion>`
- `dd` delete current line
- `d0` delete to the beginning of line
- `D` or `d$` delete to end of line
- `x` delete in selection

### Cut and paste

- `I` insert before block (`<esc>` to finish insert)
- `A` append after block (`<esc>` to finish insert)
- `yy` copy line into paste buffer; `dd` cut line into paste buffer
- `p` paste buffer below cursor line; `P` paste buffer above cursor line
- `xp` swap two characters (x to delete one character, then p to put it back after the cursor position)
- `"0p` paste from last yanked text
- `"+y<CR>` copy to the system clipboard
- `"+p` paste from the system clipboard

### Files

- `:e path/to/file` edit new file (buffer)
- `:e!` revert to last save
- `:w !sudo tee %` force write with sudo trick. `%` (special variables) "the current file"
- `:w!` force write
- `:w new.txt` save (save content to `new.txt` while keeping `original.txt` as the opened buffe)
- `:wall` save all (save all changed buffers)
- `:sav new.txt` save as (first write content to the file `new.txt`, then hide buffer `original.txt`, finally open `new.txt` as the current buffer)
- `:sav new_name` + `:!rm <C-r>#` (expand to an alternate-file) rename files
- (mru) `<leader>f`open recently opened files
- (NERDTree) `<leader>nn` toggle nerdtree
- (NERDTree) `o` open/close folder

> Note that filename with "space" must be escaped with backslash `\`.

### Buffers

- `<C-^>` or `:b#` switch between alternative files (buffer)
- `:ls` list buffers
- `:bN` switch to buffer number
- `<leader>bd` or `:Bclose` close (dismiss) current buffer
- `<leader>ba` close all buffers
- `<leader>o` open/toggle (bufexplorer)

### Windows

- window split `:new` `:vnew` `:split [path/to/file]` `:vsplit [path/to/file]` `<C-w>s` `<C-w>v`
- move between windows `<C-w> [hjkl]` or `<C-hjkl>`
- switch windows back and forth `<C-w>w`
- window resize `<C-w>+` `<C-w>-` `<C-w>>` `<C-w><` (prefix number to adjust size)
- close window `<C-w>c`

### Tabs

- tab new `<leader>tn`
- switch between tabs: goto next tab `gt`, goto prev. tab `gT`
- tab close `<leader>tc`
- tab only `<leader>to`
- tab move `<leader>tm`
- Opens a new tab with the current buffer's path `<leader>te`

### CWD (current working directory)

- `:pwd` show CWD
- `<leader>cd` Switch CWD to the directory of the open buffer
- `:echo @%` show current file path

### Code editing

- `<leader>pp` toggle paste mode
- `:set syntax=python` change syntax highlighting
- (vim-commentary) `:echo @%` comment out a line (takes a count)
- (vim-commentary) `gc` comment out the selection
- (surround.vim) `ysiw"` add quotes in word
- (surround.vim) `ds"` remove the delimiters entirely
- (surround.vim) `cs"'` change surrounding
- `J` join [count]/selected lines
- `~` Toggle the case of character under cursor. (Visual mode) `U` for uppercase, `u` for lowercase
- `gUiw` Change current word to uppercase
- `:set nonumber` disable line number
- `:set norelativenumber` disable relative line number

### Advanced Editing: jump-select-copy-paste

http://vim.wikia.com/wiki/Moving_around

- cuts to first non-whitespace character `df `
- replace a word with yanked text: `yiw` in "first" then `viwp` on "second"
- `N[jk]` jump N lines up/down
- \`\` (two back tick) jump to previous cursor position
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

- `!` will turn a command into a toggle command `:set cursorline <-> :set nocursorline` == `:set cursorline!`

### Registers

Special registers:

- `""` Noname register - Last `dcsxy`
- `"0` last yanked text
- `"0` to `"9` yanked register
- `"_` Blackhole register
- `"/` Last search pattern
- `".` Last inserted text (read only)
- `"%` Current filename (read only)
- `"#` Alternate file name (last edited file) (read only)
- `":` Last command (read only)

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
