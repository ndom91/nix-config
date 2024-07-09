return {
  "lewis6991/gitsigns.nvim", -- gutter git signs + git blame virtual text
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    vim.api.nvim_set_hl(0, "GitSignsAdd", {})
    vim.api.nvim_set_hl(0, "GitSignsAddNr", { link = "GitSignAdd" })
    vim.api.nvim_set_hl(0, "GitSignsAddLn", { link = "GitSignAdd" })
    vim.api.nvim_set_hl(0, "GitSignsChange", {})
    vim.api.nvim_set_hl(0, "GitSignsChangeNr", { link = "GitSignsChange" })
    vim.api.nvim_set_hl(0, "GitSignsChangeLn", { link = "GitSignsChange" })
    vim.api.nvim_set_hl(0, "GitSignsDelete", {})
    vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { link = "GitSignsDelete" })
    vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { link = "GitSignsDelete" })
    vim.api.nvim_set_hl(0, "GitSignsTopdelete", { link = "GitSignsDelete" })
    vim.api.nvim_set_hl(0, "GitSignsTopdeleteNr", { link = "GitSignsDelete" })
    vim.api.nvim_set_hl(0, "GitSignsTopdeleteLn", { link = "GitSignsDelete" })
    vim.api.nvim_set_hl(0, "GitSignsChangedelete", { link = "GitSignsChange" })
    vim.api.nvim_set_hl(0, "GitSignsChangedeleteLn", { link = "GitSignsChange" })
    vim.api.nvim_set_hl(0, "GitSignsChangedeleteNr", { link = "GitSignsChange" })

    require("gitsigns").setup({
      numhl = true,
      current_line_blame = true,
    })
  end,
}
