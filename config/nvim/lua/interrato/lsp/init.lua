local has_lsp, lspconfig = pcall(require, "lspconfig")
if not has_lsp then
  return
end

local function buf_noremap(buffer, mode, lhs, rhs)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(buffer, mode, lhs, rhs, opts)
end

local filetype_attach = setmetatable({
  go = function(client)
    vim.cmd [[
      augroup LSPBufFormat
        autocmd! BufWritePre <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
      augroup END
    ]]
  end,
}, {
  -- For non-existent indexes return an empty function
  __index = function()
    return function() end
  end,
})

local buf_nnoremap = function(lhs, rhs) buf_noremap(0, "n", lhs, rhs) end
local buf_inoremap = function(lhs, rhs) buf_noremap(0, "i", lhs, rhs) end

local custom_attach = function(client)
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")

  -- Signature help in Insert mode
  buf_inoremap("<C-s>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")

  -- Declarations, definitions, references
  buf_nnoremap("gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>")
  buf_nnoremap("gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
  buf_nnoremap("gT",  "<Cmd>lua vim.lsp.buf.type_definition()<CR>")
  buf_nnoremap("gr",  "<Cmd>lua vim.lsp.buf.references()<CR>")

  -- Hover
  buf_nnoremap("K", "<Cmd>lua vim.lsp.buf.hover()<CR>")

  -- Rename
  buf_nnoremap("<Space>rn", "<Cmd>lua vim.lsp.buf.rename()<CR>")

  -- Code Actions
  buf_nnoremap("<Space>ca", "<Cmd>lua vim.lsp.buf.code_action()<CR>")

  -- Enable completion triggered by <C-x><C-o>
  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

  -- Refresh Code Lens
  if client.resolved_capabilities.code_lens then
    vim.cmd [[
      augroup LSPDocumentCodeLens
        autocmd! * <buffer>
        autocmd BufWritePost,CursorHold <buffer> lua vim.lsp.codelens.refresh()
      augroup END
    ]]
  end

  -- Attach filetype specific options
  filetype_attach[filetype](client)
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
updated_capabilities.textDocument.codeLens = { dynamic_registration = false }
updated_capabilities = require("cmp_nvim_lsp").update_capabilities(updated_capabilities)

return {
  on_attach = custom_attach,
  capabilities = updated_capabilities,
}
