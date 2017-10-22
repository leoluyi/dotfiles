# Vim plugin management

- https://github.com/VundleVim/Vundle.vim
- https://github.com/vim-airline/vim-airline
- https://github.com/vim-airline/vim-airline-themes
- http://www.jianshu.com/p/310368097c75

> Vundle is short for Vim bundle and is a Vim plugin manager.

## Set up Vundle:

```
$ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

## Configure Plugins:

Put this at the top of your `.vimrc` to use Vundle. Remove plugins you don't need, they are for illustration purposes.

```vim
set nocompatible              " be improved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
```


## Install Plugins:

- Launch `vim` and run `:PluginInstall` after editing plugin settings in `.vimrc`
- To install from command line: `vim +PluginInstall +qall`

## vim-airline: Lean & mean status/tabline for vim that's light as air.

https://github.com/vim-airline/vim-airline

Put the flollowing lines in ~/.vimrc

```
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
```

To set in `.vimrc`, use `let g:airline_theme='<theme>'`

```
let g:airline_theme="powerlineish" 

"这个是安装字体后 必须设置此项" 
let g:airline_powerline_fonts = 1   

"打开tabline功能,方便查看Buffer和切换，这个功能比较不错"
"我还省去了minibufexpl插件，因为我习惯在1个Tab下用多个buffer"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

"设置切换Buffer快捷键"
nnoremap <C-N> :bn<CR>
nnoremap <C-P> :bp<CR>

" 关闭状态显示空白符号计数,这个对我用处不大"
"let g:airline#extensions#whitespace#enabled = 0
"let g:airline#extensions#whitespace#symbol = '!'
```

