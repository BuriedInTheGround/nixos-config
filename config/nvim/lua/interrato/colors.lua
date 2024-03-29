local M = {}

-- Link colors for nvim-cmp
local link_cmp_colors = function()
  vim.cmd [[
    hi! link CmpItemAbbrDeprecated LspDiagnosticsUnderlineError
    hi! link CmpItemAbbrMatchFuzzy Italic
    hi! link CmpItemKind Number
    hi! link CmpItemMenu LspCodeLens
  ]]
end

M.monokai = function()
  vim.cmd [[ syntax on ]]
  vim.g.airline_theme = "molokai"
  vim.g.monokai_term_italic = 1
  vim.env.BAT_THEME = "Monokai Extended"
  vim.cmd [[ colorscheme monokai ]]
  link_cmp_colors()
end

M.nord = function()
  vim.cmd [[ syntax on ]]
  vim.g.airline_theme = "nord"
  vim.g.nord_cursor_line_number_background = 1
  vim.g.nord_italic = 1
  vim.g.nord_italic_comments = 1
  vim.env.BAT_THEME = "Nord"
  vim.cmd [[ colorscheme nord ]]
  vim.cmd [[ hi Normal guibg=NONE ]] -- True transparent background
  link_cmp_colors()
end

return M
