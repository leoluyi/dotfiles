-- < https://sookocheff.com/post/vim/neovim-java-ide/ >
-- < https://www.lazyvim.org/extras/lang/java#nvim-jdtls >
-- < https://zhuanlan.zhihu.com/p/574746992 >
-- < https://www.youtube.com/watch?v=WelEHE3RwtY >
-- < https://github.com/Nawy/nvim-config-examples/blob/main/lsp-java/ftplugin/java.lua >
-- < https://github.com/ikws4/.dotfiles/blob/main/nvim/.config/nvim/after/ftplugin/java.lua >

local path_join = require("helpers.util").path_join
local lsp_attach = require("helpers.lsp_util").lsp_attach
local capabilities = require("helpers.lsp_util").capabilities
-- local Util = require("helpers.util")

local java_filetypes = { "java", "pom.xml" }

return {
  {
    -- < https://github.com/mfussenegger/nvim-jdtls >
    "mfussenegger/nvim-jdtls",
    dependencies = {
      "folke/which-key.nvim",
      {
        "mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "jdtls" })
        end,
      },
    },
    ft = java_filetypes,
    opts = function()
      local lombok_jar = path_join(vim.fn.expand("$MASON/packages/jdtls"), "lombok.jar")

      return {
        -- How to find the root dir for a given filename.
        -- Using vim.fs.root instead of lspconfig's root_dir function
        root_dir = function(fname)
          return vim.fs.root(fname, { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })
        end,

        -- How to find the project name for a given root dir.
        project_name = function(root_dir)
          return root_dir and vim.fs.basename(root_dir)
        end,

        -- Where are the config and workspace dirs for a project?
        jdtls_config_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
        end,
        jdtls_workspace_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
        end,

        -- How to run jdtls. This can be overridden to a full java command-line
        -- if the Python wrapper script doesn't suffice.
        cmd = {
          "jdtls",
          -- https://github.com/eclipse-jdtls/eclipse.jdt.ls/issues/2113#issuecomment-1173036389
          -- https://www.reddit.com/r/neovim/comments/124t2u6/lazyvim_jdtls_seems_to_be_ignoring_lombok/je2azpw/?context=3
          "--jvm-arg=-javaagent:" .. lombok_jar,
          "--jvm-arg=-Xbootclasspath/a:" .. lombok_jar,
        },

        full_cmd = function(opts)
          local fname = vim.api.nvim_buf_get_name(0)
          local root_dir = opts.root_dir(fname)
          local project_name = opts.project_name(root_dir)
          local cmd = vim.deepcopy(opts.cmd)

          if project_name then
            vim.list_extend(cmd, {
              "-configuration",
              opts.jdtls_config_dir(project_name),
              "-data",
              opts.jdtls_workspace_dir(project_name),
            })
          end
          return cmd
        end,

        lsp_settings = {
          java = {

          }
        }
      }
    end,

    config = function(_, opts)
      local function attach_jdtls()
        local fname = vim.api.nvim_buf_get_name(0)

        -- Configuration can be augmented and overridden by opts.jdtls
        local config = {
          on_attach = lsp_attach,
          capabilities = capabilities,
          cmd = opts.full_cmd(opts),
          root_dir = opts.root_dir(fname),
          settings = opts.lsp_settings,
        }

        -- Existing server will be reused if the root_dir matches.
        require("jdtls").start_or_attach(config)
        -- not need to require("jdtls.setup").add_commands(), start automatically adds commands
      end

      -- Attach the jdtls for each java buffer. HOWEVER, this plugin loads
      -- depending on filetype, so this autocmd doesn't run for the first file.
      -- For that, we call directly below.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = java_filetypes,
        callback = attach_jdtls,
      })

      -- Setup keymap and dap after the lsp is fully attached.
      -- https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
      -- https://neovim.io/doc/user/lsp.html#LspAttach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "jdtls" then
            local wk = require("which-key")
            wk.register({
              ["<localleader>cx"] = { name = "+Extract" },
              ["<localleader>cxv"] = { require("jdtls").extract_variable_all, "Extract Variable" },
              ["<localleader>cxc"] = { require("jdtls").extract_constant, "Extract Constant" },
              ["gs"] = { require("jdtls").super_implementation, "Goto Super" },
              ["gS"] = { require("jdtls.tests").goto_subjects, "Goto Subjects" },
              ["<localleader>co"] = { require("jdtls").organize_imports, "Organize Imports" },
            }, { mode = "n", buffer = args.buf })
            wk.register({
              ["<localleader>cx"] = { name = "+Extract" },
              ["<localleader>cxm"] = {
                [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
                "Extract Method",
              },
              ["<localleader>cxv"] = {
                [[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]],
                "Extract Variable",
              },
              ["<localleader>cxc"] = {
                [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]],
                "Extract Constant",
              },
            }, { mode = "v", buffer = args.buf })
          end
        end,
      })
      -- Avoid race condition by calling attach the first time, since the autocmd won't fire.
      attach_jdtls()
    end,
  },
}
