local cmd = vim.cmd

-- highlight yank for a brief second for visual feedback
cmd "autocmd! TextYankPost * lua vim.highlight.on_yank { on_visual = false }"

-- Set .mdx files as 'tsx'
cmd "autocmd BufNewFile,BufRead *.mdx set filetype=tsx"

-- nvim 0.7.0+ lua native autocmds? (TJdev - https://www.youtube.com/watch?v=ekMIIAqTZ34
-- cmd "autocmd! CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })"

-- lsp-zero Format onSave
-- cmd "autocmd! BufWritePost * LspZeroFormat"

cmd "autocmd FileType markdown setlocal textwidth=80"
