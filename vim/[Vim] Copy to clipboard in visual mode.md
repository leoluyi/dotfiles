# [Vim] Selecting in visual mode to paste outside vim window

http://stackoverflow.com/questions/3961859/how-to-copy-to-clipboard-in-vim
http://stackoverflow.com/questions/7747846/selecting-in-visual-mode-to-paste-outside-vim-window

You could yank the text into the + (plus) register, that is mapped to the system clipboard. Just select the text in the mode you like and then type

The * register will do this. In Windows, + and * are equivalent. In unix there is a subtle difference between + and *:

Under Windows, the * and + registers are equivalent. For X11 systems, though, they differ. For X11 systems, * is the selection, and + is the cut buffer (like clipboard). http://vim.wikia.com/wiki/Accessing_the_system_clipboard

```
"+y
```

Likewise you can paste from "+ to get text from the system clipboard (i.e. "+p instead of p).



