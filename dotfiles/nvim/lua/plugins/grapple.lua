-- Harpoon alternative. Quick jump file list
return {
  "cbochs/grapple.nvim",
  dependencies = {
    { "nvim-tree/nvim-web-devicons", lazy = true },
  },
  opts = {
    scope = "git_branch",
  },
  event = { "BufReadPost", "BufNewFile" },
  cmd = "Grapple",
  keys = {
    { "<leader>a", "<cmd>Grapple toggle<cr>", desc = "Tag a file" },
    { "<leader>h", "<cmd>Grapple toggle_tags<cr>", desc = "Toggle tags menu" },
    { "<c-n>", "<cmd>Grapple cycle_tags next<cr>", desc = "Go to next tag" },
    { "<c-p>", "<cmd>Grapple cycle_tags prev<cr>", desc = "Go to previous tag" },
  },
  win_opts = {
    width = 80,
    height = 12,
    row = 0.5,
    col = 0.5,

    relative = "editor",
    border = "none",
    focusable = false,
    style = "minimal",

    title = "Grapple", -- fallback title for Grapple windows
    title_pos = "center",
    title_padding = " ", -- custom: adds padding around window title

    footer_pos = "",
  },
}
