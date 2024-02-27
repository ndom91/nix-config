return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    lsp = {
      progress = {
        enabled = false,
      },
      signature = {
        enabled = false,
      },
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = false,
      },
    },
    notify = {
      -- Noice can be used as `vim.notify` so you can route any notification like other messages
      -- Notification messages have their level and other properties set.
      -- event is always "notify" and kind can be any log level as a string
      -- The default routes will forward notifications to nvim-notify
      -- Benefit of using Noice for this is the routing and consistent history view
      enabled = true,
      view = "notify",
    },
    messages = {
      enabled = true, -- enables the Noice messages UI
      view_search = false,
    },
    -- cmdline = {
    --   enabled = true, -- enables the Noice cmdline UI
    --   -- view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
    --   title = "",
    -- },
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      lsp_doc_border = true, -- add a border to hover docs and signature help
      -- long_message_to_split = true, -- long messages will be sent to a split
      -- inc_rename = false,            -- enables an input dialog for inc-rename.nvim
    },
    -- commands = {
    --   history = {
    --     view = "popup",
    --   }
    -- },
    views = {
      cmdline_popup = {
        position = {
          row = "50%",
        },
        border = {
          style = "none",
          padding = { 1, 2 },
        },
        win_options = {
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        },
      },
      popup = {
        border = {
          padding = { 1, 2 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
          foldenable = false,
          cursorline = true,
          cursorlineopt = "line",
        },
      },
      popupmenu = {
        relative = "editor",
        border = {
          padding = { 1, 2 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
          -- winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        },
      },
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          find = "E486: Pattern not found",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          find = "No information available",
        },
        opts = { skip = true },
      },
      {
        view = "popup",
        filter = { event = "msg_show", min_height = 5 },
      },
    },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
}
