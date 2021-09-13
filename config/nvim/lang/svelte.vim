lua << EOF
require'lspconfig'.svelte.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
        debounce_text_changes = 150,
    }
}
EOF
