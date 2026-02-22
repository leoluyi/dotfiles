local M = {}

-- https://github.com/neovim/nvim-lspconfig/wiki/Multiple-language-servers-FAQ
M.formatting_keymaps = function(client, bufnr)
  if not client.supports_method("textDocument/formatting") then return end
  vim.keymap.set("n", "<localleader>f", "<cmd>lua vim.lsp.buf.format()<CR>", {
    noremap = true, silent = true, buffer = bufnr, desc = "Lsp [F]ormat Buffer",
  })
end

M.keymaps = function(client, bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
  end

  -- Navigation
  map("n", "cl",  "<cmd>LspInfo<cr>",         "Lsp Info")
  map("n", "gD",  vim.lsp.buf.declaration,    "Lsp Go to [D]eclaration")
  map("n", "gd",  vim.lsp.buf.definition,     "Lsp Go to [D]efinition")
  map("n", "gr",  vim.lsp.buf.references,     "Lsp [R]eferences")
  map("n", "gi",  vim.lsp.buf.implementation, "Lsp Go to [I]mplementation")
  map("n", "gK",  vim.lsp.buf.signature_help, "Lsp Signature Help")
  map("n", "gF",  "<cmd>Lspsaga lsp_finder<CR>", "Lsp [F]inder (Lspsaga)")

  -- Workspace
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder,    "[W]orkspace [A]dd Folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- Diagnostics
  map("n", "<leader>dd", function() vim.diagnostic.open_float({ scope = "line" }) end, "Lsp [D]iagnostics (current line)")
  map("n", "[d", function() require("lspsaga.diagnostic"):goto_prev() end,                                             "Prev [D]iagnostic")
  map("n", "]d", function() require("lspsaga.diagnostic"):goto_next() end,                                             "Next [D]iagnostic")
  map("n", "[w", function() require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.WARN }) end,  "Prev [W]arn")
  map("n", "]w", function() require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.WARN }) end,  "Next [W]arn")
  map("n", "[e", function() require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, "Prev [E]rror")
  map("n", "]e", function() require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR }) end, "Next [E]rror")

  -- Code actions & rename
  map("n", "<localleader>ca", "<cmd>Lspsaga code_action<cr>", "Lsp [C]ode [A]ction")
  map("v", "<localleader>ca", "<cmd>Lspsaga code_action<cr>", "Lsp [C]ode [A]ction")
  map("n", "<localleader>rn", "<cmd>Lspsaga rename<CR>",      "Lsp [R]ename")

  -- Call hierarchy
  if client.server_capabilities.documentHighlightProvider then
    map("n", "<leader>lci", "<cmd>Lspsaga incoming_calls<CR>", "Lsp Incoming Calls")
    map("n", "<leader>lco", "<cmd>Lspsaga outgoing_calls<CR>", "Lsp Outgoing Calls")
  end

  -- Other keymaps.
  -- < https://github.com/gennaro-tedesco/dotfiles/blob/7385fa7f2d28b9b3ac5f18f52894127e433ab81c/nvim/lua/plugins/lsp.lua#L46-L59>

  --- toggle inlay hints
  vim.g.inlay_hints_visible = false
  local function toggle_inlay_hints()
    -- Both Neovim 0.10 and 0.11+ expose vim.lsp.inlay_hint as a table, but
    -- the .enable() signature differs:
    --   0.10:  enable(bufnr, bool)
    --   0.11+: enable(bool, { bufnr = bufnr })
    local function set_hints(enabled)
      if type(vim.lsp.inlay_hint) == "table" then
        if vim.fn.has("nvim-0.11") == 1 then
          vim.lsp.inlay_hint.enable(enabled, { bufnr = bufnr })
        else
          vim.lsp.inlay_hint.enable(bufnr, enabled)
        end
      else
        -- pre-0.10 plain-function form
        vim.lsp.inlay_hint(bufnr, enabled)
      end
    end

    if vim.g.inlay_hints_visible then
      vim.g.inlay_hints_visible = false
      set_hints(false)
    else
      if client.server_capabilities.inlayHintProvider then
        vim.g.inlay_hints_visible = true
        set_hints(true)
      else
        print("no inlay hints available")
      end
    end
  end

  --- toggle diagnostics
  vim.g.diagnostics_visible = true
  local function toggle_diagnostics()
    -- vim.diagnostic.enable(bool, opts) is the 0.10+ API.
    -- Pre-0.10: use disable(bufnr) / enable(bufnr) instead.
    if vim.g.diagnostics_visible then
      vim.g.diagnostics_visible = false
      if vim.fn.has("nvim-0.10") == 1 then
        vim.diagnostic.enable(false, { bufnr = bufnr })
      else
        vim.diagnostic.disable(bufnr)
      end
    else
      vim.g.diagnostics_visible = true
      if vim.fn.has("nvim-0.10") == 1 then
        vim.diagnostic.enable(true, { bufnr = bufnr })
      else
        vim.diagnostic.enable(bufnr)
      end
    end
  end
  map("n", "<leader>ud", toggle_diagnostics, "Lsp Toggle [D]iagnostics")
  map("n", "<leader>uh", toggle_inlay_hints, "Lsp Toggle Inlay [H]ints")
end

return M
