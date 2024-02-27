return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>a", function() require("harpoon"):list():append() end, "n", desc = "[A]dd" },
    {
      "<leader>h",
      function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,
      "n",
      desc = "Harpoon List",
    },
    { "<C-p>", function() require("harpoon"):list():prev() end, "n", desc = "Harpoon [P]rev" },
    { "<C-n>", function() require("harpoon"):list():next() end, "n", desc = "Harpoon [N]ext" },
  },
  config = function()
    local harpoon = require("harpoon")
    local extensions = require("harpoon.extensions")

    harpoon:setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    })

    harpoon:extend(extensions.builtins.navigate_with_number())
    harpoon:extend({
      UI_CREATE = function(cx)
        vim.keymap.set("n", "S", function() harpoon.ui:select_menu_item({ vsplit = true }) end, { buffer = cx.bufnr })
        vim.keymap.set("n", "s", function() harpoon.ui:select_menu_item({ split = true }) end, { buffer = cx.bufnr })
      end,
    })
  end,
}
