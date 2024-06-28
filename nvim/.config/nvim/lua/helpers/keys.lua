-- < https://github.com/frans-johansson/lazy-nvim-starter/blob/main/.config/nvim/lua/helpers/keys.lua >

local M = {}

M.map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

M.lsp_map = function(lhs, rhs, bufnr, desc)
  vim.keymap.set("n", lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
end

M.dap_map = function(mode, lhs, rhs, desc)
  M.map(mode, lhs, rhs, desc)
end

M.set_leader = function(key)
  vim.g.mapleader = key
  vim.g.maplocalleader = key
  M.map({ "n", "v" }, key, "<nop>")
end

M.map_opts = function(mode, lhs, rhs, opts)
  local opts_ = opts or {}
  vim.keymap.set(mode, lhs, rhs, opts_)
end

M.nmap = function(lhs, rhs, opts)
  M.map_opts("n", lhs, rhs, opts)
end

M.noremap = function(mode, lhs, rhs, opts)
  local opts_ = opts or {}
  opts_.noremap = true
  M.map_opts(mode, lhs, rhs, opts_)
end

return M
