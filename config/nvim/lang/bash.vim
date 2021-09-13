lua << EOF
require'lspconfig'.bashls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
        debounce_text_changes = 150,
    }
}
EOF
