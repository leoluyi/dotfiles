return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    defaults = {
      mode = { "n", "v" },
      ["g"] = { name = "+goto" },
      ["]"] = { name = "+next" },
      ["["] = { name = "+prev" },
      ["cs"] = { name = "+surround" },
    },
    plugins = {
      marks = true, -- shows a list of your marks on ' and `
      registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      -- the presets plugin, adds help for a bunch of default keybindings in Neovim
      -- No actual key bindings are created
      spelling = {
        enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
        suggestions = 20, -- how many suggestions should be shown in the list?
      },
      presets = {
        operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
        motions = true, -- adds help for motions
        text_objects = true, -- help for text objects triggered after entering an operator
        windows = true, -- default bindings on <c-w>
        nav = true, -- misc bindings to work with windows
        z = true, -- bindings for folds, spelling and others prefixed with z
        g = true, -- bindings for prefixed with g
      },
    },
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
    triggers = "auto", -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
      -- list of mode / prefixes that should never be hooked by WhichKey
      -- this is mostly relevant for key maps that start with a native binding
      -- most people should not need to change this
      i = { "j", "k", "f", "F", "t", "T" },
      v = { "j", "k", "f", "F", "t", "T" },
    },
  },

  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.register(opts.defaults)

    wk.register({
      ["0"] = "which_key_ignore",
      ["1"] = "which_key_ignore",
      ["2"] = "which_key_ignore",
      ["3"] = "which_key_ignore",
      ["4"] = "which_key_ignore",
      ["5"] = "which_key_ignore",
      ["6"] = "which_key_ignore",
      ["7"] = "which_key_ignore",
      ["8"] = "which_key_ignore",
      ["9"] = "which_key_ignore",

      b   = { name = "+Buffer" },
      c   = { name = "+Code|+Config" },
      d   = { name = "+Dap|+Diagnostics" },
      f   = { name = "+Find" },
      g   = { name = "+Git",
        c = { "+Lspsaga [C]all trace" },
        d = { "+Diffview" },
        h = { "+Hunk" },
      },
      l   = { name = "+Lsp",
        c = "+Lspsaga [C]all",
      },
      q   = { name = "+Quit" },
      r   = { name = "+Resize|+Rotate" },
      s   = { name = "+Search",
        l = { name = "+Lsp" },
      },
      t   = { name = "+Terminal|Neotest" },
      u   = { name = "+Toggle" },
      v   = { name = "+VenvSelect" },
      w   = { name = "+Workspace" },
      x   = { name = "+TroubleToggle" },
      y   = { name = "+Yank" },
      z   = { name = "+Zoom" },
      K   = { name = "+Cheat" },
    }, { prefix = "<leader>", mode = { "n", "x" } })

    wk.register({
      ["<C-a>"] = "[A]dd backward",
      ["<C-x>"] = "Sub[X]ract backward",
    }, { prefix = "<localleader>", mode = "n" })

    wk.register({
      c      = { name = "+Code"},
      r      = { name = "+Refactor"},
      g      = { name = "+Git"},
    }, { prefix = "<localleader>", mode = { "n", "x" } })

  end
}
