---@diagnostic disable: undefined-field
local path_join = require('helpers.util').path_join
local dirname = require('helpers.util').dirname
local api = vim.api
local lsp = vim.lsp
local lsp_keymaps = require("helpers.lsp_keymaps").keymaps
local formatting_keymaps = require("helpers.lsp_keymaps").formatting_keymaps

--

local M = {}

-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/lsp.lua
---@param opts? lsp.Client.filter
function M.get_clients(opts)
  local ret = {} ---@type lsp.Client[]
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ---@param client lsp.Client
      ret = vim.tbl_filter(function(client)
        return client.supports_method(opts.method, { bufnr = opts.bufnr })
      end, ret)
    end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

-- https://github.com/neovim/nvim-lspconfig/issues/500#issuecomment-867861560
function M.get_python_path(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return path_join(vim.env.VIRTUAL_ENV, 'bin', 'python')
  end

  -- Find and use virtualenv from pipenv in workspace directory.
  local match

  match = vim.fn.glob(path_join(workspace, 'Pipfile'))
  if match ~= '' then
    local venv = vim.fn.trim(vim.fn.system('PIPENV_PIPFILE=' .. match .. ' pipenv --venv'))
    return path_join(venv, 'bin', 'python')
  end

  -- Find and use virtualenv via poetry in workspace directory.
  match = vim.fn.glob(path_join(workspace, 'poetry.lock'))
  if match ~= '' then
    local venv = vim.fn.trim(vim.fn.system('poetry env info -p'))
    return path_join(venv, 'bin', 'python')
  end

  -- Find and use virtualenv in workspace directory.
  for _, pattern in ipairs({'*', '.*'}) do
    match = vim.fn.glob(path_join(workspace, pattern, 'pyvenv.cfg'))
    if match ~= '' then
      return path_join(dirname(match), 'bin', 'python')
    end
  end

  -- Fallback to system Python.
  return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
end

-- Key mappings and attached options ----------------------------------------------{{{2

M.diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end


local lsp_highlight_cursor = function(client, bufnr)
  -- highlight words on cursor hold.
  -- < https://stackoverflow.com/a/74609038/3744499 >
  if client.server_capabilities.documentHighlightProvider then
    vim.cmd([[
      hi! link LspReferenceRead Visual
      hi! link LspReferenceText Visual
      hi! link LspReferenceWrite Visual
      ]])

    local gid = api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    api.nvim_create_autocmd("CursorHold" , {
      group = gid,
      buffer = bufnr,
      callback = function ()
        lsp.buf.document_highlight()
      end
    })

    api.nvim_create_autocmd("CursorMoved" , {
      group = gid,
      buffer = bufnr,
      callback = function ()
        lsp.buf.clear_references()
      end
    })
  end
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer.
M.lsp_attach = function(client, bufnr)
  print("[LSP] Attaching to client: " .. client.name)

  -- Avoiding LSP formatting conflicts.
  -- < https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts >
  -- < https://github.com/neovim/nvim-lspconfig/wiki/Multiple-language-servers-FAQ >
  if client.name ~= "gopls" then
    if vim.fn.has('nvim-0.8') then
      client.server_capabilities.documentFormattingProvider = false -- 0.8 and later
    else
      client.server_capabilities.document_formatting = false -- 0.7 and earlier
    end
  end

  -- < https://github.com/glepnir/nvim/blob/main/lua/modules/lsp/backend.lua#L7 >
  client.server_capabilities.semanticTokensProvider = nil

  lsp_keymaps(client, bufnr)
  lsp_highlight_cursor(client, bufnr)
  formatting_keymaps(client, bufnr)

  require "lsp_signature".on_attach()  -- Enable https://github.com/ray-x/lsp_signature.nvim
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

M.capabilities = capabilities

return M
