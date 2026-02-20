return {
  init_options = {
    preferences = {
      -- Import suggestions
      includePackageJsonAutoImports = "auto",
      importModuleSpecifierPreference = "project-relative",
      importModuleSpecifierEnding = "minimal",
      -- Completions
      includeCompletionsForModuleExports = true,
      includeCompletionsForImportStatements = true,
      includeCompletionsWithSnippetText = true,
      includeAutomaticOptionalChainCompletions = true,
      -- General
      allowIncompleteCompletions = true,
      displayPartsForJSDoc = true,
    },
    hostInfo = "neovim",
  },
  settings = {
    documentFormatting = false,
    javascript = {
      inlayHints = { enabled = false },
      preferences = {
        importModuleSpecifierPreference = "project-relative",
        includePackageJsonAutoImports = "auto",
      },
      suggest = {
        completeFunctionCalls = true,
        includeAutomaticOptionalChainCompletions = true,
        autoImports = true,
      },
      updateImportsOnFileMove = { enabled = "always" },
    },
    typescript = {
      inlayHints = { enabled = false },
      preferences = {
        importModuleSpecifierPreference = "project-relative",
        includePackageJsonAutoImports = "auto",
      },
      suggest = {
        completeFunctionCalls = true,
        includeAutomaticOptionalChainCompletions = true,
        autoImports = true,
      },
      updateImportsOnFileMove = { enabled = "always" },
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
}
