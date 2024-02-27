-- https://github.com/tailwindlabs/tailwindcss-intellisense

require("lspconfig").tailwindcss.setup({
  capabilities = require("plugins.lsp.capabilities"),
  root_dir = require("lspconfig/util").root_pattern("tailwind.config.js", "tailwind.config.ts", "tailwind.config.cjs"),
  settings = {
    tailwindCSS = {
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidConfigPath = "error",
        invalidScreen = "error",
        invalidTailwindDirective = "error",
        recommendedVariantOrder = "warning",
        unusedClass = "warning",
      },
      experimental = {
        classRegex = {
          'class="([^"]*)',
          'className="([^"]*)',

          "tw`([^`]*)",
          'tw="([^"]*)',
          'tw={"([^"}]*)',
          "tw\\.\\w+`([^`]*)",
          "tw\\(.*?\\)`([^`]*)",

          "cn`([^`]*)",
          'cn="([^"]*)',
          'cn={"([^"}]*)',
          "cn\\.\\w+`([^`]*)",
          "cn\\(.*?\\)`([^`]*)",

          { "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
          { "classnames\\(([^)]*)\\)", "'([^']*)'" },
          { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          "cva\\(([^)(]*(?:\\([^)(]*(?:\\([^)(]*(?:\\([^)(]*\\)[^)(]*)*\\)[^)(]*)*\\)[^)(]*)*)\\)",
          "'([^']*)'",
        },
      },
      validate = true,
    },
  },
  filetypes = {
    "astro",
    "astro-markdown",
    "html",
    "markdown",
    "mdx",
    "css",
    "less",
    "postcss",
    "sass",
    "scss",
    "javascript",
    "javascriptreact",
    "tsx",
    "jsx",
    "typescript",
    "typescriptreact",
    "vue",
    "svelte",
  },
})
