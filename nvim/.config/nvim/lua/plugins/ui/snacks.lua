return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      dashboard = { enabled = true },
      notifier = { enabled = true },
      indent = { enabled = true },
      scope = { enabled = true },
      words = { enabled = true },
      bigfile = { enabled = true },
      bufdelete = { enabled = true },
      dim = { enabled = true },
      input = { enabled = true },
      lazygit = { enabled = true },
      scroll = { enabled = true },
      terminal = { enabled = true },
      zen = { enabled = true },
      picker = {
        enabled = true,
        layout = {
          preset = "default",
          layout = { width = 0.8 },
        },
      },
    },
    init = function()
      -- Disable mini.trailspace on dashboard; must use SnacksDashboardOpened
      -- because FileType fires before buffer options are fully applied
      vim.api.nvim_create_autocmd("User", {
        pattern = "SnacksDashboardOpened",
        callback = function(args)
          vim.b[args.buf].minitrailspace_disable = true
          MiniTrailspace.unhighlight()
        end,
      })
    end,
    keys = {
      { "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal" },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>uZ", function() Snacks.zen() end, desc = "Zen Mode" },
      { "<leader>uD", function() Snacks.dim() end, desc = "Toggle Dim" },
      { "<leader>un", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      -- Picker: files
      { "<c-p>", function() Snacks.picker.smart() end, desc = "Find Files (smart)" },
      { "<leader>ff", function() Snacks.picker.files({ hidden = true, ignored = true }) end, desc = "Find Files (all)" },
      { "<leader>fF", function() Snacks.picker.files() end, desc = "Find Files (cwd)" },
      { "<leader>fm", function() Snacks.picker.recent() end, desc = "Recent Files" },
      { "<leader>m", function() Snacks.picker.recent({ filter = { cwd = true } }) end, desc = "Recent (root dir)" },
      { "<leader>cc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Neovim Config Files" },
      { "<leader>sn", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Neovim Config Files" },
      { "<leader>sb", function() Snacks.picker.files({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Search Buffer Dir" },
      -- Picker: buffers (vertical, compact)
      { "<leader><space>", function() Snacks.picker.buffers({ layout = { preset = "vertical", layout = { width = 0.6, height = 0.55 } } }) end, desc = "Find Buffers" },
      { "<leader>fb", function() Snacks.picker.buffers({ layout = { preset = "vertical", layout = { width = 0.6, height = 0.55 } } }) end, desc = "Find Buffers" },
      -- Picker: grep (vertical, tall — use "-- -g *.lua" for glob filters)
      { "<leader>sg", function() Snacks.picker.grep({ layout = { preset = "vertical", layout = { height = 0.95 } } }) end, desc = "Grep" },
      { "<leader>sG", function() Snacks.picker.grep({ layout = { preset = "vertical", layout = { height = 0.95 } }, hidden = true }) end, desc = "Grep (hidden)" },
      { "<leader>sw", function() Snacks.picker.grep_word({ layout = { preset = "vertical", layout = { height = 0.95 } } }) end, desc = "Search Word", mode = { "n", "x" } },
      { "<leader>/", function() Snacks.picker.lines({ layout = { preset = "vscode" } }) end, desc = "Fuzzy Search Buffer" },
      -- Picker: vim
      { "<leader>sc", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Tags" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sr", function() Snacks.picker.registers() end, desc = "Registers" },
      { "<leader>so", function() Snacks.picker.resume() end, desc = "Resume" },
      -- Picker: LSP/diagnostics
      { "<leader>se", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>sld", function() Snacks.picker.lsp_definitions() end, desc = "LSP Definitions" },
      { "<leader>slr", function() Snacks.picker.lsp_references() end, desc = "LSP References" },
      -- Picker: git
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    },
  },
}
