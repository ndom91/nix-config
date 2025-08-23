return {
  "catppuccin/nvim",
  -- "m4xshen/catppuccinight.nvim",
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
        TelescopePromptTitle = { fg = colors.overlay0, bg = colors.lavender },

        TelescopePromptPrefix = { fg = colors.lavender },
        TelescopePromptNormal = { fg = colors.text, bg = colors.surface1 },
        TelescopePromptBorder = { fg = colors.surface1, bg = colors.surface1 },

        PmenuSel = { bg = "#282C34", fg = "NONE" },
        Pmenu = { fg = "#C5CDD9", bg = colors.mantle },
        NormalFloat = { fg = colors.text, bg = colors.mantle },
        FloatBorder = { fg = colors.text, bg = colors.mantle },
        FloatShadow = { fg = colors.text, bg = "NONE" },
        FloatShadowThrough = { fg = colors.text, bg = "NONE" },

        -- VSCode-like auto-complete menu styling
        CmpItemKindSnippet = { fg = colors.base, bg = colors.mauve },
        CmpItemKindKeyword = { fg = colors.base, bg = colors.red },
        CmpItemKindText = { fg = colors.base, bg = colors.teal },
        CmpItemKindMethod = { fg = colors.base, bg = colors.blue },
        CmpItemKindConstructor = { fg = colors.base, bg = colors.blue },
        CmpItemKindFunction = { fg = colors.base, bg = colors.blue },
        CmpItemKindFolder = { fg = colors.base, bg = colors.blue },
        CmpItemKindModule = { fg = colors.base, bg = colors.blue },
        CmpItemKindConstant = { fg = colors.base, bg = colors.peach },
        CmpItemKindField = { fg = colors.base, bg = colors.green },
        CmpItemKindProperty = { fg = colors.base, bg = colors.green },
        CmpItemKindEnum = { fg = colors.base, bg = colors.green },
        CmpItemKindUnit = { fg = colors.base, bg = colors.green },
        CmpItemKindClass = { fg = colors.base, bg = colors.yellow },
        CmpItemKindVariable = { fg = colors.base, bg = colors.flamingo },
        CmpItemKindFile = { fg = colors.base, bg = colors.blue },
        CmpItemKindInterface = { fg = colors.base, bg = colors.yellow },
        CmpItemKindColor = { fg = colors.base, bg = colors.red },
        CmpItemKindReference = { fg = colors.base, bg = colors.red },
        CmpItemKindEnumMember = { fg = colors.base, bg = colors.red },
        CmpItemKindStruct = { fg = colors.base, bg = colors.blue },
        CmpItemKindValue = { fg = colors.base, bg = colors.peach },
        CmpItemKindEvent = { fg = colors.base, bg = colors.blue },
        CmpItemKindOperator = { fg = colors.base, bg = colors.blue },
        CmpItemKindTypeParameter = { fg = colors.base, bg = colors.blue },
        CmpItemKindCopilot = { fg = colors.base, bg = colors.teal },

        CmpItemMenu = { fg = colors.mauve, bg = "NONE", italic = true },
        CmpItemMenuDefault = { fg = colors.mauve, bg = "NONE", italic = true },
        -- CmpItemMenu = { fg = '#C792EA', bg = 'NONE', italic = true },
        -- CmpItemMenuDefault = { fg = '#C792EA', bg = 'NONE', italic = true },
      }
    end,
  },
  init = function()
    vim.cmd.colorscheme("catppuccin")
  end,
}
