return {
  -- Snippets.
  -- < https://github.com/L3MON4D3/LuaSnip >
  -- < https://github.com/alpha2phi/neovim-for-beginner/blob/20-snippets/lua/config/snip/init.lua >
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      -- Set of preconfigured snippets for different languages.
      {
        "rafamadriz/friendly-snippets",
        config = function()
          -- Load built-in snippets from friendly-snippets.
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    config = function (_, opts)
      local luasnip = require "luasnip"
      local luasnip_snippet_dir = vim.fn.stdpath("config") .. '/snippets/luasnip'

      luasnip.setup(opts)

      -- Load custom snippets.
      require("luasnip.loaders.from_vscode").lazy_load({ paths = luasnip_snippet_dir })

      -- Enable all default snippets.
      luasnip.filetype_extend("all", { "_" })

      -- Enable standardized comments snippets.
      luasnip.filetype_extend("typescript", { "tsdoc" })
      luasnip.filetype_extend("javascript", { "jsdoc" })
      luasnip.filetype_extend("lua", { "luadoc" })
      luasnip.filetype_extend("python", { "python-docstring" })
      luasnip.filetype_extend("rust", { "rustdoc" })
      luasnip.filetype_extend("cs", { "csharpdoc" })
      luasnip.filetype_extend("java", { "javadoc" })
      luasnip.filetype_extend("sh", { "shelldoc" })
      luasnip.filetype_extend("bash", { "shelldoc" })
      luasnip.filetype_extend("c", { "cdoc" })
      luasnip.filetype_extend("cpp", { "cppdoc" })
      luasnip.filetype_extend("php", { "phpdoc" })
      luasnip.filetype_extend("kotlin", { "kdoc" })
      luasnip.filetype_extend("ruby", { "rdoc" })
    end
  },

}
