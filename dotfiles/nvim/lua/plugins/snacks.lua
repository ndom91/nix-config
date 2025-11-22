local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), "info", {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    bigfile = {},
    words = {},
    notify = {},
    notifier = {
      style = "fancy",
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
    { "<leader>gop", ":lua Snacks.gitbrowse.open({what = 'branch'})<cr>", desc = "Open PR on GitHub" },
    { "<leader>gof", ":lua Snacks.gitbrowse.open({what = 'file'})<cr>", desc = "Open file on GitHub" },
    { "<leader>goc", ":lua Snacks.gitbrowse.open({what = 'commit'})<cr>", desc = "Open commit on GitHub" },
    { "<leader>gp", ":lua Snacks.gh.pr()<cr>", desc = "View GH PRs" },
    { "<leader>lg", ":lua Snacks.lazygit.open()<cr>", desc = "[L]azy [G]it", noremap = true, silent = true },
  },
}
