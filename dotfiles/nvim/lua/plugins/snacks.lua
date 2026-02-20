return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    bigfile = {},
    words = {},
    notify = {},
    notifier = {
      style = "compact",
    },
    picker = {},
    statuscolumn = {},
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
    -- GitHub open: <leader>go + suffix
    { "<leader>gof", function() Snacks.gitbrowse.open({ what = "file" }) end, desc = "Open file on GitHub" },
    { "<leader>gom", function() Snacks.gitbrowse.open({ what = "file", branch = "main" }) end, desc = "Open file on main" },
    { "<leader>goc", function() Snacks.gitbrowse.open({ what = "commit" }) end, desc = "Open commit on GitHub" },
    { "<leader>gob", function() Snacks.gitbrowse.open({ what = "branch" }) end, desc = "Open branch/PR on GitHub" },
    { "<leader>gop", function() Snacks.gh.pr() end, desc = "View GH PRs" },
    { "<leader>lg", function() Snacks.lazygit.open() end, desc = "Lazygit" },
  },
}
