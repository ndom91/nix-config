local symbol_map = {
  error = "",
  warning = "",
  info = "",
  hint = "",
}

local path = require("plenary.path")

return {
  "akinsho/bufferline.nvim",
  -- "Theyashsawarkar/bufferline.nvim",
  -- version = "v4.*",
  -- branch = "v4.5.2",
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
      -- name_formatter = function(buf)
      --   if buf.bufnr == vim.api.nvim_get_current_buf() then
      --     local name = vim.fn.expand("%:p")
      --     local shortened_name = vim.fn.pathshorten(path:new(name):make_relative(vim.fn.getcwd()), 2)
      --     if shortened_name:len() > 25 then return "..." .. string.sub(shortened_name, -50) end
      --     return shortened_name
      --   end
      --   return buf.name
      -- end,
      -- name_formatter = function(buf)
      --   buf.bufnr == vim.api.nvim_get_current_buf()
      --   -- Hack to get the filepath relative to cwd
      --   local shortened_name = vim.fn.pathshorten(path:new(buf.path):make_relative(vim.fn.getcwd()), 2)
      --   if shortened_name:len() > 25 then return string.sub(shortened_name, -25) end
      --   -- return path:new(buf.path):make_relative(vim.fn.getcwd())
      -- end,
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
