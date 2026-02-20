return {
  "nvim-lualine/lualine.nvim",
  enabled = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "AndreM222/copilot-lualine",
  },
  config = function()
    local function show_macro_recording()
      local recording_register = vim.fn.reg_recording()
      if recording_register == "" then
        return ""
      else
        return "Recording @" .. recording_register
      end
    end
    vim.api.nvim_create_autocmd("RecordingEnter", {
      callback = function()
        require("lualine").refresh({
          place = { "statusline" },
        })
      end,
    })

    vim.api.nvim_create_autocmd("RecordingLeave", {
      callback = function()
        -- This is going to seem really weird!
        -- Instead of just calling refresh we need to wait a moment because of the nature of
        -- `vim.fn.reg_recording`. If we tell lualine to refresh right now it actually will
        -- still show a recording occuring because `vim.fn.reg_recording` hasn't emptied yet.
        -- So what we need to do is wait a tiny amount of time (in this instance 50 ms) to
        -- ensure `vim.fn.reg_recording` is purged before asking lualine to refresh.
        vim.defer_fn(function()
          require("lualine").refresh({
            place = { "statusline" },
          })
        end, 50)
      end,
    })
    require("lualine").setup({
      options = {
        theme = "catppuccin",
        globalstatus = true,
        -- Old
        -- component_separators = { left = "", right = "" },
        -- section_separators = { left = "", right = "" },
        -- Current
        -- component_separators = { left = "╱", right = "╱" },
        -- section_separators = { left = "", right = "" },
        --
        component_separators = "",
        section_separators = "",
        disabled_filetypes = {
          winbar = { "neo-tree", "packer", "help", "toggleterm" },
        },
      },
      sections = {
        lualine_a = {
          "mode",
        },
        lualine_b = {
          {
            "filename",
            file_status = true, -- Displays file status (readonly status, modified status)
            newfile_status = false, -- Display new file status (new file means no write after created)
            path = 1, -- 0: Just the filename
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory
            shorting_target = 40, -- Shortens path to leave 40 spaces in the window
            symbols = {
              modified = "●", -- Text to show when the file is modified.
              readonly = "RO", -- Text to show when the file is non-modifiable or readonly.
              unnamed = "[No Name]", -- Text to show for unnamed buffers.
              newfile = "[New]", -- Text to show for newly created file before first write
            },
          },
        },
        lualine_c = {
          -- { separator },
          { "b:gitsigns_head", icon = "" },
          {
            "diff",
            colored = true, -- Displays a colored diff status if set to true
            symbols = { added = "+", modified = "~", removed = "-" }, -- Changes the symbols used by the diff.
          },
          {
            "macro-recording",
            fmt = show_macro_recording,
          },
          {
            require("noice").api.status.search.get,
            cond = require("noice").api.status.search.has,
            color = { fg = "fg" },
          },
        },
        lualine_x = {
          {
            function()
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              if #clients == 0 then
                return " " .. #clients
              end
              return "  "
                .. table.concat(
                  vim.tbl_map(function(client)
                    return client.name
                  end, clients),
                  ", "
                )
            end,
          },
        },
        lualine_y = {
          -- "progress",
          {
            "copilot",
            show_colors = true,
            padding = 2,
            symbols = {
              spinners = require("copilot-lualine.spinners").dots,
            },
          },
          {
            "diagnostics",
            padding = 0,
            sources = { "nvim_diagnostic" },
            sections = { "error", "warn" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
            -- symbols = { error = "E", warn = "W", info = "I", hint = "H" },
            colored = false, -- Displays diagnostics status in color if set to true.
            update_in_insert = false, -- Update diagnostics in insert mode.
            always_visible = false, -- Show diagnostics even if there are none.
          },
          {
            "location",
            padding = 1,
          },
        },
        lualine_z = {
          -- "fileformat",
          {
            "filetype",
            colored = false,
            icon_only = false,
            icons_enabled = true,
            icon = { align = "right" },
            padding = 2,
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = {
        "neo-tree",
        "mason",
        "man",
        "nvim-dap-ui",
        "toggleterm",
        "trouble",
        "lazy",
      },
    })
  end,
}
