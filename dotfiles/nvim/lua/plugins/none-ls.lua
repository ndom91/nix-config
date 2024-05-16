-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md

local read_package_json = require("utils").read_package_json

return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "mason.nvim",
    "nvimtools/none-ls-extras.nvim",
  },
  opts = function(_, opts)
    local nls = require("null-ls")

    -- opts.debug = true

    opts.diagnostics_format = "[#{c}] #{m} (#{s})"
    opts.sources = vim.list_extend(opts.sources or {}, {
      -- nls.builtins.formatting.deno_fmt,
      nls.builtins.formatting.prettierd.with({
        filetypes = {
          -- "svelte",
          -- "javascript",
          -- "javascriptreact",
          -- "typescript",
          -- "typescriptreact",
          -- "tsx",
          -- "vue",
          "json",
          "yaml",
          "markdown",
          "jsx",
          "html",
          "css",
          "graphql",
          "toml",
        },
        -- condition = function(_utils)
        --   local package_json = read_package_json()
        --   if not package_json then return true end
        --   if package_json.devDependencies and package_json.devDependencies["eslint-config-prettier"] then
        --     return false
        --   end
        --   return true
        -- end,
      }),
      -- nls.builtins.formatting.biome,
      -- nls.builtins.formatting.eslint_d.with({
      require("none-ls.formatting.eslint_d").with({
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
      }),
      nls.builtins.formatting.stylua,
      nls.builtins.formatting.rustywind, -- Organise Tailwind Classes
      -- nls.builtins.formatting.lua_format,
      nls.builtins.formatting.shfmt.with({
        extra_args = { "-i", "2", "-ci" },
      }),
      -- require("none-ls.diagnostics.eslint_d").with({
      --   filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
      -- }),
      -- nls.builtins.diagnostics.eslint_d,
      -- nls.builtins.diagnostics.shellcheck,
      -- nls.builtins.diagnostics.tsc,
      -- nls.builtins.diagnostics.deno_lint,
      -- require "typescript.extensions.null-ls.code-actions",
      -- require("none-ls.code_actions.eslint_d"),
      -- nls.builtins.code_actions.eslint_d,
      -- nls.builtins.code_actions.shellcheck,
    })
  end,
}
