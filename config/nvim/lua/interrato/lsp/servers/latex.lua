local lsp = require "interrato.lsp"

require("lspconfig").texlab.setup {
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    texlab = {
      auxDirectory = ".",
      bibtexFormatter = "texlab",
      build = {
        args = { "%f" },
        executable = "tectonic",
        forwardSearchAfter = false,
        onSave = false,
      },
    }
  }
}
