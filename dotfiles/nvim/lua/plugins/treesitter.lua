return {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  build = ":TSUpdate",
  -- event = { "LazyFile", "VeryLazy" },
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      -- opts = {
      --   enable_autocmd = false,
      -- },
    },
    {
      "nvim-treesitter/nvim-treesitter-context",
      opts = {
        max_lines = 5,
      },
    },
    "windwp/nvim-ts-autotag",
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      opts = {
        enable_check_bracket_line = false,
        ignored_next_char = '[%w%.%"]', -- will ignore alphanumeric and `.` symbol
      },
    },
  },
  ---@type TSConfig
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    highlight = { enable = true },
    playground = {
      enable = false,
      disable = {},
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
    },
    autopairs = {
      enable = true,
      check_ts = true,
      ts_config = {
        javascript = { "template_string" },
      },
    },
    autotag = {
      enable = true,
      enable_rename = true,
      enable_close = true,
      enable_close_on_slash = false,
    },
    indent = { enable = true },
    sync_install = false,
    auto_install = false,
    -- matchup = {
    --   enable = true,
    -- },
    -- refactor = {
    --   highlight_definitions = { enable = true },
    --   highlight_current_scope = { enable = false },
    --   smart_rename = {
    --     enable = true,
    --     keymaps = {
    --       -- mapping to rename reference under cursor
    --       -- smart_rename = "grr"
    --     },
    --   },
    --   navigation = {
    --     enable = false,
    --     keymaps = {
    --       -- goto_definition = "gnd", -- mapping to go to definition of symbol under cursor
    --       -- list_definitions = "gnD" -- mapping to list all definitions in current file
    --     },
    --   },
    -- },
    -- rainbow = { enable = true, extended_mode = true, max_file_lines = nil },
    -- context = {
    --   separator = "⎽",
    -- },
    -- parser_install_dir = "", -- TODO: Nix TSWithGrammars install path
    ensure_installed = {
      "astro",
      "bash",
      "comment", -- Maybe takes too much CPU w/ tsserver?
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
  },
  ---@param opts TSConfig
  config = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      ---@type table<string, boolean>
      local added = {}
      opts.ensure_installed = vim.tbl_filter(function(lang)
        if added[lang] then return false end
        added[lang] = true
        return true
      end, opts.ensure_installed)
    end
    require("nvim-treesitter.configs").setup(opts)
  end,
}
