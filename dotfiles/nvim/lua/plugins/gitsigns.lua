return {
  "lewis6991/gitsigns.nvim", -- gutter git signs + git blame virtual text
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    -- 'signs.add.hl' is now deprecated, please define highlight 'GitSignsAdd'
    -- 'signs.add.linehl' is now deprecated, please define highlight 'GitSignsAddLn'
    -- 'signs.add.numhl' is now deprecated, please define highlight 'GitSignsAddNr'
    -- 'signs.change.hl' is now deprecated, please define highlight 'GitSignsChange'
    -- 'signs.change.linehl' is now deprecated, please define highlight 'GitSignsChangeLn'
    -- 'signs.change.numhl' is now deprecated, please define highlight 'GitSignsChangeNr'
    -- 'signs.changedelete.hl' is now deprecated, please define highlight 'GitSignsChangedelete'
    -- 'signs.changedelete.linehl' is now deprecated, please define highlight 'GitSignsChangedeleteLn'
    -- 'signs.changedelete.numhl' is now deprecated, please define highlight 'GitSignsChangedeleteNr'
    -- 'signs.delete.hl' is now deprecated, please define highlight 'GitSignsDelete'
    -- 'signs.delete.linehl' is now deprecated, please define highlight 'GitSignsDeleteLn'
    -- 'signs.delete.numhl' is now deprecated, please define highlight 'GitSignsDeleteNr'
    -- 'signs.topdelete.hl' is now deprecated, please define highlight 'GitSignsTopdelete'
    -- 'signs.topdelete.linehl' is now deprecated, please define highlight 'GitSignsTopdeleteLn'
    -- 'signs.topdelete.numhl' is now deprecated, please define highlight 'GitSignsTopdeleteNr'
    -- vim.fn.sign_define("GitSignsTopdelete", { text = "", texthl = "DiagnosticSignHint" })
  end,
  opts = {
    signs = {
      add = {
        hl = "GitSignsAdd",
        text = "│",
        numhl = "GitSignsAddNr",
        linehl = "GitSignsAddLn",
      },
      change = {
        hl = "GitSignsChange",
        text = "│",
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn",
      },
      delete = {
        hl = "GitSignsDelete",
        text = "_",
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn",
      },
      topdelete = {
        hl = "GitSignsDelete",
        text = "‾",
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn",
      },
      changedelete = {
        hl = "GitSignsChange",
        text = "~",
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn",
      },
    },
    numhl = true,
    current_line_blame = true,
  },
}
