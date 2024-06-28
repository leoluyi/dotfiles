return {
  -- UI. =========================================================================={{{3

  { 'j-hui/fidget.nvim' },

  -- Better quickfix window in Neovim, polish old quickfix window.
  { 'kevinhwang91/nvim-bqf', ft = 'qf' },

  {
    'norcalli/nvim-colorizer.lua',
    opts = {
      '*', -- Highlight all files, but customize some others.
      css = { rgb_fn = true, }, -- Enable parsing rgb(...) functions in css.
    },
    config = function(_, opts)
      local default_opts = {
        RGB      = false,        -- #RGB hex codes
        RRGGBB   = true,         -- #RRGGBB hex codes
        names    = false,        -- "Name" codes like Blue
        RRGGBBAA = false,        -- #RRGGBBAA hex codes
        rgb_fn   = false,        -- CSS rgb() and rgba() functions
        hsl_fn   = false,        -- CSS hsl() and hsla() functions
        css      = false,        -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn   = false,        -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes: foreground, background
        mode     = 'background', -- Set the display mode.
      }

      require("colorizer").setup(opts, default_opts)

      if not vim.opt.termguicolors then return end
      vim.opt.termguicolors = true
    end,
  },

}
