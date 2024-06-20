require("lspconfig").rust_analyzer.setup({
  capabilities = require("plugins.lsp.capabilities"),
  settings = {
    ["rust-analyzer"] = {
      -- server = {
      --     -- path = '/Users/feniljain/Projects/rust-projects/rust-analyzer/fix_enum_completion/target/release/rust-analyzer',
      --     -- path = '~/Projects/rust-projects/rust-analyzer/fix_enum_completion/target/release/rust-analyzer',
      -- },
      checkOnSave = {
        command = "clippy",
      },
      -- checkOnSave = true,
      -- trace = {
      --     server = "verbose",
      --     extension = true,
      -- },
      -- rustc = {
      --   source = "discover",
      -- },
    },
  },
})
