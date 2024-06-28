-- A light-weight lsp plugin based on neovim built-in lsp with highly a performant UI.
-- < https://github.com/nvimdev/lspsaga.nvim >
-- < https://github.com/kkharji/lspsaga.nvim >

return {
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      {"nvim-tree/nvim-web-devicons"},
      {"nvim-treesitter/nvim-treesitter"},
    },
    keys = {
      { "K", "<cmd>Lspsaga hover_doc<cr>", desc="Hover Doc" },
    },
    opts = {
      preview = {
        lines_above = 0,
        lines_below = 10,
      },
      scroll_preview = {
        scroll_down = "<C-f>",
        scroll_up = "<C-b>",
      },
      request_timeout = 2000,
      finder = {
        jump_to = 'p',
        edit = { "o", "<CR>" },
        vsplit = "v",
        split = "s",
        quit = { "q", "<ESC>" },
      },
      definition = {
        edit = "<C-c>o",
        vsplit = "<C-c>v",
        split = "<C-c>i",
        tabe = "<C-c>t",
        quit = "q",
        close = "<Esc>",
      },
      lightbulb = {
        enable = true,
        enable_in_insert = false,
        sign = false,
        sign_priority = 40,
        virtual_text = true,
      },
      diagnostic = {
        show_code_action = true,
        show_source = true,
        jump_num_shortcut = true,
        --1 is max
        max_width = 0.7,
        custom_fix = nil,
        custom_msg = nil,
        text_hl_follow = false,
        border_follow = false,
        keys = {
          exec_action = "o",
          quit = "q",
          go_action = "g"
        },
      },
      rename = {
        quit = "<C-c>",
        exec = "<CR>",
        mark = "x",
        confirm = "<CR>",
        in_select = true,
      },
      outline = {
        win_position = "right",
        win_with = "",
        win_width = 30,
        show_detail = true,
        auto_preview = true,
        auto_refresh = true,
        auto_close = true,
        custom_sort = nil,
        keys = {
          jump = "o",
          expand_collapse = "u",
          quit = "q",
        },
      },
      callhierarchy = {
        show_detail = false,
        keys = {
          edit = "e",
          vsplit = "s",
          split = "i",
          tabe = "t",
          jump = "o",
          quit = "q",
          expand_collapse = "u",
        },
      },
      symbol_in_winbar = {
        enable = true,
        separator = " ",
        hide_keyword = true,
        show_file = true,
        folder_level = 2,
        respect_root = true,
        color_mode = true,
      },
      beacon = {
        enable = true,
        frequency = 7,
      },
      ui = {
        -- Currently, only the round theme exists
        theme = "round",
        -- This option only works in Neovim 0.9
        title = true,
        -- Border type can be single, double, rounded, solid, shadow.
        border = "rounded",
        winblend = 0,
        diagnostic = ' ',
        info = ' ',
        warn = ' ',
        expand = "",
        collapse = "",
        preview = " ",
        code_action = "💡",
        incoming = " ",
        outgoing = " ",
        hover = ' ',
        kind = {},
      },
    },
  },
}
