return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "\\", "<cmd>Neotree toggle<cr>", desc = "Neotree Toggle", silent = true },
  },
  config = function()
    -- If you want icons for diagnostic errors, you'll need to define them somewhere:
    vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
    -- NOTE: this is changed from v1.x, which used the old style of highlight groups
    -- in the form "LspDiagnosticsSignWarning"

    require("neo-tree").setup({
      close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab; currently janky
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      sort_case_insensitive = true, -- used when sorting files and directories in the tree
      source_selector = {
        winbar = true,
        content_layout = "center",
        separator = "",
        sources = {
          { source = "filesystem" },
          { source = "buffers" },
          -- { source = "git_status" },
        },
      },
      default_component_configs = {
        container = { enable_character_fade = true },
        indent = {
          indent_size = 2,
          padding = 1, -- extra padding on left hand side
          -- indent guides
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
          -- expander config, needed for nesting files
          with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "ﰊ",
          default = "*",
        },
        modified = { symbol = "", highlight = "NeoTreeModified" },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = "NeoTreeFileName",
        },
        git_status = {
          symbols = {
            -- Change type
            added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
            deleted = "✖", -- this can only be used in the git_status source
            renamed = "", -- this can only be used in the git_status source
            -- Status type
            untracked = "",
            ignored = "",
            unstaged = "",
            staged = "",
            conflict = "",
          },
        },
        file_size = {
          enabled = false,
          required_width = 64, -- min width of window required to show this column
        },
        type = {
          enabled = false,
          required_width = 110, -- min width of window required to show this column
        },
        last_modified = {
          enabled = false,
          required_width = 88, -- min width of window required to show this column
        },
        created = {
          enabled = false,
          required_width = 120, -- min width of window required to show this column
        },
        symlink_target = {
          enabled = false,
        },
      },
      window = {
        position = "left",
        width = 35,
        auto_expand_width = false,
        mapping_options = { noremap = true, nowait = true },
        mappings = {
          ["<space>"] = "toggle_node",
          ["o"] = "toggle_node",
          ["<2-LeftMouse>"] = "open",
          ["<esc>"] = "revert_preview",
          ["P"] = { "toggle_preview", config = { use_float = true } },
          ["<cr>"] = "open",
          ["<c-n>"] = "open",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["t"] = "open_tabnew",
          ["C"] = "close_node",
          ["z"] = "close_all_nodes",
          ["["] = "prev_source",
          ["]"] = "next_source",
          ["a"] = {
            "add",
            config = {
              show_path = "relative", -- "none", "relative", "absolute"
            },
          },
          ["y"] = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local filename = node.name
            local modify = vim.fn.fnamemodify

            local results = {
              e = { val = modify(filename, ":e"), msg = "Extension only" },
              f = { val = filename, msg = "Filename" },
              F = { val = modify(filename, ":r"), msg = "Filename w/o extension" },
              h = { val = modify(filepath, ":~"), msg = "Path relative to Home" },
              p = { val = modify(filepath, ":."), msg = "Path relative to CWD" },
              P = { val = filepath, msg = "Absolute path" },
            }

            local messages = {
              { "\nChoose to copy to clipboard:\n", "Normal" },
            }
            for i, result in pairs(results) do
              if result.val and result.val ~= "" then
                vim.list_extend(messages, {
                  { ("%s."):format(i), "Identifier" },
                  { (" %s: "):format(result.msg) },
                  { result.val, "String" },
                  { "\n" },
                })
              end
            end
            vim.api.nvim_echo(messages, false, {})
            local result = results[vim.fn.getcharstr()]
            if result and result.val and result.val ~= "" then
              vim.notify("Copied: " .. result.val)
              vim.fn.setreg("+", result.val)
            end
          end,
          ["Y"] = function(state)
            local node = state.tree:get_node()
            local content = node.path:gsub(state.path, ""):sub(2) -- relative
            vim.fn.setreg('"', content)
            vim.fn.setreg("1", content)
            vim.fn.setreg("+", content)
          end,
          ["A"] = "add_directory",
          ["d"] = "delete",
          ["r"] = "rename",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = {
            "copy",
            config = {
              show_path = "absolute", -- "none", "relative", "absolute"
            },
          },
          ["m"] = "move", -- takes text input for destination
          ["q"] = "close_window",
          ["R"] = "refresh",
        },
      },
      nesting_rules = {},
      filesystem = {
        filtered_items = {
          visible = true, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            ".DS_Store",
            "thumbs.db",
            ".docusaurus",
          },
          always_show = {
            ".env",
            ".env.local",
            ".env.development",
            ".env.production",
          },
          never_show = { -- remains hidden even if visible is toggled to true
            ".DS_Store",
            "thumbs.db",
            ".docusaurus",
          },
        },
        follow_current_file = {
          enabled = true, -- This will find and focus the file in the active buffer every
        },
        -- time the current file is changed while the tree is open.
        group_empty_dirs = false,
        hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
        -- in whatever position is specified in window.position
        -- "open_current",  -- netrw disabled, opening a directory opens within the
        -- window like netrw would, regardless of window.position
        -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
        use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
        -- instead of relying on nvim autocmd events.
        window = {
          mappings = {
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
            ["H"] = "toggle_hidden",
            ["/"] = "fuzzy_finder",
            ["f"] = "filter_on_submit",
            ["<c-x>"] = "clear_filter",
            ["[g"] = "prev_git_modified",
            ["]g"] = "next_git_modified",
          },
        },
      },
      buffers = {
        follow_current_file = {
          enabled = true, -- This will find and focus the file in the active buffer every
        },
        -- time the current file is changed while the tree is open.
        group_empty_dirs = false, -- when true, empty folders will be grouped together
        show_unloaded = false,
        window = {
          mappings = {
            ["x"] = "buffer_delete",
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
          },
        },
      },
      git_status = {
        window = {
          position = "float",
          mappings = {
            ["A"] = "git_add_all",
            ["gu"] = "git_unstage_file",
            ["ga"] = "git_add_file",
            ["gr"] = "git_revert_file",
            ["gc"] = "git_commit",
            ["gp"] = "git_push",
            ["gg"] = "git_commit_and_push",
          },
        },
      },
    })
  end,
}
