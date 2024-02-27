-- https://github.com/hrsh7th/vscode-langservers-extracted
local capabilities = require("plugins.lsp.capabilities")
capabilities.textDocument.completion.completionItem.snippetSupport = true

require("lspconfig").html.setup({
  capabilities = capabilities,
})
