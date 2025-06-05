return {

  -- < https://github.com/zbirenbaum/copilot.lua >
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    enabled = false,
    cmd = "Copilot",
    build = ":Copilot auth",
    keys = {
      -- Open the copilot panel
      { "<leader>cp", "<cmd>Copilot panel<cr>", desc = "Open copilot panel" },
      -- Open the copilot panel in insert mode
      { "<C-]>", "<cmd>Copilot panel <cr>", mode = "i", desc = "Open copilot panel" },
    },
    opts = {
      -- It is recommended to disable copilot.lua's suggestion and panel modules,
      -- if you use copilot-cmp to show suggestions.
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-l>",
          accept_word = false,
          accept_line = false,
          next = "<C-j>",
          prev = "<C-k>",
          dismiss = "<esc>",
        },
      },
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<cr>",
          refresh = "gr",
          -- open = "<C-]>",
        },
        layout = {
          position = "right", -- | top | left | right
          ratio = 0.4,
        },
      },
      filetypes = {
        yaml = true,
        markdown = true,
        help = false,
        sh = function()
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
            -- disable for .env files
            return false
          end
          return true
        end,
      },
    },
    config = function(_, opts)
      require("copilot").setup(opts)
      -- highlight CopilotSuggestion
      vim.cmd([[highlight CopilotSuggestion guibg=#555555 ctermbg=8]])

      -- Disable copilot for certain filetypes.
      -- < https://github.com/zbirenbaum/copilot.lua/issues/74#issuecomment-1443751721 >
      local augroup = vim.api.nvim_create_augroup("copilot-disable-patterns", { clear = true })
      for _, pattern in ipairs({ "jdt://*" }) do
        vim.api.nvim_create_autocmd("LspAttach", {
          group = augroup,
          pattern = pattern,
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client.name == "copilot" then
              vim.defer_fn(function()
                vim.cmd("silent Copilot detach")
              end, 0)
            end
          end,
        })
      end
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      local util_ok, Util = pcall(require, "helpers.util")
      if not util_ok then
        return
      end
      local colors = {
        [""] = Util.fg("DiagnosticInfo"),
        ["Normal"] = Util.fg("DiagnosticOk"),
        ["Warning"] = Util.fg("DiagnosticError"),
        ["InProgress"] = Util.fg("DiagnosticWarn"),
      }

      -- if opts has to key "sections", create it without copying the original table
      if not opts.sections then
        opts.sections = { lualine_x = {} }
      end

      table.insert(opts.sections.lualine_x, 2, {
        function()
          local icon = require("helpers.icons").kinds.Copilot
          local status = require("copilot.api").status.data
          return icon .. (status.message or "")
        end,
        cond = function()
          local ok, clients = pcall(vim.lsp.get_active_clients, { name = "copilot", bufnr = 0 })
          return ok and #clients > 0
        end,
        color = function()
          if not package.loaded["copilot"] then
            return
          end
          local status = require("copilot.api").status.data
          return colors[status.status] or colors[""]
        end,
      })
    end,
  },
}
