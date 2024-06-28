-- < https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/dap/core.lua >
-- < https://alpha2phi.medium.com/modern-neovim-debugging-and-testing-8deda1da1411 >
-- < https://www.youtube.com/watch?v=ga3Cas7vNCk >

---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
    return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
  end
  return config
end

return {
  -- < https://github.com/mfussenegger/nvim-dap >
  "mfussenegger/nvim-dap",

  dependencies = {

    -- fancy UI for the debugger
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" },
      -- stylua: ignore
      keys = {
        { "<leader>du", function() require("dapui").toggle({ }) end, desc = "(dap) UI" },
        { "<leader>de", function() require("dapui").eval() end, desc = "(dap) Eval", mode = {"n", "v"} },
      },
      opts = {},
      config = function(_, opts)
        -- setup dap config by VsCode launch.json file
        -- require("dap.ext.vscode").load_launchjs()
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup(opts)
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open({})
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close({})
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close({})
        end
      end,
    },

    -- virtual text for the debugger
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },

    -- which key integration
    {
      "folke/which-key.nvim",
      optional = true,
      opts = {
        defaults = {
          ["<leader>d"] = { name = "+debug" },
        },
      },
    },

    -- mason.nvim integration
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = "mason.nvim",
      cmd = { "DapInstall", "DapUninstall" },
      opts = {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
        },
      },
    },
  },

  -- stylua: ignore
  keys = {
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "(dap) Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "(dap) Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "(dap) Continue" },
    { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "(dap) Run with Args" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "(dap) Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "(dap) Go to line (no execute)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "(dap) Step Into" },
    { "<leader>dj", function() require("dap").down() end, desc = "(dap) Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "(dap) Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "(dap) Run Last" },
    { "<leader>do", function() require("dap").step_out() end, desc = "(dap) Step Out" },
    { "<leader>dO", function() require("dap").step_over() end, desc = "(dap) Step Over" },
    { "<leader>dp", function() require("dap").pause() end, desc = "(dap) Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "(dap) Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "(dap) Session" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "(dap) Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "(dap) Widgets" },
  },

  config = function()
    local icons = require("helpers.icons")
    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

    for name, sign in pairs(icons.dap) do
      sign = type(sign) == "table" and sign or { sign }
      vim.fn.sign_define(
        "Dap" .. name,
        { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
      )
    end
  end,
}
