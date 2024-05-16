return {
  "numToStr/Comment.nvim",
  enabled = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  lazy = false,
  opts = {
    -- pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
  },
  -- config = function()
  --   local ft = require("Comment.ft")
  --   ft.svelte = { __default = "// %s", __multiline = "/* %s */" }
  --   ft.set("svelte", { __default = "// %s", __multiline = "/* %s */" })
  -- end,
}
