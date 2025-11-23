return {
  "nvim-tree/nvim-web-devicons",
  "nvim-lua/plenary.nvim",
  "nvim-lua/popup.nvim",

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
    -- LSP status notifications bottom right
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
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
        svelte = true,
        rust = true,
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
  {
    -- first-party github copilot plugin
    "github/copilot.vim",
    event = "InsertEnter",
    enabled = false,
  },
  {
    -- LLM Chat
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make",
    enabled = false,
    opts = {
      provider = "claude",
      -- provider = "openai",
      -- openai = {
      --   model = "gpt-4o-2024-08-06",
      -- },
      providers = {
        claude = {
          -- TODO: Ensure logging in 1 time per reboot is available in all terminal sessions
          -- api_key_name = "cmd:op item get mq6qqndpax27wvnn4hge73ewf4 --fields label=credential --reveal",
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-20250514",
          -- temperature = 0,
          -- max_tokens = 4096,
        },
      },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
  },
  {
    -- Highlight CSS and other color codes in their color
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
    -- Better multi-key navigation i.e. vimium style
    "folke/which-key.nvim",
    enabled = true,
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({})
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {},
  },
  {
    "ndom91/freeze.nvim",
    enabled = false,
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
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  { "tpope/vim-repeat" },
  {
    -- Automatically detect and set buffer settings like tabstop and shiftwidth
    "tpope/vim-sleuth",
  },
  -- {
  --   "notes-nvim",
  --   dependencies = { "nvim-neotest/nvim-nio" },
  --   dev = true,
  --   opts = {
  --     rootDir = "/home/ndo/Documents/notebook",
  --   },
  -- },
}
