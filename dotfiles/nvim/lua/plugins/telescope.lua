return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    -- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-ui-select.nvim",
  },
  keys = {
    { "<leader>.", require("telescope.builtin").find_files, desc = "Find Files" },
    {
      "<leader>,",
      function() require("telescope.builtin").buffers({ show_all_buffers = true }) end,
      desc = "Find Buffers",
    },
    { "<leader>/", require("telescope.builtin").live_grep, desc = "Live Grep" },
    { "<leader>:", require("telescope.builtin").command_history, desc = "Command History" },
    { "<leader>r", require("telescope.builtin").oldfiles, desc = "Old Files" },
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
      function() require("telescope.builtin").diagnostics({ severity = 0 }) end,
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
  config = function()
    local actions = require("telescope.actions")

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

    require("telescope").setup({
      defaults = {
        preview = {
          filesize_limit = 10, -- MB
        },
        prompt_prefix = "  ",
        selection_caret = " ",
        entry_prefix = "  ",
        set_env = { ["COLORTERM"] = "truecolor" },
        color_devicons = true,
        -- path_display = { shorten = 2 },
        -- path_display = function(_, path)
        --   local filename = path:gsub(vim.pesc(vim.loop.cwd()) .. '/', ''):gsub(vim.pesc(vim.fn.expand '$HOME'), '~')
        --   local tail = require('telescope.utils').path_tail(filename)
        --   return string.format('%s — %s', tail, filename)
        -- end,
        results_title = "",
        prompt_title = "Search",
        winblend = 0,
        border = {},
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<c-j>"] = actions.move_selection_next,
            ["<c-k>"] = actions.move_selection_previous,
            ["<s-up>"] = actions.cycle_history_prev,
            ["<s-down>"] = actions.cycle_history_next,
            ["<C-c>"] = actions.delete_buffer,
            ["<C-w>"] = function() vim.api.nvim_input("<c-s-w>") end,
          },
          n = {
            ["q"] = actions.close,
            ["<C-c>"] = actions.delete_buffer + actions.move_to_top,
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
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        -- dynamic_preview_title = true,
      },
      pickers = {
        live_grep = {
          prompt_title = "Grep",
          preview_title = "Results",
          -- path_display = { "smart" },
          dynamic_preview_title = true,
          file_ignore_patterns,
        },
        find_files = {
          prompt_title = "Files",
          preview_title = "Results",
          file_ignore_patterns,
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
    })
    require("telescope").load_extension("ui-select")
    require("telescope").load_extension("fzf")
  end,
}
