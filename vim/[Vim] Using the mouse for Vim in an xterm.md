# [Vim] Using the mouse for Vim in an xterm
http://vim.wikia.com/wiki/Using_the_mouse_for_Vim_in_an_xterm

If, like me, you don't want to use the GUI vim because you work in an xterm most of the time anyway, you may be annoyed at the shortcomings this presents. For example, during my webbrowsing, I'll often fire up vim in one of the already lying around xterms to conveniently write a long text (such as this one), and then paste from vim into a textfield on a HTML form in the browser.

The first problem is caused by line numbering, which I keep enabled at all times.

```
:set number
```

Normally, if you try to copy text out of the xterm that vim is running in, you'll get the text as well as the numbers. The GUI version gets this right: it only selects the text, keeping the line numbers out of the picture. But I don't want the GUI version. So instead, I added this to my vimrc:

```
:set mouse=a
```

Much better. You can also selectively enable mouse support for specific modes only by using something other than 'a' (for 'all').

