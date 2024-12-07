-- https://github.com/hrsh7th/vscode-langservers-extracted
-- css-lsp from mason-lspconfig uses: https://github.com/microsoft/vscode-css-languageservice
-- local capabilities = require("plugins.lsp.capabilities")
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
--
-- require("lspconfig").cssls.setup({
--   capabilities = require("plugins.lsp.capabilities"),
--   settings = {
--     css = {
--       format = {
--         spaceAroundSelectorSeparator = true,
--         -- enable = false,
--       },
--       lint = {
--         -- Do not warn for Tailwind's @apply rule
--         unknownAtRules = "ignore",
--       },
--     },
--   },
-- })
return {
  -- capabilities = require("plugins.lsp.capabilities"),
  settings = {
    css = {
      format = {
        spaceAroundSelectorSeparator = true,
        -- enable = false,
      },
      lint = {
        -- Do not warn for Tailwind's @apply rule
        unknownAtRules = "ignore",
      },
    },
  },
}
