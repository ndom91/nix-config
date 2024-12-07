-- https://github.com/sumneko/lua-language-server
-- require("lspconfig").lua_ls.setup({
--   capabilities = require("plugins.lsp.capabilities"),
--   settings = {
--     Lua = {
--       diagnostics = {
--         disable = { "missing-fields" },
--         --   globals = {
--         --     "vim",
--         --     "use",
--         --   },
--         -- },
--         -- hint = {
--         --   enable = true,
--         -- },
--         -- format = {
--         --   enable = false,
--       },
--       workspace = {
--         checkThirdParty = false,
--       },
--       unbalanced = {
--         missingFields = false,
--       },
--     },
--   },
-- })
return {
  -- capabilities = require("plugins.lsp.capabilities"),
  settings = {
    Lua = {
      diagnostics = {
        disable = { "missing-fields" },
        --   globals = {
        --     "vim",
        --     "use",
        --   },
        -- },
        -- hint = {
        --   enable = true,
        -- },
        -- format = {
        --   enable = false,
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
}
