lua << EOF
require'lspconfig'.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "gopls", "-remote=auto" },
    settings = {
        gopls = {
            gofumpt = true,
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    },
    flags = {
        debounce_text_changes = 150,
    }
}
EOF
