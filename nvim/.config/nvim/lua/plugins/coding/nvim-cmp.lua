return {

  -- Completion Engine.
  -- https://github.com/hrsh6th/nvim-cmp#recommended-configuration
  {
    "hrsh7th/nvim-cmp", -- A completion plugin for neovim coded in Lua.
    version = false, -- last release is way too old
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "L3MON4D3/LuaSnip", -- Snippet Engine for Neovim written in Lua.
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      "kristijanhusak/vim-dadbod-completion",
      "saadparwaiz1/cmp_luasnip",
      {
        "uga-rosa/cmp-dictionary",
        opts = {
          dic = {
            ["markdown"] = { "/usr/share/dict/words" },
          },
          -- The following are default values, so you don't need to write them if you don't want to change them
          exact_length = 2,
          first_case_insensitive = false,
          document = {
            enable = false,
            command = { "wn", "${label}", "-over" },
          },
        },
      },
    },

    opts = function()
      local cmp = require("cmp")
      local icons = require("util.icons")
      local defaults = require("cmp.config.default")()

      -- helper functions.
      local has_words_before = function()
        local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      return {
        -- < https://github.com/hrsh7th/nvim-cmp/issues/60#issuecomment-1247574145 >
        enabled = function()
          local buftype = vim.bo[0].buftype
          if buftype == "prompt" then
            return false
          end
          return true
        end,

        completion = {
          completeopt = "menuone,noinsert,noselect",
        },
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        preselect = cmp.PreselectMode.None,
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        window = {
          -- documentation = "native",
          documentation = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
          },
          completion = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
          },
        },
        mapping = cmp.mapping.preset.insert({
          -- See < https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/mapping.lua#L36 >
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Esc>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-Space>"] = cmp.mapping(function(fallback)
            -- Super-Tab like mapping for vim-vsnip.
            -- < https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip >
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            elseif has_words_before() then
              cmp.complete()
            else
              fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
          end, { "i", "s" }),

          -- ["<Tab>"] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     cmp.select_next_item()
          --   -- elseif vim.fn["vsnip#available"]() == 1 then
          --   --   feedkey("<Plug>(vsnip-expand-or-jump)", "")
          --   elseif luasnip.expand_or_jumpable() then
          --     luasnip.expand_or_jump()
          --   elseif has_words_before() then
          --     cmp.complete()
          --   else
          --     fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
          --   end
          -- end, { "i", "s" }),
          --
          -- ['<S-Tab>'] = cmp.mapping(function()
          --   if cmp.visible() then
          --     cmp.select_prev_item()
          --   -- elseif vim.fn["vsnip#jumpable"](-1) == 1 then
          --   --   feedkey("<Plug>(vsnip-jump-prev)", "")
          --   elseif luasnip.jumpable(-1) then
          --     luasnip.jump(-1)
          --   end
          -- end, { "i", "s" }),
        }),

        -- < https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance >
        -- < https://github.com/ChristianChiarulli/nvim/blob/master/lua/user/cmp.lua >
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(entry, item)
            -- Kind icons
            local kind = string.format("%s %s", icons.kinds[item.kind], item.kind)
            -- local strings = vim.split(kind, "%s", { trimempty = true })
            item.kind = kind

            if entry.source.name == "cmp_tabnine" then
              item.kind = icons.misc.Robot
            end
            -- vim_item.kind = string.format('%s %s', icons.kinds[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            -- NOTE: order matters
            local menu = ({
              nvim_lua = "[Nvim]",
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              path = "[Path]",
              buffer = "[Buffer]",
              emoji = "[Emoji]",
            })[entry.source.name]

            item.menu = menu

            return item
          end,
        },
        sources = {
          -- The order will be used to the completion menu's sort order.
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
      }
    end,

    config = function(_, opts)
      local cmp = require("cmp")

      -- Setup nvim-cmp.
      cmp.setup(opts)

      -- Set configuration for specific filetype.
      ---@diagnostic disable-next-line: missing-fields
      cmp.setup.filetype("markdown", {
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
          { name = "dictionary", keyword_length = 2 },
        }),
      })

      cmp.setup.filetype("sql", {
        sources = {
          { name = "vim-dadbod-completion" },
          { name = "buffer" },
        },
      })

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      ---@diagnostic disable-next-line: missing-fields
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      ---@diagnostic disable-next-line: missing-fields
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
}
