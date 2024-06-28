return {
  -- Lightning fast left-right movement.
  {
    'unblevable/quick-scope',
    keys = {
      "f", "F", "t", "T",
    },
    config = function ()
      --  Trigger a highlight in the appropriate direction when pressing these keys:
      vim.g.qs_lazy_highlight = 1
      vim.g.qs_highlight_on_keys = { 'f', 'F', 't', 'T' }
      vim.g.qs_max_chars=120
      vim.g.qs_buftype_blacklist = { 'terminal', 'nofile', 'alpha', 'dashboard', 'startify' }
    end
  },

}
