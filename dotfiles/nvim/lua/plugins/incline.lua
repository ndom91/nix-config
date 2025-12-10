-- Buffer decoration to show filename in top-right floating indicator as well as
-- any LSP warnings/errors and git diff info.
return {
  "b0o/incline.nvim",
  enabled = false,
  opts = {
    window = {
      padding = 1,
    },
    render = function(props)
      local devicons = require("nvim-web-devicons")
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
      if filename == "" then
        filename = "[No Name]"
      end
      local ft_icon, ft_color = devicons.get_icon_color(filename)

      local function get_git_diff()
        local icons = { added = "", changed = "", removed = "" }
        local signs = vim.b[props.buf].gitsigns_status_dict
        local labels = {}
        if signs == nil then
          return labels
        end
        for name, icon in pairs(icons) do
          local count = signs[name]
          if count and tonumber(count) and count > 0 then
            local group_name = "Diff" .. name:gsub("^%l", string.upper)
            table.insert(labels, { icon .. count .. " ", group = group_name })
          end
        end
        if #labels > 0 then
          table.insert(labels, { " " })
        end
        return labels
      end

      local function get_diagnostic_label()
        local icons = { error = "", warn = "", info = "", hint = "" }
        local label = {}

        for severity, icon in pairs(icons) do
          local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
          if n > 0 then
            table.insert(label, { icon .. n .. " ", group = "DiagnosticSign" .. severity })
          end
        end
        if #label > 0 then
          table.insert(label, { " " })
        end
        return label
      end

      return {
        { get_diagnostic_label() },
        { get_git_diff() },
        { (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" },
        { filename .. " ", gui = vim.bo[props.buf].modified and "bold,italic" or "bold" },
        -- { "┊  " .. vim.api.nvim_win_get_number(props.win), group = "DevIconWindows" },
        -- guibg = "#44406e",
      }
    end,
  },
  event = "VeryLazy",
}
