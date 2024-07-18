return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    defaults = {},
    spec = {
      { "[", group = "prev" },
      { "]", group = "next" },
      { "g", group = "goto" },
      { "z", group = "fold" },
    }
  },

  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Keymaps (which-key)",
    },
    {
      "<c-w><space>",
      function()
        require("which-key").show({ keys = "<c-w>", loop = true })
      end,
      desc = "Window Hydra Mode (which-key)",
    },
  },

  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    wk.add({
      mode = { "n", "x" },
      { "<leader>0", hidden = true },
      { "<leader>1", hidden = true },
      { "<leader>2", hidden = true },
      { "<leader>3", hidden = true },
      { "<leader>4", hidden = true },
      { "<leader>5", hidden = true },
      { "<leader>6", hidden = true },
      { "<leader>7", hidden = true },
      { "<leader>8", hidden = true },
      { "<leader>9", hidden = true },

      { "<leader>K", group = "Cheat" },
      { "<leader>b", group = "Buffer" },
      { "<leader>c", group = "Code|+Config" },
      { "<leader>d", group = "Dap|+Diagnostics" },
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>gc", group = "Lspsaga [C]all trace" },
      { "<leader>gd", group = "Diffview" },
      { "<leader>gh", group = "Hunk" },
      { "<leader>l", group = "Lsp" },
      { "<leader>lc", group = "Lspsaga [C]all" },
      { "<leader>q", group = "Quit" },
      { "<leader>r", group = "Resize|+Rotate" },
      { "<leader>s", group = "Search" },
      { "<leader>sl", group = "Lsp" },
      { "<leader>t", group = "Terminal|Neotest" },
      { "<leader>u", group = "Toggle" },
      { "<leader>v", group = "VenvSelect" },
      { "<leader>w", group = "Workspace" },
      { "<leader>x", group = "TroubleToggle" },
      { "<leader>y", group = "Yank" },
    })

    wk.add({
      { "<localleader><C-a>", desc = "[A]dd backward" },
      { "<localleader><C-x>", desc = "Sub[X]ract backward" },
    })

    wk.add({
      { "<localleader>c", group = "Code" },
      { "<localleader>g", group = "Git" },
      { "<localleader>r", group = "Refactor" },
    })

  end
}
