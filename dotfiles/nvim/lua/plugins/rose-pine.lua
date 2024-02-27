return {
  "rose-pine/neovim", -- current theme
  name = "rose-pine",
  enabled = false,
  -- lazy = false, -- load first
  -- priority = 1000, -- before anything else
  config = function()
    require("rose-pine").setup {
      ---@usage 'main'|'moon'
      dark_variant = "main",
      bold_vert_split = true,
      dim_nc_background = false,
      disable_background = true,
      disable_float_background = true,
      disable_italics = false,
      ---@usage string hex value or named color from rosepinetheme.com/palette
      groups = {
        border = "highlight_med",
        comment = "muted",
        link = "iris",
        punctuation = "subtle",
        error = "love",
        hint = "iris",
        info = "foam",
        warn = "gold",
        headings = {
          h1 = "iris",
          h2 = "foam",
          h3 = "rose",
          h4 = "gold",
          h5 = "pine",
          h6 = "foam",
        },
        git_add = "pine",
        git_delete = "love",
        git_change = "rose",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        -- or set all headings at once
        -- headings = 'subtle'
      },
      highlight_groups = {
        -- Cutom highlight groups for custom Telescope look
        TelescopeBorder = { fg = "base", bg = "base" },
        TelescopeSelectionCaret = { fg = "iris", bg = "overlay" },
        TelescopeMatching = { fg = "gold" },
        TelescopeNormal = { bg = "base" },
        TelescopeSelection = { fg = "text", bg = "overlay" },
        TelescopeMultiSelection = { fg = "text", bg = "overlay" },

        TelescopeTitle = { fg = "base", bg = "iris" },
        TelescopePreviewTitle = { fg = "base", bg = "iris" },
        TelescopePromptTitle = { fg = "base", bg = "iris" },

        TelescopePromptPrefix = { fg = "iris" },
        TelescopePromptNormal = { fg = "text", bg = "muted" },
        TelescopePromptBorder = { fg = "muted", bg = "muted" },

        -- nvim-cmp https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-get-types-on-the-left-and-offset-the-menu
        PmenuSel = { fg = "NONE", bg = "#282C34" },
        Pmenu = { fg = "#C5CDD9", bg = "NONE" },

        -- CmpItemAbbrDeprecated = { fg = "#7E8294", bg = "NONE" },
        -- CmpItemAbbrMatch = { fg = "#82AAFF", bg = "NONE" },
        -- CmpItemAbbrMatchFuzzy = { fg = "#82AAFF", bg = "NONE" },
        -- CmpItemMenu = { fg = "#C792EA", bg = "NONE" },
        --
        -- CmpItemKindField = { fg = "#EED8DA", bg = "#B5585F" },
        -- CmpItemKindProperty = { fg = "#EED8DA", bg = "#B5585F" },
        -- CmpItemKindEvent = { fg = "#EED8DA", bg = "#B5585F" },
        --
        -- CmpItemKindText = { fg = "#C3E88D", bg = "#9FBD73" },
        -- CmpItemKindEnum = { fg = "#C3E88D", bg = "#9FBD73" },
        -- CmpItemKindKeyword = { fg = "#C3E88D", bg = "#9FBD73" },
        --
        -- CmpItemKindConstant = { fg = "#FFE082", bg = "#D4BB6C" },
        -- CmpItemKindConstructor = { fg = "#FFE082", bg = "#D4BB6C" },
        -- CmpItemKindReference = { fg = "#FFE082", bg = "#D4BB6C" },
        --
        -- CmpItemKindFunction = { fg = "#EADFF0", bg = "#A377BF" },
        -- CmpItemKindStruct = { fg = "#EADFF0", bg = "#A377BF" },
        -- CmpItemKindClass = { fg = "#EADFF0", bg = "#A377BF" },
        -- CmpItemKindModule = { fg = "#EADFF0", bg = "#A377BF" },
        -- CmpItemKindOperator = { fg = "#EADFF0", bg = "#A377BF" },
        --
        -- CmpItemKindVariable = { fg = "#C5CDD9", bg = "#7E8294" },
        -- CmpItemKindFile = { fg = "#C5CDD9", bg = "#7E8294" },
        --
        -- CmpItemKindUnit = { fg = "#F5EBD9", bg = "#D4A959" },
        -- CmpItemKindSnippet = { fg = "#F5EBD9", bg = "#D4A959" },
        -- CmpItemKindFolder = { fg = "#F5EBD9", bg = "#D4A959" },
        --
        -- CmpItemKindMethod = { fg = "#DDE5F5", bg = "#6C8ED4" },
        -- CmpItemKindValue = { fg = "#DDE5F5", bg = "#6C8ED4" },
        -- CmpItemKindEnumMember = { fg = "#DDE5F5", bg = "#6C8ED4" },
        --
        -- CmpItemKindInterface = { fg = "#D8EEEB", bg = "#58B5A8" },
        -- CmpItemKindColor = { fg = "#D8EEEB", bg = "#58B5A8" },
        -- CmpItemKindTypeParameter = { fg = "#D8EEEB", bg = "#58B5A8" },
      },
    }

    -- set colorscheme after options
    vim.cmd "colorscheme rose-pine"
  end,
}
