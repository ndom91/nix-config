return {
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
