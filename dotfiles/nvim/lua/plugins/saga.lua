return {
  "nvimdev/lspsaga.nvim",
  enabled = false,
  event = "LspAttach",
  keys = {
    { "<leader>tt", "<cmd>Lspsaga term_toggle<CR>", desc = "[T]erm [T]oggle" },
  },
  opts = {
    symbol_in_winbar = {
      enable = false,
    },
    peek_definition = {
      enable = true,
    },
    lightbulb = {
      enable = true,
      enable_in_insert = false,
      sign = true,
      sign_priority = 40,
      virtual_text = false,
    },
    code_action = {
      extend_gitsigns = true,
    },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}
