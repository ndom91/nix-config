return {
  "nvim-neotest/neotest",
  enabled = true,
  keys = {
    { "<leader>tts", function() require("neotest").summary.toggle() end, desc = "[T]oggle Neo[t]e[s]t", silent = true },
    {
      "<leader>tto",
      function() require("neotest").output_panel.toggle() end,
      desc = "[T]oggle [T]est [O]output Panel",
      silent = true,
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "marilari88/neotest-vitest",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-vitest"),
      },
    })
  end,
}
