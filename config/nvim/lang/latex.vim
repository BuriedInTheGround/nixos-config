lua << EOF
require'lspconfig'.texlab.setup {
    on_attach = on_attach,
    capabilities = capabilities,
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
                onSave = false
            },
        }
    }
}
EOF
