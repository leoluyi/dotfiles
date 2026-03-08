local M = {}

-- Neovim 0.11+ only — compat shims for pre-0.11 removed.

local function is_inlay_hints_enabled(bufnr)
  if type(vim.lsp.inlay_hint) ~= "table" or not vim.lsp.inlay_hint.is_enabled then
    return false
  end
  return vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
end

local function set_inlay_hints(bufnr, enabled)
  if type(vim.lsp.inlay_hint) == "table" then
    vim.lsp.inlay_hint.enable(enabled, { bufnr = bufnr })
    return true
  else
    vim.notify_once("inlay hints not supported in this Neovim version", vim.log.levels.WARN)
    return false
  end
end

local function is_diagnostics_enabled(bufnr)
  return vim.diagnostic.is_enabled({ bufnr = bufnr })
end

local function set_diagnostics(bufnr, enabled)
  vim.diagnostic.enable(enabled, { bufnr = bufnr })
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
  map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder,    "Lsp [W]orkspace [A]dd Folder")
  map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, "Lsp [W]orkspace [R]emove Folder")
  map("n", "<leader>lwl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "Lsp [W]orkspace [L]ist Folders")

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

  -- Toggle inlay hints
  -- Seed state from the actual current value rather than assuming a default.
  vim.b[bufnr].inlay_hints_visible = is_inlay_hints_enabled(bufnr)

  local function toggle_inlay_hints()
    if vim.b[bufnr].inlay_hints_visible then
      if set_inlay_hints(bufnr, false) then
        vim.b[bufnr].inlay_hints_visible = false
      end
    else
      if client.server_capabilities.inlayHintProvider then
        if set_inlay_hints(bufnr, true) then
          vim.b[bufnr].inlay_hints_visible = true
        end
      else
        vim.notify_once("no inlay hints available", vim.log.levels.WARN)
      end
    end
  end

  -- Toggle diagnostics
  -- Seed state from the actual current value rather than assuming a default.
  vim.b[bufnr].diagnostics_visible = is_diagnostics_enabled(bufnr)

  local function toggle_diagnostics()
    if vim.b[bufnr].diagnostics_visible then
      vim.b[bufnr].diagnostics_visible = false
      set_diagnostics(bufnr, false)
    else
      vim.b[bufnr].diagnostics_visible = true
      set_diagnostics(bufnr, true)
    end
  end

  map("n", "<leader>ud", toggle_diagnostics, "Lsp Toggle [D]iagnostics")
  map("n", "<leader>uh", toggle_inlay_hints, "Lsp Toggle Inlay [H]ints")
end

return M
