-- vim: fdm=marker:fdl=2
-- < https://github.com/folke/lazy.nvim >

-- Install.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local ok, _ = pcall(require, "lazy")
if not ok then
  return
end

vim.api.nvim_set_keymap("n", "<leader>cl", "<cmd>Lazy<cr>", {})

-- Load plugins from specifications.
-- (The leader key must be set before this)
require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.coding" },
    { import = "plugins.editor" },
    { import = "plugins.lsp" },
    { import = "plugins.ui" },
    { import = "plugins.util" },

    -- === Optional plugins. (Must place this at the end of spec) ===

    { import = "plugins.extras.dap" },
    { import = "plugins.extras.note" },
    { import = "plugins.extras.coding" },

    { import = "plugins.extras.lang.docker" },
    { import = "plugins.extras.lang.go" },
    { import = "plugins.extras.lang.makefile" },
    { import = "plugins.extras.lang.markdown" },
    { import = "plugins.extras.lang.python" },
    { import = "plugins.extras.lang.java" },

    { import = "plugins.extras.ai.avante" },
    -- { import = "plugins.extras.ai.copilot" },
    -- { import = "plugins.extras.ai.chatgpt" },
    -- { import = "plugins.extras.ai.codeium" },
    -- { import = "plugins.extras.ai.copilotchat" },
  },
  defaults = {
    -- lazy = false,
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = {
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "habamax" }
  },
  checker = { enabled = false }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- vim.api.nvim_echo({
--   {
--     "Do not use this repository directly\n",
--     "ErrorMsg",
--   },
--   {
--     "Please check the docs on how to get started with LazyVim\n",
--     "WarningMsg",
--   },
--   { "Press any key to exit", "MoreMsg" },
-- }, true, {})
