-- vim: set foldmethod=marker foldlevel=2:

local root_util = require("helpers.root")

-- https://github.com/ThePrimeagen/init.lua/blob/master/after/plugin/telescope.lua
-- https://github.com/whatsthatsmell/dots/blob/master/public%20dots/vim-nvim/lua/joel/telescope/init.lua

-- my telescopic customizations ================================================== {{{2

local M = {}

M.root_patterns = { ".git", "lua" }

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        ---@diagnostic disable-next-line: param-type-mismatch
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/telescope.lua#L20
-- this will return a function that calls telescope.
-- cwd will default to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.builtin(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = root_util.get() }, opts or {})
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    if opts.cwd and opts.cwd ~= vim.loop.cwd() then
      ---@diagnostic disable-next-line: inject-field
      opts.attach_mappings = function(_, map)
        map("i", "<a-c>", function()
          local action_state = require("telescope.actions.state")
          local line = action_state.get_current_line()
          M.telescope(
            params.builtin,
            vim.tbl_deep_extend("force", {}, params.opts or {}, { cwd = false, default_text = line })
          )()
        end)
        return true
      end
    end

    require("telescope.builtin")[builtin](opts)
  end
end

M.buffers = function()
  local opts = {
    prompt_title = '  Buffers', results_title=false, winblend = 10, path_display={ 'truncate' },
    layout_strategy = 'vertical', layout_config = { width = 0.60, height = 0.55 },
    sort_lastused = true,
  }
  require"telescope.builtin".buffers(opts)
end

-- Falling back to find_files if git_files can't find a .git directory
M.project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(require"telescope.builtin".git_files, opts)
  if not ok then require"telescope.builtin".find_files(opts) end
end

M.all_files = function()
  local opts = {
    prompt_title = '  All Files (cwd)', results_title=false, winblend = 10, path_display={ 'truncate' },
    hidden = true,
    no_ignore = true,
    no_ignore_parent = true,
    -- find_command = { 'rg', '--files', '--hidden', '--glob', '!.git' },
  }
  require"telescope.builtin".find_files(opts)
end

M.search_dotfiles = function()
  require("telescope.builtin").find_files({
    prompt_title = "< VimRC >",
    cwd =  "~/.config/nvim/",
    hidden = true,
    follow = true,
  })
end

M.nvim_config = function()
  require("telescope").extensions.file_browser.file_browser {
    prompt_title = "  NVim Config Browse",
    cwd = "~/.config/nvim/",
    path_display = { "smart" },
    initial_mode = "normal",
  }
end

M.file_browser = function()
  require("telescope").extensions.file_browser.file_browser {
    prompt_title = "  File Browser",
    initial_mode = "normal",
  }
end

local function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

M.buffer_dir = function()
  require("telescope").extensions.file_browser.file_browser({
    path = "%:p:h",
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    previewer = true,
    initial_mode = "normal",
    layout_config = { height = 40 }
  })
end

M.git_branches = function()
  local actions = require("telescope.actions")
  require("telescope.builtin").git_branches({
    attach_mappings = function(_, map)
      map("i", "<c-d>", actions.git_delete_branch)
      map("n", "<c-d>", actions.git_delete_branch)
      return true
    end,
  })
end

-- Helper functions ==============================================================={{{2

function vim.getVisualSelection()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg('v')
  vim.fn.setreg('v', {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ''
  end
end

-- Telescope Themes ==============================================================={{{2

-- < https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#themes >

M.finders = {}

-- Dropdown list theme using a builtin theme definitions :
M.finders.center_list = require"telescope.themes".get_dropdown({
  winblend = 10,
  width = 0.55,
  prompt = " ",
  prompt_prefix = "❯ ",
  results_height = 15,
  previewer = false,
})

-- Settings for with preview option
local with_preview = {
  winblend = 10,
  show_line = false,
  results_title = false,
  preview_title = false,
  layout_config = {
    preview_width = 0.5,
  },
}

-- Find in neovim config with center theme
M.finders.fd_in_nvim = function()
  local opts = vim.deepcopy(M.finders.center_list)
  opts.prompt_prefix = "Nvim>"
  opts.cwd = vim.fn.stdpath("config")
  require"telescope.builtin".fd(opts)
end

-- Find files with_preview settings
 M.finders.fd = function()
  local opts = vim.deepcopy(with_preview)
  opts.prompt_prefix = "FD>"
  require"telescope.builtin".fd(opts)
end

return M
