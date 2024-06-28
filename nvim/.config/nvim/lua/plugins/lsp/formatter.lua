return {
  {
    "mhartington/formatter.nvim",
    enable = false,
    opts = function()
      return {
        filetype = {
          -- ["*"] = {
          --   { cmd = { "sed -i 's/[ \t]*$//'" } },
          -- },
          -- lua = {
          --   { cmd = { "stylua -s -" } },
          -- },
          python = {
            { cmd = { "black --quiet --fast -" } },
            require("formatter.filetypes.python").isort,
          },
          -- sh = {
          --   { cmd = { "shfmt -i 2 -ci -s -bn -sr -kp" } },
          -- },
          -- vim = {
          --   { cmd = { "luafmt -w replace" } },
          -- },
          -- yaml = {
          --   { cmd = { "prettier -w --parser yaml" } },
          -- },
        },
      }
    end,
    config = function (_, opts)
      require("formatter").setup(opts)

      local function augroup(name)
        return vim.api.nvim_create_augroup("formatter_" .. name, { clear = true })
      end

      -- Check if we need to reload the file when it changed
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = augroup("format_on_save"),
        callback = function()
          -- check if the buffer's filetype is not in the list
          local ft = vim.api.nvim_buf_get_option(0, "filetype")
          if vim.tbl_contains({ "json", "sh", }, ft) then
            return
          else
            vim.cmd("FormatWrite")
          end
        end,
        desc = "Format with formatters",
      })

    end
  },
}
