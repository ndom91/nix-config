-- https://github.com/Microsoft/vscode-eslint

require("lspconfig").eslint.setup({
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
    "svelte",
    "astro",
    "js",
  },
  -- codeAction = {
  --   disableRuleComment = {
  --     enable = true,
  --     location = "separateLine",
  --   },
  --   showDocumentation = {
  --     enable = true,
  --   },
  -- },
  -- codeActionOnSave = {
  --   enable = false,
  --   mode = "all",
  -- },
  -- experimental = {
  --   useFlatConfig = false,
  -- },
  format = false,
  nodePath = "",
  onIgnoredFiles = "off",
  packageManager = "pnpm",
  problems = {
    shortenToSingleLine = false,
  },
  quiet = false,
  -- run = "onType",
  -- useESLintClass = false,
  -- validate = "on",
  -- workingDirectory = {
  --   mode = "location",
  -- },
})
