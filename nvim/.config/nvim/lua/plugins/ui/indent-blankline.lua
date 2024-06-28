-- < https://github.com/lukas-reineke/indent-blankline.nvim >

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = true,
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = function ()
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }

      local hooks = require "ibl.hooks"

      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
        vim.api.nvim_set_hl(0, "IndentBlanklineSpaceChar", { fg = "#EC5F66", nocombine = true })
        vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "#f0f0f0", nocombine = true })
        vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "#00FF00", nocombine = true })
      end)

      return {
        indent = {
          char = '│',
          tab_char = "│",
        },
        scope = {
          enabled = false,
          -- show_start = false,
          -- show_end = false,
          -- highlight = { "Function", "Label" },
          -- injected_languages = true,
          -- include = {
          --   node_type = { ["*"] = { "*" } },
          -- },
        },
        whitespace = {
          highlight = { "IndentBlanklineSpaceChar" },
          remove_blankline_trail = true,
        },
        exclude = {
          filetypes = {
            "",
            "alpha",
            "checkhealth",
            "dashboard",
            "help",
            "lazy",
            "lspinfo",
            "man",
            "mason",
            "neo-tree",
            "oil",
            "startify",
            "Trouble",
          },
          buftypes = {
            'terminal',
            'nofile',
            'packer',
            "help",
          },
        }
      }
    end,
    config = function(_, opts)
      require("ibl").setup(opts)

      -- FIX: Incremental substitution preview
      -- < https://github.com/lukas-reineke/indent-blankline.nvim/issues/434#issuecomment-1153349059 >
      local augroup = vim.api.nvim_create_augroup("IndentBlanklineCmdline", {})
      vim.api.nvim_clear_autocmds({ group = augroup })
      vim.api.nvim_create_autocmd("CmdlineEnter", {
        group = augroup,
        command = "silent! IBLDisable",
      })
      vim.api.nvim_create_autocmd("CmdlineLeave", {
        group = augroup,
        command = "silent! IBLlineEnable",
      })

    end
  }
}
