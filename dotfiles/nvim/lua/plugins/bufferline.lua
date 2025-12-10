return {
  "akinsho/bufferline.nvim",
  event = "VimEnter",
  dependencies = { "catppuccin/nvim" },
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
  config = function()
    local colors = require("catppuccin.palettes").get_palette("mocha")

    require("bufferline").setup({
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
        color_icons = false,
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = false,
        separator_style = { "", "" },
        enforce_regular_tabs = true,
        always_show_bufferline = true,
      },
      highlights = {
        buffer_selected = {
          fg = colors.text,
          bg = colors.surface1,
          bold = true,
          italic = false,
        },
        indicator_selected = {
          fg = colors.lavender,
          bg = colors.surface1,
        },
        background = {
          fg = colors.overlay0,
          -- bg = colors.mantle,
        },
        buffer_visible = {
          fg = colors.text,
          bg = colors.mantle,
        },
        close_button = {
          fg = colors.overlay0,
          bg = colors.mantle,
        },
        close_button_selected = {
          fg = colors.red,
          bg = colors.surface1,
        },
        -- fill = {
        --   bg = colors.base,
        -- },
      },
    })
  end,
}
