-- https://github.com/nix-community/rnix-lsp
require("lspconfig").rnix.setup({
  capabilities = require("plugins.lsp.capabilities"),
})
