## VimR
https://github.com/vsbuffalo/devnotes/wiki/Vim,-R,-and-Tmux:-Minimal-Configuration

Requires:

- MacVim/Vim (installed via Homebrew)
- R (installed via Homebrew)
- tmux (installed via Homebrew)
- Vim-R-plugin (installed via Vundle - see below)

~/.vimrc
```
Plugin 'vim-scripts/Vim-R-plugin'
Plugin 'ervandew/screen'
```

run :PluginInstall

(It's easier to edit .vimrc with :e $MYVIMRC (but tab completion after $MY works) and load with :so $MYVIMRC.)
Then, add the following to your ~/.vimrc:

```
" R script settings
let maplocalleader = ","
vmap <Space> <Plug>RDSendSelection
nmap <Space> <Plug>RDSendLine
let vimrplugin_applescript=0
let vimrplugin_vsplit=1
" 取消_鍵輸入 <-
let vimrplugin_assign = 0
```

----------------------------------------

### R packages

$ git clone https://github.com/jalvesaq/colorout.git
$ R CMD INSTALL colorout

if(interactive()){
    library(colorout)
    library(setwidth)
    options(vimcom.verbose = 1) # optional
    library(vimcom)
}

