local M = {}

local is_nvim_011 = vim.fn.has("nvim-0.11") == 1
local is_nvim_010 = vim.fn.has("nvim-0.10") == 1

-- Query the current inlay-hint state for bufnr, handling API differences:
--   0.11+:   is_enabled({ bufnr = bufnr })
--   0.10:    is_enabled(bufnr)
--   pre-0.10: no is_enabled; returns false
local function is_inlay_hints_enabled(bufnr)
  if type(vim.lsp.inlay_hint) ~= "table" or not vim.lsp.inlay_hint.is_enabled then
    return false
  end
  if is_nvim_011 then
    return vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
  else
    return vim.lsp.inlay_hint.is_enabled(bufnr)
  end
end

-- Apply inlay-hint enable/disable, handling API differences across Neovim versions:
--   0.11+:   enable(bool, { bufnr = bufnr })
--   0.10:    enable(bufnr, bool)
--   pre-0.10: plain-function vim.lsp.inlay_hint(bufnr, bool)
local function set_inlay_hints(bufnr, enabled)
  if type(vim.lsp.inlay_hint) == "table" then
    if is_nvim_011 then
      vim.lsp.inlay_hint.enable(enabled, { bufnr = bufnr })
    else
      vim.lsp.inlay_hint.enable(bufnr, enabled)
    end
  else
    vim.lsp.inlay_hint(bufnr, enabled)
  end
end

-- Apply diagnostic enable/disable, handling API differences across Neovim versions:
--   0.10+:   enable(bool, { bufnr = bufnr })
--   pre-0.10: enable(bufnr) / disable(bufnr)
local function set_diagnostics(bufnr, enabled)
  if is_nvim_010 then
    vim.diagnostic.enable(enabled, { bufnr = bufnr })
  elseif enabled then
    vim.diagnostic.enable(bufnr)
  else
    vim.diagnostic.disable(bufnr)
  end
end

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
  -- Seed state from the actual current value rather than assuming a default.
  vim.b[bufnr].inlay_hints_visible = is_inlay_hints_enabled(bufnr)

  local function toggle_inlay_hints()
    if vim.lsp.inlay_hint == nil then
      vim.notify("inlay hints not supported in this Neovim version", vim.log.levels.WARN)
      return
    end
    if vim.b[bufnr].inlay_hints_visible then
      vim.b[bufnr].inlay_hints_visible = false
      set_inlay_hints(bufnr, false)
    else
      if client.server_capabilities.inlayHintProvider then
        vim.b[bufnr].inlay_hints_visible = true
        set_inlay_hints(bufnr, true)
      else
        vim.notify("no inlay hints available", vim.log.levels.WARN)
      end
    end
  end

  --- toggle diagnostics
  -- Seed state from the actual current value rather than assuming a default.
  local diag_initially_enabled
  if is_nvim_010 and vim.diagnostic.is_enabled then
    diag_initially_enabled = vim.diagnostic.is_enabled({ bufnr = bufnr })
  elseif vim.diagnostic and vim.diagnostic.is_disabled then
    diag_initially_enabled = not vim.diagnostic.is_disabled(bufnr)
  else
    diag_initially_enabled = true
  end
  vim.b[bufnr].diagnostics_visible = diag_initially_enabled

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
