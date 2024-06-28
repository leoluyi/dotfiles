-- < https://github.com/akinsho/toggleterm.nvim >

local _float_opts = {
  -- The border key is *almost* the same as 'nvim_open_win'
  -- see :h nvim_open_win for details on borders however
  -- the 'curved' border is a custom border type
  -- not natively supported but implemented in this plugin.
  border = "curved",
  winblend = 0,
  highlights = {
    border = "Normal",
    background = "Normal",
  },
}

return {
  {
    "akinsho/toggleterm.nvim",
    event = "BufEnter",
    cmd = {
      "ToggleTerm",
      "ToggleTermSendVisualSelection",
      "ToggleTermSendCurrentLine",
    },
    keys = {
      { "<c-\\", ":ToggleTerm<cr>", desc = "ToggleTerm" },
      { "<leader>tr", ":ToggleTermSendVisualSelection", mode = "x", desc = "Term send visual selection" },
      { "<leader>tr", ":ToggleTermSendCurrentLine", mode = "n", desc = "Term send current line" },
    },
    opts = {
      -- size can be a number or function which is passed the current terminal
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        elseif term.direction == "float" then
          return 20
        end
      end,
      open_mapping = [[<c-\>]],  -- default toogleterm key mapping.
      hide_numbers = true, -- hide the number column in toggleterm buffers
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
      start_in_insert = true,
      insert_mappings = true, -- whether or not the open mapping applies in insert mode
      terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
      persist_size = true,
      direction = "horizontal",
      close_on_exit = true, -- close the terminal window when the process exits
      shell = vim.o.shell, -- change the default shell
      -- This field is only relevant if direction is set to 'float'
      float_opts = _float_opts,
    },
    config = function (_, opts)
      require("toggleterm").setup(opts)

      local function buf_set_keymap(mode, lhs, rhs, desc)
        local opts = { noremap=true, silent=true, buffer=0, desc=desc }
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      function _G.set_terminal_keymaps()
        buf_set_keymap('t', '<esc>', [[<C-\><C-n>]], "Exit terminal mode")
        buf_set_keymap('t', '<C-j>', [[<C-\><C-n><C-W>j]], "Move to the window below")
        buf_set_keymap('t', '<C-k>', [[<C-\><C-n><C-W>k]], "Move to the window above")
      end

      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

      local Terminal = require("toggleterm.terminal").Terminal

      local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float", float_opts = _float_opts })
      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end

      local lazydocker = Terminal:new({ cmd = "lazydocker", hidden = true, direction = "float", float_opts = _float_opts })
      function _LAZYDOCKER_TOGGLE()
        lazydocker:toggle()
      end

      local node = Terminal:new({ cmd = "node", hidden = true, direction = "float", float_opts = _float_opts })
      function _NODE_TOGGLE()
        node:toggle()
      end

      local ncdu = Terminal:new({ cmd = "ncdu", hidden = true, direction = "float", float_opts = _float_opts })
      function _NCDU_TOGGLE()
        ncdu:toggle()
      end

      local htop = Terminal:new({ cmd = "htop", hidden = true, direction = "float", float_opts = _float_opts })
      function _HTOP_TOGGLE()
        htop:toggle()
      end

      local python = Terminal:new({ cmd = "python", hidden = true, direction = "float", float_opts = _float_opts })
      function _PYTHON_TOGGLE()
        python:toggle()
      end

      vim.cmd([[
      " Exposes the plugin's functions for use as commands in Neovim.
      " < [Writing a Neovim Plugin with Lua | Linode](https://www.linode.com/docs/guides/writing-a-neovim-plugin-with-lua/) >

      command! -nargs=0 TermHtop       lua _HTOP_TOGGLE()
      command! -nargs=0 TermLazyDocker lua _LAZYDOCKER_TOGGLE()
      command! -nargs=0 TermLazyGit    lua _LAZYGIT_TOGGLE()
      command! -nargs=0 TermNcdu       lua _NCDU_TOGGLE()
      command! -nargs=0 TermNode       lua _NODE_TOGGLE()
      command! -nargs=0 TermPython     lua _PYTHON_TOGGLE()
      ]])

    end,
  }
}
