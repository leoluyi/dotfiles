-- < https://github.com/frans-johansson/lazy-nvim-starter/blob/main/.config/nvim/lua/helpers/colorscheme.lua >

local M = {}

-- Fetch and setup colorscheme if available, otherwise just return 'default'
-- This should prevent Neovim from complaining about missing colorschemes on first boot
M.get_if_available = function(name, opts)
  local lua_ok, colorscheme = pcall(require, name)
  if lua_ok then
    colorscheme.setup(opts)
    return name
  end

  local vim_ok, _ = pcall(vim.cmd.colorscheme, name)
  if vim_ok then
    return name
  end

  -- Set fallback colorscheme if some other else is not set.
  vim.o.termguicolors = false
  return "default"
end

return M
