-- Source: https://github.com/AstroNvim/AstroNvim/blob/main/lua/plugins/heirline.lua

return {
  "rebelot/heirline.nvim",
  event = "BufEnter",
  enabled = false,
  opts = function()
    local status = require "utils.status"
    return {
      opts = {
        disable_winbar_cb = function(args)
          return status.condition.buffer_matches({
            buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
            filetype = { "NvimTree", "neo%-tree", "dashboard", "Outline", "aerial" },
          }, args.buf)
        end,
      },
      statusline = { -- statusline
        hl = { fg = "fg", bg = "bg" },
        status.component.mode(),
        status.component.git_branch(),
        status.component.file_info { filetype = {}, filename = false, file_modified = false },
        status.component.git_diff(),
        status.component.diagnostics(),
        status.component.fill(),
        status.component.cmd_info(),
        status.component.fill(),
        status.component.lsp(),
        status.component.treesitter(),
        status.component.nav(),
        status.component.mode { surround = { separator = "right" } },
      },
      -- winbar = { -- winbar
      --   init = function(self)
      --     self.bufnr = vim.api.nvim_get_current_buf()
      --   end,
      --   fallthrough = false,
      --   {
      --     condition = function()
      --       return not status.condition.is_active()
      --     end,
      --     status.component.separated_path(),
      --     status.component.file_info({
      --       file_icon = { hl = status.hl.file_icon("winbar"), padding = { left = 0 } },
      --       file_modified = false,
      --       file_read_only = false,
      --       hl = status.hl.get_attributes("winbarnc", true),
      --       surround = false,
      --       update = "BufEnter",
      --     }),
      --   },
      --   status.component.breadcrumbs({ hl = status.hl.get_attributes("winbar", true) }),
      -- },
      -- statuscolumn = vim.fn.has("nvim-0.9") == 1 and {
      --   status.component.foldcolumn(),
      --   status.component.fill(),
      --   status.component.numbercolumn(),
      --   status.component.signcolumn(),
      -- } or nil,
    }
  end,
}
