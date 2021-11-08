local lsp = require "interrato.lsp"

require("lspconfig").pyright.setup {
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
  flags = {
    debounce_text_changes = 150,
  }
}
