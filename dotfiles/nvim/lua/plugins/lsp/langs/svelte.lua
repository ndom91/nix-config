-- https://github.com/sveltejs/language-tools/tree/master/packages/language-server
-- Recommended project typescript plugin: https://github.com/sveltejs/language-tools/tree/master/packages/typescript-plugin#usage

require("lspconfig").svelte.setup({
  capabilities = require("plugins.lsp.capabilities"),
  settings = {
    svelte = {
      plugin = {
        svelte = {
          -- defaultScriptLanguage = "typescript",
          --
          format = {
            enable = false,
          },
        },
      },
    },
  },
})
