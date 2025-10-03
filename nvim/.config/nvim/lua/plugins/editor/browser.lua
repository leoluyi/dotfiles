return {
  {
    "lalitmee/browse.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      {
        "<leader>G",
        function()
          require("browse").input_search()
        end,
        mode = { "n", "x" },
        desc = "(browse) [G]oogle search",
      },
    },
    opts = {
      -- search provider you want to use
      provider = "google", -- duckduckgo, bing

      -- either pass it here or just pass the table to the functions
      -- see below for more
      bookmarks = {},
      icons = {
        bookmark_alias = "->", -- if you have nerd fonts, you can set this to ""
        bookmarks_prompt = "󰂺 ", -- if you have nerd fonts, you can set this to "󰂺 "
        grouped_bookmarks = "", -- if you have nerd fonts, you can set this to 
      },
      -- if you want to persist the query for grouped bookmarks
      -- See https://github.com/lalitmee/browse.nvim/pull/23
      -- persist_grouped_bookmarks_query = false,
    },
  },
}
