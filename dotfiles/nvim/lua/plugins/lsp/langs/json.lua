-- https://github.com/vscode-langservers/vscode-json-languageserver
require("lspconfig").jsonls.setup {
  capabilities = require "plugins.lsp.capabilities",
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}
