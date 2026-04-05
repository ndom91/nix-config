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
    lazygit = {
      configure = false,
      env = {
        LG_CONFIG_FILE = vim.fn.expand("~/.config/lazygit/config.yml"),
      },
    },
    gh = {},
    image = {
      env = {
        SNACKS_GHOSTTY = true,
      },
      doc = {
        inline = false,
        float = false, -- nvim 0.13 treesitter range() bug on markdown
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
          -- section = "terminal",
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
      enabled = false, -- nvim 0.13 nightly treesitter range() bug in scope/parse
    },
    styles = {
      lazygit = {
        width = 0.9,
        height = 0.9,
        border = "rounded",
      },
      snacks_image = {
        border = false,
      },
    },
  },
  keys = {
    -- GitHub open: <leader>go + suffix
    {
      "<leader>gof",
      function()
        Snacks.gitbrowse.open({ what = "file" })
      end,
      desc = "Open file on GitHub",
    },
    {
      "<leader>gom",
      function()
        Snacks.gitbrowse.open({ what = "file", branch = "main" })
      end,
      desc = "Open file on main",
    },
    {
      "<leader>goc",
      function()
        Snacks.gitbrowse.open({ what = "commit" })
      end,
      desc = "Open commit on GitHub",
    },
    {
      "<leader>gob",
      function()
        Snacks.gitbrowse.open({ what = "branch" })
      end,
      desc = "Open branch/PR on GitHub",
    },
    {
      "<leader>gop",
      function()
        Snacks.gh.pr()
      end,
      desc = "View GH PRs",
    },
    {
      "<leader>lg",
      function()
        Snacks.lazygit.open()
      end,
      desc = "Lazygit",
    },
  },
}
