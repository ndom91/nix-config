return {
  cmd = { "tsgo", "lsp", "--stdio" },
  cmd_env = {
    GOMEMLIMIT = "4GiB",
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = {
    "tsconfig.json",
    "jsconfig.json",
    "package.json",
    ".git",
  },
  single_file_support = true,
}
