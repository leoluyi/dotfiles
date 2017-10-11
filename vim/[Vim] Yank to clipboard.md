# [Vim] Accessing the system clipboard

http://vim.wikia.com/wiki/Accessing_the_system_clipboard
http://stackoverflow.com/questions/31349933/how-do-you-yank-to-your-local-clipboard-in-vim-running-on-a-remote-ssh-session

When performing copy, cut, and paste with commands like y, d, and p, by default Vim uses its own location for this, called the *unnamed register* (:help quotequote). Note that this is different from what most modern graphical text editors and other applications like web browsers do; these applications interact with the system clipboard when using keybindings like CTRL-C, CTRL-X, and CTRL-V. Fortunately, in most cases it is easy to get Vim to work with the system clipboard.

Vim offers the + and * registers to reference the system clipboard (:help quoteplus and :help quotestar). Note that on some systems, + and * are the same, while on others they are different. Generally on Linux, + and * are different: + corresponds to the desktop clipboard (XA_SECONDARY) that is accessed using CTRL-C, CTRL-X, and CTRL-V, while * corresponds to the X11 primary selection (XA_PRIMARY), which stores the mouse selection and is pasted using the middle mouse button in most applications. We can use these registers like any other register. Here are a few common commands that demonstrate this:

`gg"+yG` – copy the entire buffer into `+` (normal mode)
`"*dd` – cut the current line into `*` (normal mode)
`"+p` – paste from `+` after the cursor (works in both normal and visual modes)
`:%y *` – copy the entire buffer into `*` (this one is an ex command)

## Checking for X11-clipboard support in terminal

```
vim --version | grep clipboard
```

## Linux

```
$ sudo apt install vim-gnome
```

