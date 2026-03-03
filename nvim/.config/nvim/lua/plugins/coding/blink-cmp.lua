return {
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = {
      "L3MON4D3/LuaSnip",
      { "saghen/blink.compat", version = "*", lazy = true, opts = {} },
      {
        "uga-rosa/cmp-dictionary",
        lazy = true,
        opts = {
          dic = { ["markdown"] = { "/usr/share/dict/words" } },
          exact_length = 2,
          first_case_insensitive = false,
          document = { enable = false, command = { "wn", "${label}", "-over" } },
        },
      },
      "kristijanhusak/vim-dadbod-completion",
    },

    opts = function()
      local icons = require("util.icons")
      return {
        enabled = function()
          return vim.bo.buftype ~= "prompt"
        end,

        snippets = { preset = "luasnip" },

        cmdline = {
          sources = { "path", "cmdline" },
        },

        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
          per_filetype = {
            markdown = { "lsp", "path", "snippets", "buffer", "dictionary" },
            sql      = { "dadbod", "buffer" },
          },
          providers = {
            dictionary = {
              name         = "dictionary",
              module       = "blink.compat.source",
              score_offset = -3,
              opts         = { keyword_length = 2 },
            },
            dadbod = {
              name   = "vim-dadbod-completion",
              module = "blink.compat.source",
            },
          },
        },

        keymap = {
          preset    = "default",
          ["<CR>"]  = { "accept", "fallback" },
          ["<S-CR>"] = { "accept", "fallback" },
          ["<C-e>"] = { "cancel", "fallback" },
          ["<Up>"]  = { "select_prev", "fallback" },
          ["<Down>"] = { "select_next", "fallback" },
          ["<Tab>"]  = {},  -- owned by luasnip
          ["<S-Tab>"] = {}, -- owned by luasnip
        },

        completion = {
          accept = { auto_brackets = { enabled = true } },
          list = { selection = { preselect = true, auto_insert = false } },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            window = {
              border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
              winhighlight = "NormalFloat:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
            },
          },
          menu = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            winhighlight = "NormalFloat:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
            draw = {
              columns = {
                { "kind_icon", gap = 1 },
                { "label", "label_description", gap = 1 },
                { "source_name" },
              },
              components = {
                kind_icon = {
                  text = function(ctx) return (icons.kinds[ctx.kind] or "") .. " " end,
                },
                source_name = {
                  text = function(ctx)
                    local labels = {
                      lsp        = "[LSP]",
                      snippets   = "[Snippet]",
                      path       = "[Path]",
                      buffer     = "[Buffer]",
                      dictionary = "[Dict]",
                      dadbod     = "[DB]",
                    }
                    return labels[ctx.source_name] or ("[" .. ctx.source_name .. "]")
                  end,
                },
              },
            },
          },
          ghost_text = { enabled = true },
        },

        signature = {
          enabled = true,
          window = { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } },
        },

        appearance = {
          use_nvim_cmp_as_default = false,
          nerd_font_variant = "mono",
        },
      }
    end,
  },
}
