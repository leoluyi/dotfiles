# tmux cheatsheet

- [Oh My Tmux](https://github.com/gpakosz/.tmux)
- [cheat sheet](https://gist.github.com/henrik/1967800)
- [tmux command cheat sheet](https://gist.github.com/leoluyi/484f70a9f46040355452e9c40f9109b4)

## Basic Commands

- `tmux` start new
- `tmux ls` list sessions
- `tmux new -s <session-name>` start new with session name
- `tmux a -t <target-session>` attach to named session
- `tmux a  #` attach to session number
- `tmux kill-session -t <target-session>` kill session
- `tmux kill-session -a` close all other sessions
- `tmux kill-server` or `<C-a> k` kill all tmux windows and sessions

## Key bindings

- `<prefix>` means you have to either hit `Ctrl + a` or `Ctrl + b`
- `<prefix> c` means you have to hit `Ctrl + a` or `Ctrl + b` followed by `c`
- `<prefix> C-c` means you have to hit `Ctrl + a` or `Ctrl + b` followed by `Ctrl + c`

## Oh My Tmux Features

- `C-a` acts as secondary prefix, while keeping default `C-b` prefix
- `<prefix> Enter` enters copy-mode; `<esc>` exits copy-mode

**With prefix: `C-a`**

```
+         maximize any pane to a new window
m         toggle mouse mode
e         opens ~/.tmux.conf.local with the editor
r         reloads the configuration
C-l       clears both the screen and the tmux history

C-c       creates a new session
C-f       lets you switch to another session by name

C-h, C-l  navigate windows (default n and p are unbound)
<Tab>     brings you to the last active window

-             splits the current pane vertically
_             splits the current pane horizontally
h, j, k, l    navigate panes ala Vim
H, J, K, L    resize panes
< , >         swap panes
+             maximizes the current pane to a new window

m             toggles mouse mode on or off

U             launches Urlview (if available)
F             launches Facebook PathPicker (if available)

b             lists the paste-buffers
p             pastes from the top paste-buffer
P             lets you choose the paste-buffer to paste from
```

## Shorcut keys

**With prefix `C-a`**:

### Sessions

```
<C-c>  Create new session (or :new<CR>)
s      list sessions and choose
$      Rename the current session 
L      'Last' (previously used) session

d      Detach the current client.
D      Choose a client to detach.

(      Switch the attached client to the previous session.
)      Switch the attached client to the next session.
```

### Windows (tabs)

```
c       Create a new window
,       Rename the current window
w       list windows and choose
&       kill window

n, p    Change to the next/previous window.
l       Last selected window
'       Prompt for a window index to select
0       to 9 Select windows 0 to 9
f       find window

.       move window - prompted for a new number
i       Display some information about the current window.
```

**With command mode `<prefix> :`

- `swap-window -s 3 -t 1` swap (move) window number 3 and window 1. `swap-window -t 0` swap the current window with the top window

### Panes

```
%          horizontal split pane (left and right)
"          vertical split pane (top and bottom)
x          kill pane (or just type `exit` or ctrl+d)

← → ↑ ↓    go to the next pane on the left, right, ...
o          swap panes
;          go to the 'last' (previously active) pane
q          show pane indexes
⍽          space - toggle between layouts

C-o        Rotate the panes in the current window forwards
{          Swap the current pane with the previous pane.
}          Swap the current pane with the next pane.

z          Toggle zoom state of the current pane.
!          Break the current pane out of the window
```


### Window/pane surgery

```
:joinp -s :2<CR>  move window 2 into a new pane in the current window
:joinp -t :1<CR>  move the current pane into a new pane in window 1
```

* [Move window to pane](http://unix.stackexchange.com/questions/14300/tmux-move-window-to-pane)
* [How to reorder windows](http://superuser.com/questions/343572/tmux-how-do-i-reorder-my-windows)

### Misc

```
t  big clock
?  list shortcuts
:  prompt
```
