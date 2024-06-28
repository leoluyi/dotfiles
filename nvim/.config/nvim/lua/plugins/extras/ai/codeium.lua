return {
  {
    -- < https://github.com/Exafunction/codeium.vim >
    "Exafunction/codeium.vim",
    event = "InsertEnter",
    keys = function ()
      return {
        { "<c-l>", function() return vim.fn["codeium#Accept"]() end, mode = "i", expr = true, desc = "(Codeium) Accept suggestion" },
        { "<c-j>", function() return vim.fn["codeium#CycleCompletions"](1) end, mode = "i", expr = true, desc = "(Codeium) Next suggestion" },
        { "<c-k>", function() return vim.fn["codeium#CycleCompletions"](-1) end, mode = "i", expr = true, desc = "(Codeium) Previous suggestion" },
        { "<c-]>", function() return vim.fn["codeium#Clear"]() end, mode = "i", expr = true, desc = "(Codeium) Insert suggestion" },
        { "<c-i>", function() return vim.fn["codeium#Complete"]() end, mode = "i", expr = true, desc = "(Codeium) Manually trigger suggestion" },
      }
    end,
    opts = {
      enable_chat = true,
    },
    config = function(_, opts)
      require("codeium").setup(opts)
      vim.g.codeium_disable_bindings = 1
    end
  },

  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      local util_ok, Util = pcall(require, "helpers.util")
      if not util_ok then return end
      local colors = {
        [""] = Util.fg("DiagnosticInfo"),
        ["ON"] = Util.fg("DiagnosticOk"),
        ["0"] = Util.fg("DiagnosticWarn"),
        ["OFF"] = Util.fg("DiagnosticError"),
      }

      -- if opts has to key "sections", create it without copying the original table
      if not opts.sections then opts.sections = { lualine_x = {} } end

      table.insert(opts.sections.lualine_x, 2, {
        function()
          local status = vim.fn["codeium#GetStatusString"]()
          return " " .. (status or "")
        end,
        cond = function()
          return package.loaded["plugins.extras.coding.codeium"][1]["_"]["loaded"] ~= nil
        end,
        color = function()
          if not package.loaded["plugins.extras.coding.codeium"][1]["_"]["loaded"] then
            return
          end
          local status = vim.fn["codeium#GetStatusString"]()
          -- trim it
          status = status:gsub("^%s*(.-)%s*$", "%1")
          -- print(".." .. status .. "..")
          return colors[status] or colors[""]
        end,
      })
    end,
  },
}
