return {
  -- UI. =========================================================================={{{3

  { 'j-hui/fidget.nvim' },

  -- nvim-colorizer. ============================================================={{{3
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = false,
        AARRGGBB = false,
        rgb_fn = false,
        hsl_fn = false,
        css = false,
        css_fn = false,
        mode = "background",
        tailwind = false,
        virtualtext = "■",
      },
    },
  },

}
