-- https://github.com/vscode-langservers/vscode-json-languageserver
return {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}
