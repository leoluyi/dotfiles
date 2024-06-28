return {
  {
    'scalameta/nvim-metals',
    dependencies = {'nvim-lua/plenary.nvim'},
    ft = { 'scala' },
    config = function ()
      local metals_config = require("metals").bare_config()

      metals_config.settings = {
        showImplicitArguments = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
        init_options = {
          statusBarProvider = "on",
        },
      }

      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- metals_config.capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

      -- Autocmd that will actually be in charging of starting the whole thing
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        -- NOTE: You may or may not want java included here. You will need it if you
        -- want basic Java support but it may also conflict if you are using
        -- something like nvim-jdtls which also works on a java filetype autocmd.
        pattern = { "scala", "sbt" },
        callback = function()
          require("metals").initialize_or_attach(metals_config)
          ---@diagnostic disable-next-line: undefined-field
          vim.opt_local.shortmess:remove("F"):append("c")
        end,
        group = nvim_metals_group,
      })
    end,
  },
}
