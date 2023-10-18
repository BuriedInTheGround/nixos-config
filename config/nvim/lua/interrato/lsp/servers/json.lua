local lsp = require "interrato.lsp"
local capabilities = lsp.capabilities
capabilities.textDocument.completion.completionItem.snippetSupport = true

require("lspconfig").jsonls.setup {
  on_attach = lsp.on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  }
}
