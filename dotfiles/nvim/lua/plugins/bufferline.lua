local symbol_map = {
  error = "",
  warning = "",
  info = "",
  hint = "",
}

return {
  "akinsho/bufferline.nvim",
  version = "v4.*",
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
      max_name_length = 20,
      max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
      truncate_names = true,
      tab_size = 18,
      diagnostics = false, -- "nvim_lsp",
      -- diagnostics_indicator = function(total_count, level, diagnostics_dict)
      --   local s = ""
      --   for kind, count in pairs(diagnostics_dict) do
      --     s = string.format("%s %s %d", s, symbol_map[kind], count)
      --   end
      --   return s
      -- end,
      offsets = {
        {
          filetype = "neo-tree",
          text = function() return vim.fn.getcwd() end,
          text_align = "center",
          separator = false,
        },
      },
      hover = {
        enabled = false,
        delay = 200,
        reveal = { "close" },
      },
      numbers = function(opts)
        -- Show harpoon index numbers in bufferline tabs
        local items = require("harpoon"):list().items
        for i = 1, #items do
          local fn = items[i].value
          local fullpath = vim.fn.fnamemodify(fn, ":p")
          local bufPathFromId = vim.fn.fnamemodify(vim.fn.bufname(opts.id), ":p")
          if fullpath == bufPathFromId then return i end
        end
      end,
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
