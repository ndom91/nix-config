local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local delete_buffer = function(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local entry = action_state.get_selected_entry()

  if entry and entry.bufnr then
    -- Delete the buffer
    vim.api.nvim_buf_delete(entry.bufnr, { force = false })

    -- Remove the entry from the picker and refresh
    current_picker:delete_selection(function(selection)
      -- Buffer already deleted above, just need to update the picker
    end)
  end
end

local file_ignore_patterns = {
  "%.jpg",
  "%.jpeg",
  "%.png",
  "%.otf",
  "%.ttf",
  "%.lock",
  "pnpm-lock.yaml",
  "package-lock.json",
  "^node_modules/",
  "^\\.next/",
  "^static/",
  "^coverage/",
  "^lcov-report/",
  "^dist/",
  "^pack/github/",
  "^\\.nuxt/",
  "^\\.docusaurus/",
  "^build/",
  "[.]svelte-kit/",
}
-- require("telescope").load_extension("ui-select")

return {
  "nvim-telescope/telescope.nvim",
  tag = "v0.1.9",
  dependencies = {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  keys = {
    { "<leader>.", require("telescope.builtin").find_files, desc = "Find Files" },
    {
      "<leader>,",
      function()
        require("telescope.builtin").buffers({
          show_all_buffers = true,
          attach_mappings = function(_, map)
            map("i", "<C-c>", delete_buffer)
            map("n", "d", delete_buffer)
            return true
          end,
        })
      end,
      desc = "Find Buffers",
    },
    { "<leader>/", require("telescope.builtin").live_grep, desc = "Live Grep" },
    { "<leader>:", require("telescope.builtin").command_history, desc = "Command History" },
    {
      "<leader>r",
      function()
        require("telescope.builtin").oldfiles({ cwd_only = true })
      end,
      desc = "Old Files",
    },
    { "<leader>ft", require("telescope.builtin").builtin, desc = "[F]ind [B]uiltin" },
    { "<leader>fh", require("telescope.builtin").help_tags, desc = "[F]ind [H]elp Tags" },
    {
      "<leader>fws",
      require("telescope.builtin").lsp_dynamic_workspace_symbols,
      desc = "[F]ind [W]orkspace [S]ymbols",
    },
    {
      "<leader>fr",
      require("telescope.builtin").lsp_references,
      desc = "[F]ind [R]eferences",
    },
    { "<leader>fd", require("telescope.builtin").diagnostics, desc = "[F]ind [D]iagnostics" },
    {
      "<leader>fe",
      function()
        require("telescope.builtin").diagnostics({ severity = 0 })
      end,
      desc = "[F]ind [E]rrors",
    },
    { "<leader>km", require("telescope.builtin").keymaps, desc = "[K]ey[m]aps" },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 0,
          border = {},
          previewer = false,
          layout_strategy = "vertical",
          layout_config = {
            vertical = {
              mirror = true,
            },
          },
        }))
      end,
      desc = "[F]ind in [B]uffer",
    },
    {
      "<leader>fof",
      function()
        require("telescope.builtin").live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end,
      desc = "[F]ind [O]pen [F]iles",
    },
    { "<leader>gc", require("telescope.builtin").git_commits, desc = "[G]it [C]ommits" },
    { "<leader>gfh", require("telescope.builtin").git_bcommits, desc = "[G]it [F]ile [H]istory" },
    { "<leader>gb", require("telescope.builtin").git_branches, desc = "[G]it [B]ranches" },
  },
  opts = {
    defaults = {
      entry_prefix = "  ",
      prompt_prefix = "  ",
      selection_caret = " ",
      set_env = { ["COLORTERM"] = "truecolor" },
      color_devicons = true,
      path_display = {
        "filename_first",
      },
      results_title = "",
      prompt_title = "Search",
      winblend = 0,
      border = false,
      -- borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      mappings = {
        i = {
          ["<esc>"] = actions.close,
          ["<c-j>"] = actions.move_selection_next,
          ["<c-k>"] = actions.move_selection_previous,
          ["<s-up>"] = actions.cycle_history_prev,
          ["<s-down>"] = actions.cycle_history_next,
          ["<C-c>"] = delete_buffer,
          ["<C-w>"] = function()
            vim.api.nvim_input("<c-s-w>")
          end,
        },
        n = {
          ["<esc>"] = actions.close,
          ["q"] = actions.close,
          ["d"] = delete_buffer,
        },
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        -- '--hidden',
        -- '--ignore',
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--trim",
        -- "--multiline",
        -- "--multiline-dotall"
      },
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          prompt_position = "bottom",
          preview_width = 0.45,
          -- results_width = 0.8,
        },
        vertical = {
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
    },
    pickers = {
      live_grep = {
        prompt_title = "Grep",
        preview_title = "Results",
        file_ignore_patterns = file_ignore_patterns,
      },
      find_files = {
        prompt_title = "Files",
        preview_title = "Results",
        file_ignore_patterns = file_ignore_patterns,
      },
      old_files = {
        prompt_title = "Recents",
        preview_title = "Results",
        sort_lastused = true,
        cwd_only = true,
      },
      -- apps = { find_command = { "fd", "--type", "f", "--strip-cwd-prefix" } },
      dotfiles = { find_command = { "fd", "--type", "f", ".", "/home/ndo/.dotfiles" } },
    },
    extensions = {
      grapple = {},
      ["ui-select"] = {
        require("telescope.themes").get_dropdown({}),
      },
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      },
    },
  },
}
