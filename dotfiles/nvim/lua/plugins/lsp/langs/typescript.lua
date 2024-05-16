-- https://github.com/theia-ide/typescript-language-server
local is_npm_package_installed = require("utils").is_npm_package_installed

local have_vue = is_npm_package_installed("vue")

if not have_vue then
  require("lspconfig").tsserver.setup({
    capabilities = require("plugins.lsp.capabilities"),
    on_attach = function(client, bufnr)
      client.server_capabilities.document_formatting = false
      -- null-ls messes with formatexpr for some reason, which messes up `gq`
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1131
      vim.bo[bufnr].formatexpr = nil
    end,
    handlers = {
      -- Go right to first result if there is more than 1
      ["textDocument/definition"] = function(err, result, ctx, ...)
        if #result > 1 then
          result = { result[1] }
          return vim.lsp.handlers["textDocument/definition"](err, result, ctx, ...)
        end

        return vim.lsp.handlers["textDocument/definition"](err, result, ctx, ...)
      end,
    },
    -- root_dir = require("lspconfig/util").root_pattern("tsconfig.json"),
    settings = {
      documentFormatting = false,
      -- taken from https://github.com/typescript-language-server/typescript-language-server#workspacedidchangeconfiguration
      javascript = {
        inlayHints = false,
        -- inlayHints = {
        --   includeInlayEnumMemberValueHints = true,
        --   includeInlayFunctionLikeReturnTypeHints = true,
        --   includeInlayFunctionParameterTypeHints = true,
        --   includeInlayParameterNameHints = "all",
        --   includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        --   includeInlayPropertyDeclarationTypeHints = true,
        --   includeInlayVariableTypeHints = true,
        -- },
      },
      typescript = {
        inlayHints = false,
        -- inlayHints = {
        --   includeInlayEnumMemberValueHints = true,
        --   includeInlayFunctionLikeReturnTypeHints = true,
        --   includeInlayFunctionParameterTypeHints = true,
        --   includeInlayParameterNameHints = "all",
        --   includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        --   includeInlayPropertyDeclarationTypeHints = true,
        --   includeInlayVariableTypeHints = true,
        -- },
      },
    },
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    root_dir = require("lspconfig.util").root_pattern(
      "package.json",
      "package-lock.json",
      "tsconfig.json",
      "jsconfig.json",
      ".git"
    ),
    single_file_support = true,
  })
end
