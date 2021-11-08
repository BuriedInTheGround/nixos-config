local lsp = require "interrato.lsp"

require("lspconfig").gopls.setup {
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
  cmd = { "gopls", "-remote=auto" },
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      codelenses = { test = true },
      gofumpt = true,
      staticcheck = true,
    }
  }
}
