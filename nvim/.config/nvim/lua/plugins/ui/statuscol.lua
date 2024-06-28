return {

  -- < https://github.com/luukvbaal/statuscol.nvim >
  {
    "luukvbaal/statuscol.nvim",
    enabled = true,
    lazy = false,
    opts = function()
      local builtin = require("statuscol.builtin")
      return {
        relculright = false,
        clickmod = "c",   -- modifier used for certain actions in the builtin clickhandlers
                          -- "a" for Alt, "c" for Ctrl and "m" for Meta.
        ft_ignore = { "Neogit", "neo-tree", "Outline", "dapui_*" },

        -- :h 'statuscolumn'
        segments = {
          {
            sign = {
              name = { ".*" },
              namespace = { "gitsigns" },
              maxwidth = 1,  -- maximum number of signs that will be displayed in this segment.
              colwidth = 2,  -- number of display cells per sign in this segment.
              auto = false,
              wrap = false,
            },
            click = "v:lua.ScSa",
          },
          {
            text = { builtin.lnumfunc, " " },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
          {
            text = { builtin.foldfunc, colwidth = 1 },
            click = "v:lua.ScFa",
          },
        },
      }
    end,
  },

}
