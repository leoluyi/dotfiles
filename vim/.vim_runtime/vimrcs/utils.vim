"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Utilities for vimrc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" https://gist.github.com/thinca/1518874

" == Naming convention. ==
" Command name
"  - CamelCase
" Global function name
"  - CamelCase
" Local function name
"  - s:split_by_underbar
" Group name for autocmd
"  - split-by-dash
"   In vimrc, start with "vimrc"
"    - vimrc-{unique-name}
"   In vim plugin, start with "plugin"
"    - plugin-{plugin-name}
"    - plugin-{plugin-name}-{unique-name}
"   In other custom files, start with "custom"
"    - custom-{unique-name}

function! Has_plugin(name)
  return globpath(&runtimepath, 'plugin/' . a:name . '.vim') !=# ''
        \   || globpath(&runtimepath, 'autoload/' . a:name . '.vim') !=# ''
        \   || globpath(&runtimepath, 'plugged/' . a:name) !=# ''
        \   || globpath(&runtimepath, 'my_plugins/' . a:name) !=# ''
        \   || globpath(&runtimepath, 'sources_forked/' . a:name) !=# ''
        \   || globpath(&runtimepath, 'sources_non_forked/' . a:name) !=# ''
endfunction

function! Plug_loaded(name)
  " https://vi.stackexchange.com/a/14143
  " for vim-plug
  return has_key(g:plugs, a:name)
        \   && isdirectory(g:plugs[a:name].dir)
  " \   && stridx(&runtimepath, g:plugs[a:name].dir) >= 0
endfunction
