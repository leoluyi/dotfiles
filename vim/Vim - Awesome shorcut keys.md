# Vim - Awesome shorcut keys

- https://stackoverflow.com/a/26710166/3744499
- https://www.openfoundry.org/tw/tech-column/2383-vim--buffers-and-windows
- https://github.com/shawncplus/vim-classes/blob/master/expert-1.md
- https://github.com/amix/vimrc
- https://stackoverflow.com/a/5400978
- https://stackoverflow.com/a/9927057/3744499

### Update vimrc

```
cd ~/.vim_runtime
git pull --rebase
```

### key mappings

- `<leader>` = `,`

### switch modes

- `<esc>` or `<C-[>` to normal mode

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

### Motions

Basics: `wWbBeE`

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

### Advanced motions

```
() - Sentences  (". " delimited words)
{} - Paragraphs (Next empty line)

    Example:
        d} - Delete until next paragraph (useful for deleting unnecessary conditional blocks)

        if (something)
        {
            test
        }

; - Repeat last motion forward
, - Repeat last motion backward
g<hjkl> - Go down a _visual_ line
    This is some text that's going to wrap so I have to fill in a lot of words. I can never think of things to type here because I'm not a creative person but this will demonstrate visual versus hardbroken lines.
    This is a second line

<#>G - Go to Line #
gg   - Go to the top of the file

]] - Next section (Depending on your current filetype this may move between functions)
[[ - Previous section (see above note)
0 - Front of line
^ - Front of line (first non-blank)
% - Matching brace/bracket/paren/tag(with matchtag plugin, see session 3)
$ - End of line
```

### Searching

- `/`  Forward
- `?`  Backward
- `*`  Word under cursor - forward  (bounded)
- `g*` Word under cursor - forward  (unbounded)
- `#`  Word under cursor - backward (bounded)
- `g#` Word under cursor - backward (unbounded)
- `n`  Next result, forward
- `N`  Next result, backward

### Changing

- `c` Change (Same as d but put me in insert mode)
    - `cw` - change word
    - `c<motion>`
    - `cc` = `S` - Delete current line and enter insert mode
    - `C` change to end of line
    - `2cw` - Delete 2 words and enter insert mode
- `r` replace single character; `R` replace multiple characters
- `s` change single character, does the same thing as `x` then `i`

### Deleting

- `d` - Delete: `[range]d<motion>`
    - `dd`  - delete current line
    - `dj`  - delete current and next line (j = down)
    - `2dj` - delete current and 2 lines downward
    - `D` delete to end of line;
- `x` delete in selection

### Cut and paste

- `I` insert before block (`<esc>` to finish insert)
- `A` append after block (`<esc>` to finish insert)
- `yy` copy line into paste buffer; `dd` cut line into paste buffer
- `p` paste buffer below cursor line; `P` paste buffer above cursor line
- `xp` swap two characters (x to delete one character, then p to put it back after the cursor position)

```
~  - Toggle the case of character under cursor
g~ - Toggle case of [motion]
    g~w - Toggle case of cursor -> end of word
        tr|ue -> g~w -> trUE
    g~iw - Toggle case of entire word under cursor
        tr|ue -> g~iw -> TRUE
```

### Buffers

- edit new file (buffer) `:e path/to/file`
- list buffers `:ls`
- switch between alternative buffer `<C-^>` or `:b#`
- switch to buffer number `N`: `N<C-^>` or `:bN`
- close (dismiss) current buffer `<leader>bd` or `:Bclose`
- close all buffers `<leader>ba`
- open/toggle (bufexplorer) `<leader>o`

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

- show CWD `:pwd`
- switch CWD to the directory of the open buffer `<leader>cd`
- show current file path `:echo @%`

### Code editing

- toggle paste mode on and off `<leader>pp`
- change syntax highlighting `:set syntax=php`
- (vim-commentary) comment out a line (takes a count) `gcc`
- (vim-commentary) comment out the selection `gc` 
- (surround.vim) add quotes in word `ysiw"`
- (surround.vim) remove the delimiters entirely `ds"`
- (surround.vim) change surrounding `cs"'`
- join [count]/selected lines `J`
- disable line number: `:set nonumber`

### Advanced Editing: jump-select-copy-paste

http://vim.wikia.com/wiki/Moving_around

- cuts to the end of the line `d$` 
- cuts to the beginning `d0`
- cuts to first non-whitespace character `df `
- paste from last yanked text `"0p`
- copy to the system clipboard `"+y<CR>`
- replace a word with yanked text: `yiw` in "first" then `viwp` on "second"
- select to next char "w" `vfw`, select 'til next char "w" `vtw`
- select in word `viw`
- select in paragraph `vip`
- select in quotes `vi"`
- select (all-include) in quotes `va"`
- jump N lines up/down `N[jk]`
- jump to previous cursor position \`\` (two back tick)
- jump to previous line `''`  (two single quotes)
- jump cursor N times back to unmatched parentheses `[(`, forward `])`
- jump cursor N times back to unmatched braces `[{`, forward `]}`
- find next char "w" `fw`, 'til next char "w" `tw`
- find backward char "w" `Fw`, `Tw` (F or T in opposite direction")
- fold selected lines `zf` (manual mode)
- open/close fold in file `zr`/`zm`. `zR`/`zM` for all levels
- toggle/open/close single fold `za`/`zo`/`zc`. `zA`/`zO`/`zC` for all levels

```
# Text objects: {}[]()w<>t'"`

i vs a:
    i = Inside
        Example:
            self.test[obj|ect] -> ci[ -> self.test[|]

    a = Around
        Example:
            self.test[obj|ect] -> ca[ -> self.test|
```

### Sublime flavor select (vim-multiple-cursors)

- start: `<C-n>` start multicursor and add a _virtual cursor + selection_ on the match
- next: `<C-n>` add a new virtual cursor + selection on the next match
- skip: `<C-x>` skip the next match
- prev: `<C-p>` remove current virtual cursor + selection and go back on previous match
- select all: `<A-n>` start muticursor and directly select all matches

### find and replace

- search forward `/`, search backward `?`
- next result `n`, previous result `N`
- search forward under the cursor `*`
- search backward under the cursor `#`
- no highlight on search result `:noh` or `<leader><CR>`

### Files

- (special variables) `%` means "the current file"
- revert to last save `:e!`
- save `:w new.txt` (save content to `new.txt` while keeping `original.txt` as the opened buffe)
- save all `:wall` (save all changed buffers)
- save as `:sav new.txt` (first write content to the file `new.txt`, then hide buffer `original.txt`, finally open `new.txt` as the current buffer)
- rename files: `:sav new_name` then `:!rm <C-r>#`
- `<C-r>#` will instantly expand to an alternate-file 
- open recently opened files (mru) `<leader>f`
- (NERDTree) toggle `<leader>nn`
- (NERDTree) open/close folder `o`
- Switch CWD to the directory of the open buffer `<leader>cd`

> Note that filename with "space" must be escaped with backslash `\`.

### Commands

- force write `:w!`
- `!` will turn a command into a toggle command `:set cursorline <-> :set nocursorline` == `:set cursorline!`

### Registers

Special registers:

- `"` Noname buffer - Last `dcsxy`
- `_` Blackhole buffer
- `%` Filename
- `/` Last search
- `:` Last command
- `.` Last edit
- paste from last yanked text `"0p`

### Misc

- `u` - Undo (See :help undo, it's complicated)
- `<C-r>` - Redo
- `.` - Redo last change
