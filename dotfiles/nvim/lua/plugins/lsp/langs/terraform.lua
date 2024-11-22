-- https://github.com/hashicorp/terraform-ls
require("lspconfig").terraform_ls.setup({
  capabilities = require("plugins.lsp.capabilities"),
})
