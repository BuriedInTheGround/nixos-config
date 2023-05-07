local lsp = require "interrato.lsp"

require("lspconfig").lua_ls.setup {
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      }
    }
  }
}
