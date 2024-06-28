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

" Check if a plugin is plugged in plug section or not
" < https://vi.stackexchange.com/a/14143 >
" < https://github.com/wbthomason/packer.nvim/issues/167#issue-787437860 >
" < https://github.com/wbthomason/packer.nvim/pull/171 >

if has("nvim-0.5")
lua <<EOF
function _G.is_plugged(name)
  -- local status_ok, _ = pcall(require, name:gsub('%.nvim$', ''))
  -- print(name:gsub('%.nvim$', ''), status_ok)
  -- return status_ok
  return (packer_plugins ~= nil and packer_plugins[name] and packer_plugins[name].loaded)
end

function _G.is_loaded(name)
  -- for lazy.nvim
  local loaded_eval

  if string.match(name, "vim-") then
    loaded_eval = "return vim.g.loaded_" .. (string.gsub(string.gsub(name, "[.-]", "_"), "^vim_", "") or "")
  else
    loaded_eval = "return vim.g.loaded_" .. (string.gsub(name, "[.-]", "_") or "") .. "_plugin" .. " or " ..
    ("vim.g.loaded_" .. (string.gsub(string.gsub(name, "[.-]", "_"), "_vim", "") or "") .. "_plugin")
  end

  -- print(loaded_eval)
  local loaded = loadstring(loaded_eval)()
  -- print(loaded)
  return loaded
end
EOF

endif

function! IsPlugged(name) abort
  if has("nvim")
    " Packer.
    " echom a:name .. ': ' .. v:lua.is_plugged(a:name)
    " return v:lua.is_plugged(a:name)

    " lazy.nvim.
    " echom a:name .. ': ' .. v:lua.is_loaded(a:name)
    return v:lua.is_loaded(a:name)

  else
    return (
        \ has_key(g:plugs, a:name) &&
        \ isdirectory(g:plugs[a:name].dir) &&
        \ stridx(&runtimepath, trim(g:plugs[a:name].dir, "/")) >= 0
        \ )
  endif
endfunction

" Obsolete functions ------------------------------------

function! Has_plugin(name)
  return globpath(&runtimepath, 'plugin/' . a:name . '.vim') !=# ''
        \   || globpath(&runtimepath, 'autoload/' . a:name . '.vim') !=# ''
        \   || globpath(&runtimepath, 'plugged/' . a:name) !=# ''
        \   || globpath(&runtimepath, 'my_plugins/' . a:name) !=# ''
        \   || globpath(&runtimepath, 'sources_forked/' . a:name) !=# ''
        \   || globpath(&runtimepath, 'sources_non_forked/' . a:name) !=# ''
endfunction
