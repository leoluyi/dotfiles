local M = {}

-- https://github.com/neovim/nvim-lspconfig/wiki/Multiple-language-servers-FAQ
---@diagnostic disable-next-line: lowercase-global
M.formatting_keymaps = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=true, desc="✨Lsp [F]ormat Buffer" }

  if client.supports_method("textDocument/formatting") then
    if vim.fn.has('nvim-0.8') then
      buf_set_keymap("n", "<localleader>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
    else
      buf_set_keymap("n", "<localleader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
      if client.server_capabilities.document_range_formatting or client.server_capabilities.documentRangeFormattingProvider then
        buf_set_keymap("n", "<localleader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
      end
    end
  end
end


M.keymaps = function(client, bufnr)
  -- Set up buffer-local keymaps (vim.api.nvim_buf_set_keymap()), etc.
  local function buf_set_keymap(mode, lhs, rhs, desc)
    local opts = { noremap=true, silent=true, buffer=bufnr, desc=desc }
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  if not table.unpack then
    table.unpack = unpack
  end

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr } )

  -- Mappings. ========================================================================

  ---@diagnostic disable-next-line: unused-local
  vim.api.nvim_create_user_command('LspInspectClients', function(opts)
    print(vim.inspect(vim.lsp.get_clients()))
  end, { nargs = 0 })

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap("n", "cl", "<cmd>LspInfo<cr>", "Lsp Info")
  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", "✨Lsp go to [D]eclaration")
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", "✨Lsp go to [D]efinition")
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")
  -- buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")  -- Use lspsaga instead.
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", "✨Lsp go to [I]mplementation")
  buf_set_keymap("n", "gK", "<cmd>lua vim.lsp.buf.signature_help()<cr>", "✨Lsp Signature Help")
  buf_set_keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "✨[W]orkspace [A]dd Folder")
  buf_set_keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "✨[W]orkspace [R]emove Folder")
  buf_set_keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", "✨[W]orkspace [L]ist Folders")
  -- buf_set_keymap('n', "<localleader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>")  -- Use lspsaga instead.
  -- buf_set_keymap('n', "<localleader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>")  -- Use lspsaga instead.
  -- buf_set_keymap('n', "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>, "✨Prev [D]iagnostic"")  -- Use lspsaga instead.
  -- buf_set_keymap('n', "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", "✨Next [D]iagnostic")  -- Use lspsaga instead.
  buf_set_keymap("n", "<leader>dd", '<cmd>lua vim.diagnostic.open_float({scope="line"})<cr>', "✨Lsp [D]iagnostics (current line)")
  -- buf_set_keymap('n', "<leader>dl", "<cmd>lua vim.diagnostic.setloclist({open=true,severity={min=vim.diagnostic.severity.WARN}})<cr>", "Lsp [D]iagnostics [L]ocal list")

  -- Lspsaga ==========================================================================

  -- Diagnostics.
  -- buf_set_keymap("n", "<leader>D", "<cmd>Lspsaga show_buf_diagnostics<CR>", "(Lspsaga) [D]iagnostics (buffer)")
  buf_set_keymap("n", "[d", function() require("lspsaga.diagnostic"):goto_prev() end, "✨Prev [D]iagnostic")
  buf_set_keymap("n", "]d", function() require("lspsaga.diagnostic"):goto_next() end, "✨Next [D]iagnostic")
  buf_set_keymap("n", "[w", function() require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.WARN }) end, "(Lspsaga) Prev [W]arn")
  buf_set_keymap("n", "]w", function() require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.WARN }) end, "(Lspsaga) Next [W]arn")
  buf_set_keymap("n", "[e", function() require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, "(Lspsaga) Prev [E]rror")
  buf_set_keymap("n", "]e", function() require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR }) end, "(Lspsaga) Next [E]rror")

  -- LSP finder - Find the symbol's definition
  buf_set_keymap("n", "gF", "<cmd>Lspsaga lsp_finder<CR>", "(Lspsaga) [G]oto Lsp [F]inder")

  -- Code action
  buf_set_keymap("n", "<localleader>ca", "<cmd>Lspsaga code_action<cr>", "(Lspsaga) [C]ode [A]ction")
  buf_set_keymap("v", "<localleader>ca", "<cmd>Lspsaga code_action<cr>", "(Lspsaga) [C]ode [A]ction")

  -- buf_set_keymap("n", "<C-b>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>")
  -- buf_set_keymap("n", "<C-f>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>")

  -- Rename all occurrences of the hovered word for the selected files
  -- buf_set_keymap("n", "<localleader>rn", "<cmd>Lspsaga rename ++project<CR>", "(Lspsaga) [R]eName")
  -- Rename all occurrences of the hovered word for the entire file
  buf_set_keymap( "n", "<localleader>rn", "<cmd>Lspsaga rename<CR>", "(Lspsaga) [R]ename")

  -- Call trace
  if client.server_capabilities.documentHighlightProvider then
    -- textDocument/prepareCallHierarchy
    buf_set_keymap("n", "<leader>lci", "<cmd>Lspsaga incoming_calls<CR>", "(Lspsaga) Goto call inside")
    buf_set_keymap("n", "<leader>lco", "<cmd>Lspsaga outgoing_calls<CR>", "(Lspsaga) Goto call outside")
  end

  -- Other keymaps.
  -- < https://github.com/gennaro-tedesco/dotfiles/blob/7385fa7f2d28b9b3ac5f18f52894127e433ab81c/nvim/lua/plugins/lsp.lua#L46-L59>

  --- toggle inlay hints
  vim.g.inlay_hints_visible = false
  local function toggle_inlay_hints()
    if vim.g.inlay_hints_visible then
      vim.g.inlay_hints_visible = false
      vim.lsp.inlay_hint(bufnr, false)
    else
      if client.server_capabilities.inlayHintProvider then
        vim.g.inlay_hints_visible = true
        vim.lsp.inlay_hint(bufnr, true)
      else
        print("no inlay hints available")
      end
    end
  end

  --- toggle diagnostics
  vim.g.diagnostics_visible = true
  local function toggle_diagnostics()
    if vim.g.diagnostics_visible then
      vim.g.diagnostics_visible = false
      vim.diagnostic.ensable(false)
    else
      vim.g.diagnostics_visible = true
      vim.diagnostic.enable()
    end
  end

  buf_set_keymap("n", "<leader>ud", toggle_diagnostics, "✨Lsp Toggle [D]iagnostics")

  if vim.fn.has("nvim-0.10") == 1 then
    buf_set_keymap("n", "<leader>uh", toggle_inlay_hints, "✨Lsp Toggle Inlay [H]ints")
  end
end


return M
