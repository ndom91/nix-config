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
      enabled = vim.fn.has("nvim-0.10.0") == 1,
    },
    {
      "nvim-treesitter/nvim-treesitter-context", -- Show scope context when scrolling
      opts = {
        max_lines = 4,
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
    highlight = {
      enable = true,
      disable = function(lang, buf)
        local max_filesize = 500 * 1024 -- 500 KB
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
    },
    parser_install_dir = nil,
  },
}
