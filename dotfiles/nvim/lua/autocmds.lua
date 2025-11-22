-- highlight yank for a brief second for visual feedback
vim.cmd("autocmd! TextYankPost * lua vim.highlight.on_yank { on_visual = false }")

-- Set .mdx files as 'tsx'
vim.cmd("autocmd BufNewFile,BufRead *.mdx set filetype=tsx")

vim.cmd("autocmd FileType markdown setlocal textwidth=80")

-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = nil
    end
  end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
})
