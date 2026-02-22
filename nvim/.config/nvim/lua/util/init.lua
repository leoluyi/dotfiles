local M = {}

-- < User > ======================================================================={{{2

function M.path_join(...)
  local args = { ... }
  local parts = {}

  for _, part in ipairs(args) do
    if type(part) == "table" then
      for _, p in ipairs(part) do
        table.insert(parts, p)
      end
    else
      table.insert(parts, part)
    end
  end

  return table.concat(parts, "/")
end

function M.map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

function M.dirname(path)
  if not path or #path == 0 then
    return path
  end

  local result = path:gsub("/[^/]+$", ""):gsub("/$", "")

  if #result == 0 then
    return "/"
  end

  return result
end

-- < LazyVim/lua/lazyvim/util/init.lua> ==========================================={{{2
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/init.lua

---@param plugin string
function M.has(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

function M.fg(name)
  ---@type {foreground?:number}?
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name })
  local fg = hl and hl.fg or hl.foreground
  return fg and { fg = string.format("#%06x", fg) }
end

---@return string
function M.norm(path)
  if path:sub(1, 1) == "~" then
    local home = vim.uv.os_homedir()
    if home:sub(-1) == "\\" or home:sub(-1) == "/" then
      home = home:sub(1, -2)
    end
    path = home .. path:sub(2)
  end
  path = path:gsub("\\", "/"):gsub("/+", "/")
  return path:sub(-1) == "/" and path:sub(1, -2) or path
end

function M.is_win()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

-- < https://github.com/nanotee/nvim-lua-guide > =================================={{{2

-- Debug helper: pretty-print values to the command line.
-- Available globally as put(...).
function M.put(...)
  local objects = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, " "))
  return ...
end

_G.put = M.put

---}}}

return M
