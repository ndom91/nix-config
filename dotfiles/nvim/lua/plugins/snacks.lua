return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    gitbrowse = {},
    terminal = {},
    lazygit = {},
    gh = {},
    image = {
      env = {
        SNACKS_GHOSTTY = true,
      },
      doc = {
        conceal = true,
      },
    },
    dashboard = {
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        {
          pane = 2,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git --no-pager diff --stat -B -M -C",
          height = 4,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        {
          pane = 2,
          icon = " ",
          title = "Recent Files",
          section = "recent_files",
          cwd = true,
          indent = 2,
          padding = 1,
        },
        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { section = "startup" },
      },
    },
    indent = {
      animate = {
        enabled = 1,
        style = "out",
        easing = "linear",
        duration = {
          step = 20, -- ms per step
          total = 250, -- maximum duration
        },
      },
    },
    styles = {
      snacks_image = {
        border = false,
      },
    },
  },
  keys = {
    { "<leader>go", ":lua Snacks.gitbrowse.open()<cr>", desc = "Tag a file" },
    { "<leader>gp", ":lua Snacks.gh.pr()<cr>", desc = "View GH PRs" },
    { "<leader>lg", ":lua Snacks.lazygit.open()<cr>", desc = "[L]azy [G]it", noremap = true, silent = true },
    { "<leader>lg", ":lua Snacks.lazygit.open()<cr>", desc = "[L]azy [G]it", noremap = true, silent = true },
  },
}
