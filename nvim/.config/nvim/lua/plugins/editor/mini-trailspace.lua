return {
  {
    "echasnovski/mini.trailspace",
    opts = {
      only_in_normal_buffers = true,
    },
    config = function(_, opts)
      require("mini.trailspace").setup(opts)

      -- Create cmd for trailspace
      vim.api.nvim_create_user_command("TrailspaceTrim", "lua MiniTrailspace.trim()", {})
      vim.api.nvim_create_user_command("TrailspaceTrimLastLines", "lua MiniTrailspace.trim_last_lines()", {})
    end,
  },
  -- { 'ntpeters/vim-better-whitespace' },  -- Better whitespace highlighting for Vim
}
