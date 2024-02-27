return {
  "nvimdev/lspsaga.nvim",
  enabled = true,
  event = "LspAttach",
  keys = {
    { "<leader>sf", "<cmd>Lspsaga finder<CR>", desc = "[S]ymbol [F]inder" },
    { "<leader>tt", "<cmd>Lspsaga term_toggle<CR>", desc = "[T]erm [T]oggle" },
  },
  opts = {
    symbol_in_winbar = {
      enable = false,
    },
    lightbulb = {
      enable = true,
      enable_in_insert = false,
      sign = true,
      sign_priority = 40,
      virtual_text = false,
    },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}
