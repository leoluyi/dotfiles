return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    defaults = {},
    spec = {
      { "[", group = "prev" },
      { "]", group = "next" },
      { "g", group = "goto" },
      { "gc", group = "Comment" },
      { "gb", group = "Comment (block)" },
      { "z", group = "fold" },
    },
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

      { "<leader>a", group = "AI" },
      { "<leader>b", group = "Buffer" },
      { "<leader>c", group = "Code|+Config" },
      { "<leader>d", group = "Dap|+Diagnostics" },
      { "<leader>f", group = "Find Files..." },
      { "<leader>g", group = "Git" },
      { "<leader>h", group = "Hunk" },
      { "<leader>k", group = "Neotree" },
      { "<leader>K", group = "Cheat" },
      { "<leader>l", group = "Lsp" },
      { "<leader>lc", group = "Lspsaga [C]all" },
      { "<leader>lw", group = "Lsp [W]orkspace" },
      { "<leader>q", group = "Quit" },
      { "<leader>r", group = "Resize|+Rotate" },
      { "<leader>s", group = "Search..." },
      { "<leader>sl", group = "Search Lsp" },
      { "<leader>t", group = "Terminal|Neotest" },
      { "<leader>u", group = "Toggle" },
      { "<leader>v", group = "VenvSelect" },
      { "<leader>w", group = "Window" },
      { "<leader>x", group = "TroubleToggle" },
      { "<leader>y", group = "Yank" },
      { "<leader>z", group = "Zoom" },
    })

    wk.add({
      { "<localleader><C-a>", desc = "[A]dd backward" },
      { "<localleader><C-x>", desc = "Sub[X]ract backward" },
    })

    wk.add({
      { "<localleader>c", group = "Code" },
      { "<localleader>r", group = "Refactor" },
    })
  end,
}
