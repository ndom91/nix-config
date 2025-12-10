return {
  "catppuccin/nvim",
  enabled = true,
  priority = 1000,
  lazy = false,
  name = "catppuccin",
  opts = {
    flavour = "mocha",
    transparent_background = true,
    term_colors = true,
    integration = {
      cmp = true,
      fidget = true,
      gitsigns = true,
      indent_blankline = {
        enabled = true,
        -- colored_indent_levels = false,
      },
      lsp_trouble = true,
      mason = true,
      mini = false,
      neotree = true,
      notify = true,
      noice = true,
      treesitter = true,
      treesitter_context = true,
    },
    custom_highlights = function(colors)
      return {
        -- Context Highlights
        TreesitterContextBottom = { link = "None" },
        TreesitterContextLineNumberBottom = { underline = true, fg = colors.muave },
        -- TreesitterContextSeparator = { bg = colors.mauve, fg = colors.mauve, undercurl = true },
        TreesitterContext = { bg = colors.base },
        TreesitterContextLineNumber = { fg = colors.mauve },

        -- Undercurl error underlines
        Underline = { undercurl = true },
        DiagnosticUnderlineHint = { undercurl = true },
        DiagnosticUnderlineError = { undercurl = true },
        DiagnosticUnderlineWarn = { undercurl = true },
        DiagnosticUnderlineInfo = { undercurl = true },

        -- Telescope 'flat' styling
        VertSplit = { fg = colors.surface0 },
        TelescopeBorder = { fg = colors.mantle, bg = colors.mantle },
        TelescopeSelectionCaret = { fg = colors.lavender, bg = colors.mantle },
        TelescopeMatching = { fg = colors.yellow },
        TelescopeNormal = { bg = colors.mantle },
        TelescopeSelection = { fg = colors.text, bg = colors.mantle },
        TelescopeMultiSelection = { fg = colors.text, bg = colors.mantle },

        TelescopeTitle = { fg = colors.overlay0, bg = colors.lavender },
        TelescopePreviewTitle = { fg = colors.overlay0, bg = colors.lavender },
        TelescopePromptTitle = { fg = colors.overlay0, bg = colors.surface1 },

        TelescopePromptPrefix = { fg = colors.lavender, bg = colors.surface1 },
        TelescopePromptNormal = { fg = colors.text, bg = colors.surface1 },
        TelescopePromptBorder = { fg = colors.surface1, bg = colors.surface1 },

        PmenuSel = { bg = "#282C34", fg = "NONE" },
        Pmenu = { fg = "#C5CDD9", bg = colors.mantle },
        NormalFloat = { fg = colors.text, bg = colors.mantle },
        FloatBorder = { fg = colors.text, bg = colors.mantle },
        FloatShadow = { fg = colors.text, bg = "NONE" },
        FloatShadowThrough = { fg = colors.text, bg = "NONE" },
      }
    end,
  },
  init = function()
    vim.cmd.colorscheme("catppuccin")
  end,
}
