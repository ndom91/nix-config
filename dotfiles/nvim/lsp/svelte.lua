return {
  on_attach = function(client)
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.js", "*.ts" },
      group = vim.api.nvim_create_augroup("svelte_ondidchangetsorjsfile", { clear = true }),
      callback = function(ctx)
        client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
      end,
    })
  end,
  root_markers = {
    "package.json",
    "package-lock.json",
    "pnpm-lock.yaml",
    "tsconfig.json",
    "jsconfig.json",
    ".git",
  },
}
