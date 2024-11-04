-- https://github.com/hrsh7th/vscode-langservers-extracted
local capabilities = require("plugins.lsp.capabilities")

require("lspconfig").rnix.setup({
  capabilities = capabilities,
})
