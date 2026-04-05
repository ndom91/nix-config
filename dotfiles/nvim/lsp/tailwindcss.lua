-- Explicit vim.lsp.config call to override lspconfig's root_dir which
-- falls back to .git and then scans every CSS file looking for tailwind imports.
-- File-based configs (returned tables) get merged by rtp order, so lspconfig's
-- root_dir function wins over ours. vim.lsp.config() calls always take priority.
local tailwind_roots = {
  "tailwind.config.js",
  "tailwind.config.ts",
  "tailwind.config.cjs",
  "tailwind.config.mjs",
}
vim.lsp.config("tailwindcss", {
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    -- v3: explicit tailwind config file
    local match = vim.fs.find(tailwind_roots, { path = fname, upward = true })[1]
    if match then
      return on_dir(vim.fs.dirname(match))
    end
    -- v4: tailwindcss in package.json (no config file needed)
    local pkg = vim.fs.find("package.json", { path = fname, upward = true })[1]
    if pkg then
      local content = vim.fn.readfile(pkg)
      if table.concat(content):find("tailwindcss") then
        return on_dir(vim.fs.dirname(pkg))
      end
    end
    on_dir(nil)
  end,
})

return {
  root_markers = tailwind_roots,
  workspace_required = true,
  settings = {
    tailwindCSS = {
      includeLanguages = {
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
}
