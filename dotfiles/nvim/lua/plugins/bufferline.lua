return {
  "akinsho/bufferline.nvim",
  event = "VimEnter",
  keys = {
    {
      "<c-x>",
      "<cmd>bd<CR>",
      desc = "Bufferline Close",
      silent = true,
    },
    { "<Tab>", ":bnext<CR>", silent = true },
    { "<S-Tab>", ":bprev<CR>", silent = true },
  },
  opts = {
    options = {
      themable = true,
      indicator = { icon = "▎" },
      buffer_close_icon = "",
      modified_icon = "●",
      close_icon = "",
      left_trunc_marker = "",
      right_trunc_marker = "",
      right_mouse_command = "bdelete! %d",
      max_name_length = 25,
      truncate_names = true,
      tab_size = 25,
      diagnostics = false,
      offsets = {
        {
          filetype = "neo-tree",
          text = function()
            return vim.fn.getcwd()
          end,
          text_align = "center",
          separator = false,
        },
      },
      color_icons = true,
      show_buffer_icons = true,
      show_buffer_close_icons = false,
      show_close_icon = false,
      show_tab_indicators = false,
      separator_style = { "", "" },
      enforce_regular_tabs = true,
      always_show_bufferline = true,
    },
  },
}
