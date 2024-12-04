return {
  "nvim-tree/nvim-web-devicons",
  "nvim-lua/plenary.nvim",
  "nvim-lua/popup.nvim",

  -- icons on completion
  "onsails/lspkind-nvim",

  -- lsp function signature help on wildmenu
  {
    "ray-x/lsp_signature.nvim",
    enabled = true,
    opts = {
      hint_enable = true,
      hint_inline = function()
        return false
      end,
      floating_window = false,
      bind = true,
    },
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      -- integration = {
      --   ["nvim-tree"] = {
      --     enable = false,
      --   },
      -- },
      progress = {
        display = {
          progress_icon = {
            pattern = "dots",
            period = 1,
          },
        },
      },
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },
  {
    "folke/trouble.nvim",
    enabled = true,
    config = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<leader>tr",
        function()
          require("trouble").toggle()
        end,
        desc = "[T]oggle [T]rouble",
      },
      {
        "<leader>trw",
        function()
          require("trouble").toggle("workspace_diagnostics")
        end,
        desc = "[Tr]ouble [W]orkspace",
      },
      {
        "<leader>trd",
        function()
          require("trouble").toggle("lsp_type_definitions")
        end,
        desc = "[Tr]ouble Type [D]efinitions",
      },
      {
        "<leader>trr",
        function()
          require("trouble").toggle("lsp_references")
        end,
        desc = "[Tr]ouble [R]eferences",
      },
    },
  },
  -- tailwind token colorizer
  {
    "mrshmllow/document-color.nvim",
    enabled = false,
    keys = {
      { "<leader>tdc", "require('document-color').buf_toggle()", desc = "[T]oggle [D]ocument [C]olor" },
    },
    config = function()
      local docColors = require("document-color")
      docColors.setup({ mode = "background" })
      docColors.buf_attach()
    end,
  },
  -- lua based copilot replacement
  {
    "zbirenbaum/copilot.lua",
    enabled = true,
    event = "VeryLazy",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = false,
        javascript = true,
        typescript = true,
        typescriptreact = true,
        javascriptreact = true,
        lua = true,
        bash = true,
        sh = function()
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
            -- disable for .env files
            return false
          end
          return true
        end,
        ["."] = false,
      },
    },
  },
  -- first-party github copilot plugin
  {
    "github/copilot.vim",
    event = "InsertEnter",
    enabled = false,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make",
    opts = {
      provider = "claude",
      -- provider = "openai",
      openai = {
        model = "gpt-4o-2024-08-06",
      },
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-5-sonnet-20240620",
        temperature = 0,
        max_tokens = 4096,
      },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below is optional, make sure to setup it properly if you have lazy=true
      -- {
      --   "MeanderingProgrammer/render-markdown.nvim",
      --   opts = {
      --     file_types = { "markdown", "Avante" },
      --   },
      --   ft = { "markdown", "Avante" },
      -- },
    },
  },
  {
    "RRethy/nvim-base16",
    enabled = false,
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      filetypes = { "*" },
      user_default_options = {
        names = false,
        RRGGBBAA = true,
        css = true,
        tailwind = true,
        mode = "background",
      },
    },
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    enabled = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      theme = "hyper",
      config = {
        week_header = { enable = true },
        packages = { enable = true },
        project = {
          enable = false,
          limit = 8,
          icon = " ",
          label = "",
          action = function(path)
            vim.cmd("Telescope find_files cwd=" .. path)
          end,
        },
        mru = { limit = 10, label = "Most Recent", cwd_only = true },
        shortcut = {
          {
            desc = " Update",
            group = "@property",
            action = "Lazy update",
            key = "u",
          },
          {
            icon = " ",
            icon_hl = "@variable",
            desc = "Files",
            group = "Label",
            action = function(path)
              vim.cmd("Telescope find_files cwd=" .. path)
            end,
            key = "f",
          },
          {
            desc = " dotfiles",
            group = "Number",
            action = "Telescope dotfiles",
            key = "d",
          },
        },
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    lazy = false,
    enabled = true,
    config = function()
      local notify = require("notify")
      notify.setup({
        render = "wrapped-compact",
        background_colour = "#191724",
        -- icons = {
        --   ERROR = '',
        --   WARN = '',
        --   INFO = '',
        --   DEBUG = '',
        --   TRACE = '✎',
        -- },
      })
      vim.notify = notify
    end,
  },
  {
    "folke/which-key.nvim",
    enabled = false,
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    enabled = false,
    opts = {},
    keys = {
      {
        "s",
        function()
          require("flash").jump()
        end,
        { "n", "x", "o" },
        desc = "Flash Jump",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        function()
          require("flash").remote()
        end,
        "o",
        desc = "Remote Flash",
      },
      {
        "R",
        function()
          require("flash").treesitter_search()
        end,
        { "o", "x" },
        desc = "Flash Treesitter Search",
      },
      {
        "<c-s>",
        function()
          require("flash").toggle()
        end,
        { "c" },
        desc = "Flash Toggle",
      },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {},
  },
  {
    "kdheepak/lazygit.nvim",
    keys = {
      { "<leader>lg", "<cmd>LazyGit<CR>", desc = "[L]azy [G]it", noremap = true, silent = true },
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "segeljakt/vim-silicon",
    enabled = false,
  },
  {
    "ndom91/freeze.nvim",
    enabled = true,
    lazy = false,
    keys = {
      {
        "<leader>f",
        function()
          require("freeze").exec()
        end,
        mode = { "n", "v" },
        desc = "[F]reeze",
        noremap = true,
      },
    },
  },
  -- {
  --   dir = "/opt/ndomino/nvim/freeze.nvim",
  --   enabled = true,
  --   lazy = false,
  --   opts = {
  --     theme = "dracula",
  --   },
  --   keys = {
  --     {
  --       "<leader>f",
  --       function() require("freeze").exec() end,
  --       mode = { "n", "v" },
  --       desc = "[F]reeze",
  --       noremap = true,
  --     },
  --   },
  -- },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    opts = {},
  },
  {
    "tpope/vim-surround",
    enabled = false,
  },
  { "tpope/vim-repeat" },
  { "tpope/vim-sleuth" },
  {
    "notes-nvim",
    dependencies = { "nvim-neotest/nvim-nio" },
    dev = true,
    opts = {
      rootDir = "/home/ndo/Documents/notebook",
    },
  },
}
