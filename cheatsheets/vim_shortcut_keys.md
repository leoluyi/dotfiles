# Vim - Awesome Keyboard Shorcuts

### key mappings

- `<leader>` = `,`
- `<C-Space>` or `<C-n>` to trigger auto completion
- `<C-p>` to select previous auto completion

### Switch modes

- `<esc>` or `<C-[>` to normal mode

### Verbs in Vim

- `d` Delete
- `c` Change
- `>` Indent
- `v` Visually select
- `y` Yank

### Structure of an Editing Command

```
editing commands = <number><command><text object or motion>
```

### MOVEMENTS

Motions: `wW bB eE fF tT`

```
h        -   Move left
j        -   Move down
k        -   Move up
l        -   Move right
3j       -   Move 3 lines down
$        -   Move to end of line
0        -   Move to beginning of line (including whitespace)
^        -   Move to first character on line
gg       -   Move to first line of file
G        -   Move to last line of file

3G       -   Go to line 3
:3<CR>   -   Go to line 3

w        -   Move forward to next word, with cursor on first character (use W to jump by whitespace only)
b        -   Move backward to next word, with cursor on first character (use B to jump by whitespace only)
e        -   Move forward to next word, with cursor on last character (use E to jump by whitespace only)
ge       -   Move backwards to next word, with cursor on last character (use gE to jump by whitespace only)
(        -   Move to beginning of previous sentence. Use ) to go to next sentence
{        -   Move to beginning of previous paragraph. Use } to go to next paragraph
+        -   Move forward to the first character on the next line
-        -   Move backwards to the first character on the previous line

<C-u>    -   Move up by half a page
<C-d>    -   Move down by half a page
<C-b>    -   Move up by a page
<C-f>    -   Move down by a page

H        -   Move cursor to header (top) line of current visible window
M        -   Move cursor to middle line of current visible window
L        -   Move cursor to last line of current visible window

f<character>  -   Find and jump to next 'character' on the current line (inclusive)
F<character>  -   to find backwards
t<character>  -   Find and jump till next 'character' on the current line (exclusive)
T<character>  -   to find backwards
;        -   Repeat last f, t, F, or T command
,        -   Repeat last f, t, F, or T command in opposite direction

# Advanced motions

()       -   Jump to prev / next sentences ("." delimited words)
{}       -   Jump to prev / next paragraphs (next empty line)

%        -   Go to match of next parentheses, bracket brace
])       -   Jump N times forward to unmatched parentheses, `[(` for backward
]}       -   Jump N times forward to unmatched braces, `[{` for backward

]]       -   Jump (forward) N times to the beginning of next section / function / class
][       -   Jump (forward) N times to the end of next section / function / class

]m       -   Move (forward) to the beginning of the next Python method or function.
]M       -   Move (forward) to the end of the current Python method or function.

```

**Go through jumplist**

(contains all the points in any buffer you recently jumped to. It can be accessed with `:jumps`)

```
<C-o> and <C-i>       -   up / down walk through the jump list history
```

Special marks `:marks`

```
''                    -   jump to previous line position
'0                    -   jump to last file edited when Vim was exited


`` (double backtick)  -   jump between previous position and the current position cursor position in jump list
`.                    -   go back last-change-position special mark


(The ` goes to a mark position, and the ' goes to a line position)
```

**The changelist**

(contains all the points in the current buffer where you have recently changed something. It can be accessed with the `:changes`)


```
g; and g,             -   jump back and forth change list
```

### NORMAL MODE -> INSERT MODE

```
i        -   Enter insert mode to the left of the cursor
a        -   Enter insert mode to the right of the cursor
I        -   Enter insert mode at first character of current line
A        -   Enter insert mode at last character of current line

o        -   Insert line below current line and enter insert mode
O        -   Insert line above current line and enter insert mode
```

### DELETION & CHANGING

```
x        -   Delete character forward (under cursor). use x do delete backwards (before cursor)
r        -   Replace single character under cursor, and remain in normal mode. Use `R` replace multiple characters
s        -   Delete character under cursor, then switch to insert mode. Does the same thing as `x` then `i`

d<movement>  -   Delete in direction of movement.
d3e      -   delete 3 words.
bdw      -   delete a word backward.

dd       -   Delete entire current line. `3dd` to delete 3 lines
D / d$   -   Delete until end of line
0D       -   Clear current line without removing the line
d0       -   Delete to the begining of line

c        -   Change (Same as `d` but put me in insert mode)
cm       -   Change the character or word (w) in motion m, then enter insert mode
cc / S   -   Change current line and enter insert mode (unlike dd which leaves you in normal mode)
C / c$   -   Change from cursor to end of line, and enter insert mode
c0       -   Change to begining of line and enter insert mode
```

### YANK & PUT

```
y        -   Yank (copy) highlighted text
yy       -   Yank current linepPut (paste) yanked text below current line
yw       -   Yank a word from the cursor
ynw      -   Yank n words from the cursor
y$       -   Yank till the end of the line
p        -   Yank register below cursor line
P        -   Put yanked text above current line

J        -   Join current line with the next line
gJ       -   Join lines without join-position space
gqq      -   Break (split) lines at line width

xp       -   Transpose two letters (delete and paste, technically)

# More cool tricks:

"0 p       - paste from last yanked text
"+ y<CR>   - copy to the system clipboard
"+ p       - paste from the system clipboard
x  p       - swap two characters (`x` to delete one character, then `p` to put it back after the cursor position)
```

### REGISTERS

When you copy and cut stuff, it gets saved to registers. You can pull stuff from those registers at a later time.

```
:reg          -   show named registers and what's in them
"5y           -   yank to register "5
"5p           -   paste what's in register "5

# Special registers

""            -   no-name register (quotation register) - last cut/del/yank
"0            -   last-yanked register
"0 ~ "9       -   Nth-yanked register
"-            -   small delete register (deletes which are less than a complete line)

"_            -   blackhole register --> `"_d` delete and throw to blackhole

"/            -   last searched pattern

# (Read-only registers)
".            -   last inserted text
"%            -   current filename
"#            -   alternate file name (last edited file)
":            -   last command

# Tricks in command mode for registers
# Either in search mode `/` or in last line command mode `:`

:<C-r>0       -   paste last yanked text
:<C-r>%       -   paste current filename

# Also use `@ <register>` for variable:

:echo @0      -   paste last yanked text
:echo @%      -   print current filename
```

### VISUAL MODE

```
v        -   Enter visual mode and highlight characters
V        -   Enter visual mode and highlight lines
CTRL+v   -   Enter visual block mode and highlight exactly where the cursor moves
o        -   Switch cursor from first & last character of highlighted block while in visual mode

~        -   Swap case under selection
U        -   Uppercase
u        -   Lowercase
gUiw     -   (normal mode) Change current word to uppercase

<<       -   Shift lines to left
>>       -   Shift lines to right

vat      -   Highlight all text up to and including the parent element
vit      -   Highlight all text up to the parent element, excluding the element
vac      -   Highlight all text including the pair marked with c (like va<, va' or va")
vic      -   Highlight all text inside the pair marked with c
vfw      -   Highlight to next char "w"
vtw      -   Highlight 'til next char "w"
```

### FILES

```
:pwd              -   print working directory
<leader>cd        -   set working directory to the directory of the open buffer
                      `:cd %:p:h`
                      (`:p` Make file name a full path. `:h` Head of the file name)

# See [more...](https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file)

<Shift> ZZ        -   write current file, if modified, and quit
<Shift> ZQ        -   force exit without saving

:q[uit]           -   Quit the current window
:qa               -   Quit all windows

:e path/to/file   -   edit new file (buffer)
:e!               -   revert to last save (or use :earlier 1f)
:w !sudo tee %    -   force write with sudo trick. % (special variables) "the current file"
:w!               -   force write
:w new.txt        -   save (save content to new.txt while keeping original.txt as the opened buffe)
:wa[ll]           -   save all (save all changed buffers)
:wqa[ll]          -   save all and quit

:sav new.txt      -   save as (first write content to the file new.txt, then hide buffer original.txt, finally open new.txt as the current buffer)
:sav new_name + :!rm <C-r>#    - Rename files (<C-r>#  expands to an alternate-file)
```

> Note that filename with "space" must be escaped with backslash `\`.

### BUFFERS

```
:ls (or :buffers)   -   list / show available buffers
:e filename         -   Edit a file in a new buffer

<C-^> or :b#        -   Switch between the "alternative buffers"
:bn[ext]            -   go to next buffer
:bp[rev]            -   go to previous buffer

<leader>bd          -   (Bclose.vim) close current buffer
<leader>ba          -   (Bclose.vim) close all buffers

:bd[elete]          -   deletes the current buffer, error if there are unwritten changes
:bd!                -   deletes the current buffer, no error if unwritten changes
:bufdo bd           -   deletes all buffers, stops at first error (unwritten changes)
:bufdo! bd          -   deletes all buffers except those with unwritten changes
:bufdo! bd!         -   deletes all buffers, no error on any unwritten changes
:bw[ipeout]         -   close buffer and deletes it

:%bd|e#             -   close all buffers but current one

:b <N>              -   go to the number of the buffer you are interested to open
:b <filename>       -   go to buffer (fuzzy matching)
:ball               -   opens up all available buffers in horizontal split window
:vertical ball      -   opens up all available buffero in vertical split window

:bufdo {cmd}        -   execute {cmd} for all buffers

:r <file_path>      -   reads a file from the path to the buffer
:r !<command>       -   reads the output of the command into buffer
:.! cat <file_path> -   reads the output of the command (eg: cat) into buffer or !! in ex-mode
```

set the config:

```
set wildmenu wildmode=full
set wildchar=<Tab> wildcharm=<C-Z>
```

![tabs-windows-buffers](./img/tabs-windows-buffers.png)

### WINDOWS (PANES) MANAGEMENT

```
# Split screen

:sp[lit] {filename}        -   horizontal split window and load another file
:vs[plit] {filename}       -   vertical split window and load another file
:sf[ind]                   -   find the path and open in split window
:vert sf[ind]              -   find the path and open in vertically split window

:sb[uffer] {bufname}       -   horizontal split with {bufname} from the buffer
:vert sb[uffer] {bufname}  -   vertical split with {bufname} from the buffer
:vert sball                -   vertical split all buffers
:vs | b[uffer] {bufname}   -   (same as above)

:new                -   horizontal split with new file
:vnew               -   vertical split with new file

https://vi.stackexchange.com/a/9480
:clo[se]            -   close current window
:hide               -   hide current window
:only               -   keep only this window open

:sview file         -   same as split, but readonly

vim -o file1 file2  -   open files with horizontally split windows
vim -O file1 file2  -   open files with vertically split windows

args **/*.yaml      -   manually add all yaml files into arg list;
:sall               -   then open them all in split windows;
:vert sall          -   or in vertically split windows.

# Switch between windows

<C-w> [hjkl] or <C-hjkl>  -   move cursor up/down/left/right a window (`<C-w> arrow`)
<C-w> w                   -   move cursor to another window (cycle)

# Shortcuts

<c-w> t <c-w> K     -   switch two vertically split windows to horizonally split
<c-w> t <c-w> H     -   horizontally --> vertically
                        https://stackoverflow.com/a/1269631/3744499

<C-w> s             -   split current window horizontally
<C-w> v             -   split current window [v]ertically
<C-w> n (or :new)   -   open new window (horizontally)

<C-w> c             -   close current window
<C-w>o / <C-w><C-o> -   (Only window) close all other windows

<c-w> t             -   makes the first (topleft) window current
<C-w> T             -   move current window into new tab
<c-w> K             -   moves the current window to full-width at the very top
<c-w> H             -   moves the current window to full-height at far left

# Resizing

:resize 20          -   Horizontal resize in active window
:vertical resize 20 -   Virtical resize in active window
<C-w> _             -   maximize height
<C-w> |             -   maximize width
<C-w> =             -   make all equal size
<C-w> >             -   Incrementally increase the window to the right. Takes a parameter, e.g. CTRL-w 20 >
<C-w> <             -   Incrementally increase the window to the left. Takes a parameter, e.g. CTRL-w 20 <
<C-w> -             -   Incrementally decrease the window's height. Takes a parameter, e.g. CTRL-w 10 -
<C-w> +             -   Incrementally increase the window's height. Takes a parameter, e.g. CTRL-w 10 +

# More split manipulation

" Rotate (swap) top/bottom or left/right split
<C-w> R

" Break out current window into a new tabview
<C-w> T

# Diff window

:windo {cmd}                 -   execute {cmd} for all windows
:windo diffthis              -   diff on this file for every window
:diffs, diffsplit {filename} -   diffs the current window with the file given
:diffoff                     -   turns off diff selection
```

### TAB VIEWS

```
:tabs               -   list opened tabs

# Open tabs

:tabe[dit] {file}   -   open file in newtab
:tabnew             -   (identical to above)
:tabnew %           -   open current file in newtab
:tabf[ind] {file}   -   open a new tab with filename given, searching the 'path' to find it

vim -p *.txt        -   open all txt files in tabs

<C-w>T              -   "move" current window to a new tab
:tab sp             -   "copy" current window to a new tab
                        (split the current window, but open the split in a new tab)

:tabc[lose] {#}     -   close the active (i-th) tab
:tabo[nly]          -   close all other tabs (show only the current tab)

# Moving tabs

:tabm[ove] 0        - move current tab to first
:tabm               - move current tab to last
:tabm {i}           - move current tab to position i+1

# Tab navigation

gt                  - goto next tab
gT                  - goto prev. tab
{i}gt               - go to tab in position i
:tabn and tabp      -   Go to next tab or previous tab
:tabfirst           -   Go to the first available tab
:tablast            -   Go to the last available tab

# Shortcuts

<leader>tn          - tab new
<leader>tc          - tab close
<leader>to          - tab only
<leader>tm          - tab move
<leader>te          - open a new tab with the current buffer's path

noremap tl <Esc>:tabnext<CR>
noremap th <Esc>:tabprevious<CR>
```

### MACROS

You can also record a whole series of edits to a register, and then apply them over and over.

```
qk              -  records edits into register "k" (`q` again to stop recording)
@k              -  execute recorded macro
@@              -  repeat last one
5@@             -  repeat 5 times

"kp           -  print macro "k" (e.g., to edit or add to `.vimrc`)

Advanced usage:

:norm @k        -  Use the normal mode command to apply the macro "k"
:%norm command  -  Apply the <command> to the whole file
```

### VIM FOLDING

```
zf#j      -   creates a fold from the cursor down # lines.
zf/string -   creates a fold from the cursor to string.
v{move}zf -   creates a visual select fold
zf'a      -   creates a fold from cursor to mark a

zo        -   opens a fold at the cursor.
zO        -   opens all folds at the cursor.
za        -   Toggles a fold at the cursor.
zc        -   closes a fold at the cursor.
zM        -   closes all open folds.
zd        -   deletes the fold at the cursor.
zE        -   deletes all folds.

zj        -   moves the cursor to the next fold.
zk        -   moves the cursor to the previous fold.
zm        -   increases the foldlevel by one.
zr        -   decreases the foldlevel by one.
zR        -   decreases the foldlevel to zero -- all folds will be open.
[z        -   move to start of open fold.
]z        -   move to end of open fold.

:set foldmethod=manual         -  default method v{select block}zf to fold
:set foldmethod=marker         -  use marker fold method {{{
:set foldemethod=marker/*,*/   -  user custom marker fold method
:set foldmethod=indent         -  automatically fold programms per its indentation
```


### HISTORY/COMMAND BUFFER

```
q:              -   list history in command buffer
q/              -   search history in command buffer
# Another way: press the 'cedit' key (default is `Ctrl-f`) in command mode `:` or search mode `/`
# Then press `Enter` to execute the current line
<C-c> <C-c>     -   close the command buffer

:set list       -   show hidden characters

<C-n>           -   Press after typing part of a word. It scrolls down the list of all previously used words
<C-p>           -   Press after typing part of a word. It scrolls up the list of all previously used words

!               -   Turn a command into a toggle command, e.g., `:set cursorline <-> :set nocursorline` == `:set cursorline!`

<C-g> or `:f`   -   Show file name
1<C-g>          -   Show full file path
```

### FILETYPE

```
:setf html      -   Set FileType to html
:set ft?        -   Show current FileType
gg=G            -   Re-indent for current FileType
:retab
```

### SEARCH & REPLACE

```
/pattern        -   search forward for pattern
?pattern        -   search backward
n               -   Repeat the last / or ? command
N               -   Repeat the last / or ? command in the opposite direction

*               -   Search forward for word under cursor
#               -   Search backwards for word under cursor

g*              - search for partial word under cursor    (unbounded)
g#              - search for word under cursor - backward (unbounded)

More cool searching tricks:

[I              - show lines with matching word under cursor.
gd              - go to definition for symbol under cursor

Replacement:

:nohl or <leader><CR>   -   no highlight on search result
:set ignorecase         -   case insensitive
:set smartcase          -   use case if any caps used
:set incsearch          -   show match as search proceeds
:set hlsearch           -   search highlighting

:%s/search_for_this/replace_with_this/gc -  replace in the whole file (%s), [c]onfirm each replace
:s/search_for_this/replace_with_this/gi  -  replace in the current line only, with case [i]nsensitive

:.,.+2s/                -  replace current line to the next 2 line.
                           (you can type `3:` for quick input)
```

### RANGES

[Ranges | Vim Tips Wiki | Fandom](https://vim.fandom.com/wiki/Ranges)

**Deleting, copying and moving**

| Command    | Description                                         |
|------------|-----------------------------------------------------|
| :21,25d    | delete lines 21 to 25 inclusive                     |
| :$d        | delete the last line                                |
| :1,.-1d    | delete all lines before the current line            |
| :.+1,$d    | delete all lines after the current line             |
| :21,25t 30 | copy lines 21 to 25 inclusive to just after line 30 |
| :$t 0      | copy the last line to before the first line         |
| :21,25m 30 | move lines 21 to 25 inclusive to just after line 30 |
| :$m 0      | move the last line to before the first line         |

### PLUGINS

[ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim) - Full path fuzzy file, buffer, mru, tag, ... finder for Vim

```
<c-f> / <c-b>    -   invoke CtrlP and cycle between modes in the sequence of:
                     files, buffers, MRU
<leader>f        -  `:CtrlPMRU` invoke MRU

<c-d>            -   switch to filename only search instead of full path
<c-r>            -   switch to regexp mode
<c-z>            -   mark/unmark multiple files and <c-o> to open them

<c-v>            -   Open the selected file in a 'vertical' split.
<c-s>            -   Open the selected file in a 'horizontal' split.
```

[ferret](https://github.com/wincent/ferret) - Multi-file search and replace

```
:Ack {pattern} {options}  -  Searches for {pattern} in all the files under the current directory

<leader>r                 -  Ack substitute (:Acks {pattern})
```

[vim-commentary](https://github.com/tpope/vim-commentary)

```
gcc        -   comment out a line (takes a count)
gc         -   comment out the selection
gcap       -   comment out a paragraph
```

[fzf-vim](https://github.com/junegunn/fzf.vim) - Full-text search

```
:Files {path}    -   search for files in {current} directory
:FZF             -   (same as above)

:Buffers         -   search for opened buffers
<leader>b        -   (same as above)

:Ag              -   Full-text search (ALT-A to select all, ALT-D to deselect all)

# Open files
<Enter>          -   open in current window
<C-t>            -   open in a new tab
<C-x>            -   open in a new split
<C-v>            -   open in a new vertical split
```

[vim-esearch](https://github.com/eugen0329/vim-esearch) - Performing project-wide async search and replace, similar to SublimeText

```
<leader>ff  -   invoke search and insert a search pattern (`:q` to quit)

# In quickfix window:
s           -   open file in split
v           -   open file in vertical split
t           -   open file in tab
<S-s,v,t>   -   open a file silently
<S-r>       -   reload currrent results
```

[surround.vim](https://github.com/tpope/vim-surround)

```
S "         -   (Visual mode) add quotes in selection

ys iw "     -   add quotes in word
ds "        -   remove the delimiters entirely
cs "'       -   change surrounding from " to '
yss )       -   wrap the entire line in parentheses
```

[NERDTree](https://github.com/scrooloose/nerdtree)

```
<leader>nn      -   toggle nerdtree
o               -   open/close folder

go              -   preview file

p               -   parent folder
P               -   go to root folder
C               -   set cursor as root folder
u               -   set root folder to upper layer

I               -   show hidden folder
m               -   opens the menu
?               -   help

i               -   horizontal split
s               -   vertical split
<C-w> ← | →     -   (left or right) to navigate
```

[vim-multiple-cursors (Sublime-text-flavor select)](https://github.com/terryma/vim-multiple-cursors)

```
<C-n>      -   (start) start multicursor and add a "virtual cursor + selection" on the match
<C-n>      -   (next) add a new virtual cursor + selection on the next match
<C-x>      -   (skip) skip the next match
<C-p>      -   (prev) remove current virtual cursor + selection and go back on previous match

<A-n>      -   (select all) start muticursor and directly select all matches
```

[vim-move](https://github.com/matze/vim-move)

```
zk        -   Move current line/selections up
zj        -   Move current line/selections down

(For MacOS, the key modifier could be <Opt+Cmd>.)
<A-k>  -   Move current line/selection up
<A-j>  -   Move current line/selection down
<A-h>  -   Move current character/selection left
<A-l>  -   Move current character/selection right
```

[vim-markdown](https://github.com/plasticboy/vim-markdown)

```
gx       -   open the link under the cursor
```

[ale](https://github.com/dense-analysis/ale)

```
<C-p>    -   navigate next errors
```

[jedi-vim](https://github.com/davidhalter/jedi-vim)

```
<C-Space>    -   Completion
K            -   Show Documentation/Pydoc (shows a popup with assignments)

<leader>g    -   Goto assignment (typical goto function)
<leader>d    -   Goto definition (follow identifier as far as possible, includes imports and statements)
<leader>s    -   Goto (typing) stub

<leader>r    -   Renaming
<leader>n    -   Usages (shows all the usages of a name)

Open module, e.g. `:Pyimport os` (opens the `os` module)
```

[vim-move](https://github.com/matze/vim-move)

```
<z-j>   Move current line/selection down
<z-k>   Move current line/selection up
```

[**close-buffers**](https://github.com/asheq/close-buffers.vim)

- `:CloseOtherBuffers` 🔥: Close all buffers except buffer in current window.
- `:CloseHiddenBuffers` 🔥: Close all buffers not visible in any window.
- `:CloseBuffersMenu` 🔥: Lets you choose any other command.

[**braceless.vim**](https://github.com/tweekmonster/braceless.vim)

- Moving to recognized blocks is done with `[[` and `]]`
- `vaP`, `ciP`, `>iP`

[**ctrlp.vim**](https://github.com/ctrlpvim/ctrlp.vim)

- Run `:CtrlP` or `:CtrlP` [starting-directory] in find file mode.
- Run `:CtrlPBuffer` or `:CtrlPMRU` in find buffer or find MRU file mode.
- Run `:CtrlPMixed` to search in Files, Buffers and MRU files at the same time.

[Nvim-R](https://raw.githubusercontent.com/jalvesaq/Nvim-R/master/doc/Nvim-R.txt)

- https://medium.freecodecamp.org/turning-vim-into-an-r-ide-cd9602e8c217
- https://gist.github.com/leoluyi/2aeb4795c99de487b568178a31f7b635

Commands

- `devtools::install_github("jalvesaq/colorout")`
- `\rf` opens vim-connected R session
- `<Space>` sends code from vim to R; here remapped in `init.vim` from default `\l`
- `:split` or `:vsplit`: splits viewport (similar to pane split in tmux)
- `<C-x><C-o>` omni completion for R objects/functions.
- `<C-w>H` or `<C-w>K`: toggles between horizontal/vertical splits
- `<C-w>w` jumps cursor to R viewport and back
- `<C-w>r` swaps viewports

```
Menu entry                                Default shortcut~
Start/Close
 -* Start R (default)                                  \rf
  . Start R (custom)                                   \rc
  --------------------------------------------------------
 -* Close R (no save)                                  \rq
  . Stop R                                          :RStop
-----------------------------------------------------------
Send
 -* File                                               \aa
  . File (echo)                                        \ae
  . File (open .Rout)                                  \ao
  --------------------------------------------------------
 -* Line                                                \l
 -* Line (and down)                                     \d
  . Line (and new one)                                  \q
  . Left part of line (cur)                       \r<Left>
  . Right part of line (cur)                     \r<Right>
  . Line (evaluate and insert the output as comment)    \o
  . All lines above the current one                    \su
  --------------------------------------------------------
 -* Paragraph                                          \pp
  . Paragraph (echo)                                   \pe
 -* Paragraph (and down)                               \pd
  . Paragraph (echo and down)                          \pa
  --------------------------------------------------------
  . Block (cur)                                        \bb
  . Block (cur, echo)                                  \be
  . Block (cur, down)                                  \bd
  . Block (cur, echo and down)                         \ba
  --------------------------------------------------------
  . Chunk (cur)                                        \cc
  . Chunk (cur, echo)                                  \ce
  . Chunk (cur, down)                                  \cd
  . Chunk (cur, echo and down)                         \ca
  . Chunk (from first to here)                         \ch
  --------------------------------------------------------
  . Function (cur)                                     \ff
  . Function (cur, echo)                               \fe
  . Function (cur and down)                            \fd
  . Function (cur, echo and down)                      \fa
  --------------------------------------------------------
 -* Selection                                          \ss
 -* Selection (echo)                                   \se
  . Selection (and down)                               \sd
  . Selection (echo and down)                          \sa
  . Selection (evaluate and insert output in new tab)  \so
  --------------------------------------------------------
  . Send motion region                                 \m{motion}
-----------------------------------------------------------
Command
  . List space                                         \rl
 -* Clear console                                      \rr
 -* Remove objects and clear console                   \rm
    --------------------------------------------------------
 -* Print (cur)                                        \rp
 -* Names (cur)                                        \rn
  . Structure (cur)                                    \rt
  . View data.frame (cur) in new tab                   \rv
  . View data.frame (cur) in horizontal split          \vs
  . View data.frame (cur) in vertical split            \vv
  . View head(data.frame) (cur) in horizontal split    \vh
  . Run dput(cur) and show output in new tab           \td
  . Run print(cur) and show output in new tab          \tp
```

### MISCELLANEOUS

```
u        -   Undo
U        -   Undo all changes on current line
<C-R>    -   Redo
.        -   Redo last change

:e!      -   Reload current file and discard all changes

g~$      -   Toggle case of all characters to end of line.
g~~      -   Toggle case of the current line (same as V~).
gUiw     -   Uppercase the word
gUU      -   switch the current line to upper case
guu      -   switch the current line to lower case

gv       -   Re-select previous selected area
gx       -   Open URL under cursor with browser

<C-a>    -   Increment the number at cursor

(Visual) g<C-a>  -   Add [count] to the number or alphabetic character in
                     the highlighted text.

# how-to-generate-a-number-sequence
# https://stackoverflow.com/a/48408001
-> <C-v>     -  blockwise select the first character.
-> (Use j to go down N lines)
-> I         -  Insert 0. <Esc> to exit insert mode.
-> gv        -  to re-select the previously selected area.
-> g<C-a>  -  to create a sequence
-> (Use 2g<C-a> to use a step count of 2.)


  <C-g>  -   Show line info
g <C-g>  -   Show statistics (word count, ...)
1 <C-g>  -   View the full path of the file

:%sort   -   Sort in visual mode.
             :%sort!  to sort in reverse order;
             :%sort n for numeric sort.

vim +10 {file}           -   Opens the file at line 10
vim +/str {file}         -   Opens the {file} on the first occurence of "str"

:set nonumber            -   Disable line number
:set norelativenumber    -   Disable relative line number

:version                 -   Check vim version
:echo v:version          -   Print version in 3-digit number

:cd %:p:h                -   Change directory to the currently open file.

:so[ource] {file}        -   Read Ex commands from {file}. These are commands that
                             start with a ":".
:so $MYVIMRC             -   Reloaad ~/.vimrc without restarting vim

:verbose map <key>       -   Check key mappings
```

Command line

```
vim +line_number {file}   -   Edit file and go to line number
vim -c "command" -c q    -   Execute vim commands from shell
vim scp://hostname:22/~/automation/test-file.txt - Edit a remote file via scp
```

---

### TEXT OBJECTS

https://blog.carbonfive.com/2011/10/17/vim-text-objects-the-definitive-guide/

Plaintext Text - Words

- `iw` inner word
- `as` around sentence

Plaintext Text - Paragraphs

- `ip` inner paragraph

Quoted Strings

- `a"` -- a double quoted string
- `i"` -- inner double quoted string
- `a'` -- a single quoted string
- `i'` -- inner single quoted string
- `at` -- a html tag
- `it` -- inner html tag
- `a>` -- a single tag
- `i>` -- inner single tag

Parentheses Text Objects

- `i)` -- inner parenthesized block
- `i]` -- inner bracket
- `i}` -- inner brace block
- <code>a\`</code> -- a back quoted string
- <code>i\`</code> -- inner back quoted string

> [CamelCaseMotion](https://github.com/bkad/CamelCaseMotion) provides a text object to move by words within a camel or snake-cased word.

### Code editing

- `<leader>pp`           - toggle paste mode
- `:set syntax=python`   - change syntax highlighting
- `gq{motion}`           - break lines based on line width
- `gqq`                  - format the current line
- `{n}g_`                  - go to the end of the n-1 line

You can manually autoindent, retab or remove trailing whitespace with the following commands respectively.

```
gg=G
:retab
:RemoveTrailingSpaces
```

### Advanced Editing

http://vim.wikia.com/wiki/Moving_around

- `df␣` cuts to first non-whitespace character
- replace a word with yanked text: `yiw` in "first" then `viwp` on "second"

### Special Variables

https://vim.fandom.com/wiki/Get_the_name_of_the_current_file

- `:echo @%` relative path of current file (relative to the working directory)
- `:echo expand('%:t')` name of current file
- `:echo expand('%:p')` full path of current file ('p' for path)
- `:echo expand('%:p:h')` directory containing current file ('h' for head)
- `:echo expand('%:r')` name of file less one extension ('r' for root)
- `:echo expand('%:e')` name of file's extension ('extension')

### Vim paste in command mode - `Ctrl-r`

http://vimdoc.sourceforge.net/htmldoc/insert.html#i_CTRL-R

Use `<C-r> register` when entering a command in _command mode_ or _insert mode_ to paste the register contents. Substitute for a register name:

- `<C-r> "` for last yanked or deleted
- `<C-r> 0` for yanked register
- `<C-r> .` for last inserted text
- `<C-r> %` for current filename
- `<C-r> /` for last search term
- `<C-r> +` for the `X clipboard` or a host of other substitutions

---

## My Custom Shorcut Keys

```
:W          - Force write with sudo
<F5>        - Remove trailing white space
<leader>p   - Paste yanked register
```

---

## References

- [Today I learned: Vim](http://tilvim.com/)
- [VIM KEYBOARD SHORTCUTS](https://gist.github.com/leoluyi/2770d1d8596bb9cf594432dfa56ef825)
- [buffers vs tabs?](https://stackoverflow.com/a/26710166/3744499)
- [vim--buffers-and-windows](https://www.openfoundry.org/tw/tech-column/2383-vim--buffers-and-windows)
- [Huckleberry Vim](https://github.com/shawncplus/vim-classes/blob/master/expert-1.md)
- [vimrc](https://github.com/amix/vimrc)
- [most-used vim commands/keypresses](https://stackoverflow.com/a/5400978)
- [How to save as a new file and keep working on the original one in Vim?](https://stackoverflow.com/a/9927057/3744499)
- [Vim registers: The basics and beyond](https://www.brianstorti.com/vim-registers/)
- [skwp/dotfiles#vim](https://github.com/skwp/dotfiles#vim---whats-included)
- [vim help](https://www.cs.swarthmore.edu/oldhelp/vim/)
- [vim-buffer](https://harttle.land/2015/11/17/vim-buffer.html)
- [vim-window](https://harttle.land/2015/11/14/vim-window.html)
- [Vim Cheat Sheet](https://vim.rtorr.com/)
- [awesome practice and study log](https://github.com/oldratlee/vim-practice)

**Videos**

- [Vim Basics in 8 Minutes](https://www.youtube.com/watch?v=ggSyF1SVFr4)
- [A Vid in which Vim Saves Me Hours & Hundreds of Clicks](https://www.youtube.com/watch?v=hraHAZ1-RaM)
