return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    -- "nvim-treesitter/playground",
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
  config = function()
    require("nvim-treesitter.configs").setup({
      highlight = { enable = true },
      playground = {
        enable = false,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
      },
      autopairs = {
        enable = true,
      },
      autotag = {
        enable = true,
        enable_rename = true,
        enable_close = true,
        enable_close_on_slash = true,
      },
      matchup = {
        enable = true,
      },
      refactor = {
        highlight_definitions = { enable = true },
        highlight_current_scope = { enable = false },
        smart_rename = {
          enable = true,
          keymaps = {
            -- mapping to rename reference under cursor
            -- smart_rename = "grr"
          },
        },
        navigation = {
          enable = false,
          keymaps = {
            -- goto_definition = "gnd", -- mapping to go to definition of symbol under cursor
            -- list_definitions = "gnD" -- mapping to list all definitions in current file
          },
        },
      },
      indent = { enable = true },
      rainbow = { enable = true, extended_mode = true, max_file_lines = nil },
      context = {
        separator = "⎽",
      },
      sync_install = false,
      ensure_installed = "all",
    })
  end,
}
