-- https://github.com/hashicorp/terraform-ls
require("lspconfig").terraformls.setup({
  capabilities = require("plugins.lsp.capabilities"),
})
