-- https://github.com/sveltejs/language-tools/tree/master/packages/language-server
-- Recommended project typescript plugin: https://github.com/sveltejs/language-tools/tree/master/packages/typescript-plugin#usage

-- require("lspconfig").svelte.setup({
--   capabilities = require("plugins.lsp.capabilities"),
--   on_attach = function(client)
--     vim.api.nvim_create_autocmd("BufWritePost", {
--       pattern = { "*.js", "*.ts" },
--       group = vim.api.nvim_create_augroup("svelte_ondidchangetsorjsfile", { clear = true }),
--       callback = function(ctx) client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match }) end,
--     })
--   end,
--   settings = {
--     svelte = {
--       plugin = {
--         svelte = {
--           format = {
--             enable = false,
--           },
--         },
--       },
--     },
--   },
-- })

return {
  capabilities = require("plugins.lsp.capabilities"),
  on_attach = function(client)
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.js", "*.ts" },
      group = vim.api.nvim_create_augroup("svelte_ondidchangetsorjsfile", { clear = true }),
      callback = function(ctx)
        client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
      end,
    })
  end,
  root_dir = require("lspconfig.util").root_pattern(
    "package.json",
    "package-lock.json",
    "pnpm-lock.yaml",
    "tsconfig.json",
    "jsconfig.json",
    ".git"
  ),
  -- settings = {
  --   svelte = {
  --     plugin = {
  --       svelte = {
  --         format = {
  --           enable = false,
  --         },
  --       },
  --     },
  --   },
  -- },
}
