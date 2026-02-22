return {
  -- < https://github.com/windwp/nvim-autopairs >
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    keys = {
      { '<leader>uP', function() _G.autopairs_toggle() end, desc = 'Toggle Auto[P]airs' },
    },
    opts = {
      check_ts = true,
      disable_filetype = { "spectre_panel", "TelescopePrompt" , "guihua", "guihua_rust", "clap_input" },
      disable_in_macro = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
      },
      fast_wrap = {
        map = '<C-s>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = [=[[%'%"%)%>%]%)%}%,]]=],
        offset = 0,
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        highlight = 'Search',
        highlight_grey='Comment'
      },
      map_c_h = true,  -- Map the <C-h> key to delete a pair
      map_c_w = true, -- map <c-w> to delete a pair if possible
      map_cr = true,
    },
    config = function (_, opts)
      local npairs = require('nvim-autopairs')
      local Rule   = require('nvim-autopairs.rule')

      npairs.setup(opts)

      -- If you want insert `(` after select function or method item
      local status_ok, cmp = pcall(require, 'cmp')
      if status_ok then
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
      end

      -- Add spaces between parentheses.
      -- https://github.com/windwp/nvim-autopairs/wiki/Custom-rules#add-spaces-between-parentheses
      npairs.add_rules {
        Rule(' ', ' ')
          :with_pair(function (opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({ '()', '[]', '{}' }, pair)
          end),
        Rule('( ', ' )')
          :with_pair(function() return false end)
          :with_move(function(opts)
            return opts.prev_char:match('.%)') ~= nil
          end)
          :use_key(')'),
        Rule('{ ', ' }')
          :with_pair(function() return false end)
          :with_move(function(opts)
            return opts.prev_char:match('.%}') ~= nil
          end)
          :use_key('}'),
        Rule('[ ', ' ]')
          :with_pair(function() return false end)
          :with_move(function(opts)
            return opts.prev_char:match('.%]') ~= nil
          end)
          :use_key(']')
      }

      -- https://github.com/windwp/nvim-autopairs/issues/139#issuecomment-930797072
      _G.autopairs_toggle = function()
        local ok, autopairs = pcall(require, "nvim-autopairs")
        if ok then
          if autopairs.state.disabled then
            autopairs.enable()
            print("autopairs on")
          else
            autopairs.disable()
            print("autopairs off")
          end
        else
          print("autopairs not available")
        end
      end

      vim.api.nvim_create_user_command('AutopairsToggle', autopairs_toggle, {})

    end
  }
}
