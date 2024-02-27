return {
  "akinsho/toggleterm.nvim", -- terminal splits / floating windows
  enabled = false,
  config = function()
    local Terminal = require("toggleterm.terminal").Terminal

    _G.lazygit = Terminal:new({
      cmd = "lazygit",
      hidden = true,
      direction = "float",
      dir = "git_dir",
      size = 40,
      float_opts = {
        border = "double",
        width = 160,
        height = 60,
        winblend = 0,
        highlights = { border = "Special", background = "Normal" },
      },
    })
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "horizontal" then
          return 20
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<leader>tt]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 0,
      start_in_insert = true,
      persist_size = true,
      direction = "horizontal",
      close_on_exit = true,
      float_opts = {
        border = "curved",
        width = 20,
        height = 20,
        winblend = 3,
        highlights = { border = "Special", background = "Normal" },
      },
    })

    -- See 'utils/term.lua' for lazygit floating term
    -- vim.api.nvim_set_keymap("n", "<leader>lg",
    --   -- "<cmd>lua require('utils.term')._lazygit_toggle()<CR>",
    --   "<cmd>lua lazygit:toggle()<CR>",
    --   { noremap = true, silent = true })
  end,
}
