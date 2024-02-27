-- https://github.com/sumneko/lua-language-server
require("lspconfig").lua_ls.setup({
  capabilities = require("plugins.lsp.capabilities"),
  settings = {
    Lua = {
      diagnostics = {
        globals = {
          "vim",
          "use",
        },
      },
      hint = {
        enable = true,
      },
      format = {
        enable = false,
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
})
