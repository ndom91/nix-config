return {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  build = ":TSUpdate",
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
  dependencies = {
    "IndianBoy42/tree-sitter-just", -- Just file syntax highlighting
    "windwp/nvim-ts-autotag", -- Treesitter autoclose and autorename HTML tags
    {
      "folke/ts-comments.nvim",
      opts = {},
      event = "VeryLazy",
      enabled = true,
    },
    {
      "nvim-treesitter/nvim-treesitter-context", -- Show scope context when scrolling
      opts = {
        max_lines = 4,
        on_attach = function(buf)
          return vim.bo[buf].filetype ~= "markdown" -- nvim 0.13 treesitter range() bug
        end,
      },
    },
    { "fei6409/log-highlight.nvim", event = "BufRead *.log", opts = {} },
  },
  opts = {
    -- auto_install = false,
    ensure_installed = {
      "astro",
      "bash",
      -- "comment", -- Maybe takes too much CPU w/ tsserver?
      "css",
      "csv",
      "diff",
      "dockerfile",
      "git_config",
      "gitcommit",
      "gitignore",
      "go",
      "graphql",
      "hcl",
      "html",
      "http",
      "javascript",
      "jq",
      "jsdoc",
      "json",
      "json5",
      "jsonc",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "nix",
      "php",
      "prisma",
      "python",
      "regex",
      "rust",
      "scss",
      "sql",
      "ssh_config",
      "svelte",
      "terraform",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "vue",
      "yaml",
    },
    highlight = { enable = false },
    parser_install_dir = nil,
  },
}
