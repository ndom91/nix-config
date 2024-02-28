local function goto_next_error() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity[1] }) end
local function goto_prev_error() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity[1] }) end

-- local icons = {
--   [vim.diagnostic.severity.ERROR] = " ",
--   [vim.diagnostic.severity.WARN] = " ",
--   [vim.diagnostic.severity.INFO] = " ",
--   [vim.diagnostic.severity.HINT] = "",
-- }

return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true,
      ensure_installed = {
        "rnix",
        "lua_ls",
        "tsserver",
        "bashls",
        "cssls",
        "eslint",
        "html",
        "svelte",
        "tailwindcss",
        "volar",
      },
      handlers = {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup({})
        end,
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "nixpkgs-fmt",
        "prettierd",
        "rustywind",
        -- "biome",
        "eslint_d",
        "js-debug-adapter",
        "shellcheck",
        "shfmt",
      },
      auto_update = true,
      run_on_start = true,
      debounce_hours = 12,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "b0o/schemastore.nvim",
      "folke/neodev.nvim",
      { "nvim-telescope/telescope.nvim", dependencies = "nvim-lua/plenary.nvim" },
    },
    opts = {
      inlay_hints = { enabled = false },
    },
    config = function()
      local utils = require("plugins.lsp.utils")

      local function definitions(options)
        return utils.list_or_jump("textDocument/definition", "LSP Definitions", options)
      end

      -- Formatting Setup
      -- Create an augroup that is used for managing our formatting autocmds.
      --      We need one augroup per client to make sure that multiple clients
      --      can attach to the same buffer without interfering with each other.
      local _augroups = {}
      local get_augroup = function(client)
        if not _augroups[client.id] then
          local group_name = "kickstart-lsp-format-" .. client.name
          local id = vim.api.nvim_create_augroup(group_name, { clear = true })
          _augroups[client.id] = id
        end

        return _augroups[client.id]
      end

      -- Format function
      local function format(client_id, bufnr)
        -- vim.notify("id: " .. client_id .. "| buf: " .. bufnr)
        local client = vim.lsp.get_client_by_id(client_id)
        if client ~= nil then
          if not client.server_capabilities.documentFormattingProvider then return end

          if client.name == "tsserver" then return end

          vim.lsp.buf.format({
            client_id = client_id,
            async = false,
            -- filter = function(c) return c.id == client.id end,
          })
        end
      end

      -- Whenever an LSP attaches to a buffer, add a BufWritePre autocmd
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach-format", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = get_augroup(client),
            buffer = event.buf,
            callback = function() format(event.data.client_id, event.buf) end,
          })
        end,
      })

      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
      vim.keymap.set("n", "]e", goto_next_error)
      vim.keymap.set("n", "[e", goto_prev_error)

      -- On Attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(event)
          local options = { buffer = event.buf }
          local builtin = require("telescope.builtin")

          -- DISABLED: Enable inlay_hints on insert mode only
          -- local inlay_group = vim.api.nvim_create_augroup("lsp_augroup", { clear = true })
          -- vim.api.nvim_create_autocmd("InsertEnter", {
          --   buffer = event.buf,
          --   callback = function() vim.lsp.inlay_hint.enable(event.buf, true) end,
          --   group = inlay_group,
          -- })
          -- vim.api.nvim_create_autocmd("InsertLeave", {
          --   buffer = event.buf,
          --   callback = function() vim.lsp.inlay_hint.enable(event.buf, false) end,
          --   group = inlay_group,
          -- })

          vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          vim.keymap.set("n", "<Leader>e", builtin.diagnostics, options)
          vim.keymap.set("n", "gr", builtin.lsp_references, options)
          vim.keymap.set("n", "gi", builtin.lsp_implementations, options)
          vim.keymap.set("n", "gD", builtin.lsp_type_definitions, options)
          -- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, options)
          -- vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, options)
          vim.keymap.set("n", "gd", definitions, options)
          -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, options)

          vim.keymap.set("n", "K", vim.lsp.buf.hover, options)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, options)
          vim.keymap.set("n", "<space>ca", "<cmd>Lspsaga code_action<CR>", options)
          -- vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, options)
          vim.keymap.set("n", "<space>re", vim.lsp.buf.rename, options)

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client ~= nil then
            -- Formatting keymap handler
            local function attachFormatKeymap()
              if not client.server_capabilities.documentFormattingProvider then return end

              if client.name == "tsserver" then return end

              vim.keymap.set("n", "<Leader>lf", function() format(client.id, event.buf) end, options)
            end
            attachFormatKeymap()

            -- Highlight symbol references on hover
            if client.server_capabilities.documentHighlightProvider then
              vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })
              vim.api.nvim_clear_autocmds({
                buffer = event.buf,
                group = "LspDocumentHighlight",
              })
              vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                group = "LspDocumentHighlight",
                buffer = event.buf,
                callback = vim.lsp.buf.document_highlight,
              })
              vim.api.nvim_create_autocmd("CursorMoved", {
                group = "LspDocumentHighlight",
                buffer = event.buf,
                callback = vim.lsp.buf.clear_references,
              })
            end

            client.server_capabilities.semanticTokensProvider = nil
          end

          -- Fix treesitter ts-autotag diagnostics fix - https://github.com/windwp/nvim-ts-autotag#enable-update-on-insert
          vim.lsp.handlers["textDocument/publishDiagnostics"] =
            vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
              underline = true,
              virtual_text = {
                spacing = 5,
                severity_limit = "Warning",
              },
              update_in_insert = true,
            })
        end,
      })

      require("plugins.lsp.langs.typescript")
      require("plugins.lsp.langs.vue")
      -- require("plugins.lsp.langs.json")
      require("plugins.lsp.langs.yaml")
      require("plugins.lsp.langs.css")
      require("plugins.lsp.langs.html")
      require("plugins.lsp.langs.tailwindcss")
      require("plugins.lsp.langs.svelte")
    end,
  },
  {
    "folke/neodev.nvim",
    enabled = true,
    ft = "lua",
    config = function()
      require("neodev").setup({})
      require("plugins.lsp.langs.lua")
    end,
  },
  {
    "laytan/tailwind-sorter.nvim",
    enabled = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
    },
    build = "cd formatter && npm i && npm run build",
    config = function()
      require("tailwind-sorter").setup({
        on_save_enabled = true,
        on_save_pattern = { "*.vue", "*.html", "*.js", "*.jsx", "*.ts", "*.tsx", "*.astro", "*.svelte" },
      })
    end,
  },
  {
    "sbdchd/neoformat",
    enabled = false,
  },
  {
    "stevearc/conform.nvim",
    enabled = false,
  },
  {
    "pmizio/typescript-tools.nvim",
    enabled = false,
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        -- if vim.lsp.inlay_hint then vim.lsp.inlay_hint.enable(bufnr, true) end
      end,
      settings = {
        tsserver_file_preferences = {
          -- Inlay Hints
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      -- settings = {
      --   tsserver_file_preferences = {
      --     -- importModuleSpecifierPreference = "non-relative",
      --     jsx_close_tag = {
      --       enable = true,
      --       filetypes = { "javascriptreact", "typescriptreact" },
      --     },
      --   },
      -- },
    },
    config = function()
      local api = require("typescript-tools.api")
      require("typescript-tools").setup({
        handlers = {
          -- 80006 = 'This may be converted to an async function' diagnostics.
          ["textDocument/publishDiagnostics"] = api.filter_diagnostics({ 80006 }),
        },
      })
    end,
  },
}
