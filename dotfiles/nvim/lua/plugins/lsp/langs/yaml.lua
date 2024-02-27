-- https://github.com/vscode-langservers/vscode-json-languageserver
require("lspconfig").yamlls.setup {
  capabilities = require "plugins.lsp.capabilities",
  settings = {
    yaml = {
      schemaStore = {
        url = "https://www.schemastore.org/api/json/catalog.json",
        enable = true,
      },
    },
  },
}
