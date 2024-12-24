local function goto_next_error()
  vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity[1] })
end
local function goto_prev_error()
  vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity[1] })
end

return {
  -- {
  --   "williamboman/mason.nvim",
  --   lazy = false,
  --   opts = {},
  -- },
  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   opts = {
  --     automatic_installation = true,
  --     ensure_installed = {
  --       "rnix",
  --       "lua_ls",
  --       "ts_ls", -- typescript_languageserver
  --       "bashls",
  --       "cssls",
  --       "eslint",
  --       "html",
  --       "svelte",
  --       "tailwindcss",
  --       "rust_analyzer",
  --       "volar",
  --     },
  --     handlers = {
  --       -- The first entry (without a key) will be the default handler
  --       -- and will be called for each installed server that doesn't have
  --       -- a dedicated handler.
  --       -- function(server_name) -- default handler (optional)
  --       --   require("lspconfig")[server_name].setup({})
  --       -- end,
  --     },
  --   },
  -- },
  -- {
  --   "WhoIsSethDaniel/mason-tool-installer.nvim",
  --   opts = {
  --     ensure_installed = {
  --       "nixpkgs-fmt",
  --       "prettierd",
  --       "rustywind",
  --       -- "biome",
  --       -- "eslint_d",
  --       "js-debug-adapter",
  --       "shellcheck",
  --       "shfmt",
  --     },
  --     auto_update = true,
  --     run_on_start = true,
  --     debounce_hours = 12,
  --   },
  -- },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "b0o/schemastore.nvim",
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
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
      -- local _augroups = {}
      -- local get_augroup = function(client)
      --   if not _augroups[client.id] then
      --     local group_name = "kickstart-lsp-format-" .. client.name
      --     local id = vim.api.nvim_create_augroup(group_name, { clear = true })
      --     _augroups[client.id] = id
      --   end
      --
      --   return _augroups[client.id]
      -- end

      -- Format function
      -- local function format(client_id, bufnr)
      --   local client = vim.lsp.get_client_by_id(client_id)
      --   if client ~= nil then
      --     if not client.server_capabilities.documentFormattingProvider then return end
      --     -- vim.notify("name: " .. client.name .. "| buf: " .. bufnr)
      --
      --     -- if client.name == "tsserver" then return end
      --
      --     vim.lsp.buf.format({
      --       client_id = client_id,
      --       async = false,
      --       filter = function(formatClient) return formatClient.name ~= "tsserver" end,
      --       -- filter = function(c) return c.id == client.id end,
      --     })
      --   end
      -- end

      -- Whenever an LSP attaches to a buffer, add a BufWritePre autocmd
      -- vim.api.nvim_create_autocmd("LspAttach", {
      --   group = vim.api.nvim_create_augroup("lsp-attach-format", { clear = true }),
      --   callback = function(event)
      --     local client = vim.lsp.get_client_by_id(event.data.client_id)
      --     vim.api.nvim_create_autocmd("BufWritePre", {
      --       group = get_augroup(client),
      --       buffer = event.buf,
      --       callback = function() format(event.data.client_id, event.buf) end,
      --     })
      --   end,
      -- })
      -- NOTE: Migrated to `conform.nvim`

      vim.diagnostic.config({ jump = { float = true } })

      -- vim.keymap.set("n", "[d", vim.diagnostic.jump({ count = -1, float = true }))
      -- vim.keymap.set("n", "]d", vim.diagnostic.jump({ count = 1, float = true }))

      -- On Attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspAttach", { clear = true }),
        callback = function(event)
          local builtin = require("telescope.builtin")

          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- NOTE: What is this used for?
          vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          map("]e", goto_next_error, "Goto Next Error")
          map("[e", goto_prev_error, "Goto Previous Error")

          map("<Leader>e", builtin.diagnostics, "Show [E]rrors")
          map("gi", builtin.lsp_implementations, "[G]oto [I]mplementations")
          -- map("gT", builtin.lsp_type_definitions, "[G]oto [T]ype Definition")
          map("gD", definitions, "[G]oto [D]efinitions")
          map("gd", "<cmd>Lspsaga goto_definition<CR>", "[G]oto [D]efinition")
          map("gr", "<cmd>Lspsaga finder<CR>", "[G]oto [R]eferences")
          -- map("gr", builtin.lsp_references, "[G]oto [R]eferences")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<space>ca", "<cmd>Lspsaga code_action<CR>", "[C]ode [A]ctions")
          map("<space>re", vim.lsp.buf.rename, "[R][e]name")
          map("<C-s>", vim.lsp.buf.signature_help, "Signature Help", "i")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client ~= nil then
            -- Highlight symbol references on hover
            --
            if client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
              -- if client.server_capabilities.documentHighlightProvider then
              local highlight_augroup = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })
              vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                group = highlight_augroup,
                buffer = event.buf,
                callback = vim.lsp.buf.document_highlight,
              })
              vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                group = highlight_augroup,
                buffer = event.buf,
                callback = vim.lsp.buf.clear_references,
              })

              vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
                callback = function(event2)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds({ group = highlight_augroup, buffer = event2.buf })
                end,
              })
            end

            client.server_capabilities.semanticTokensProvider = nil
          end

          -- Fix treesitter ts-autotag diagnostics fix - https://github.com/windwp/nvim-ts-autotag#enable-update-on-insert
          -- vim.lsp.handlers["textDocument/publishDiagnostics"] =
          --   vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
          --     underline = true,
          --     virtual_text = {
          --       spacing = 5,
          --       min = vim.diagnostic.severity.WARN,
          --     },
          --     update_in_insert = true,
          --   })
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      local servers = {
        cssls = require("plugins.lsp.langs.css"),
        lua_ls = require("plugins.lsp.langs.lua"),
        eslint = require("plugins.lsp.langs.eslint"),
        html = {},
        jsonls = require("plugins.lsp.langs.json"),
        rnix = {},
        terraformls = {},
        astro = {},
        rust_analyzer = require("plugins.lsp.langs.rust"),
        svelte = require("plugins.lsp.langs.svelte"),
        tailwindcss = require("plugins.lsp.langs.tailwindcss"),
        ts_ls = require("plugins.lsp.langs.typescript"),
        yamlls = require("plugins.lsp.langs.yaml"),
        -- require("plugins.lsp.langs.vue")
      }

      require("mason").setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua",
        "nixpkgs-fmt",
        "prettierd",
        "rustywind",
        -- "biome",
        -- "eslint_d",
        "js-debug-adapter",
        "shellcheck",
        "shfmt",
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    enabled = true,
    keys = {
      {
        "<leader>lf",
        function()
          vim.cmd("Format")
        end,
        mode = "",
        desc = "[F]ormat",
      },
    },
    config = function()
      local conform = require("conform")
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end

        conform.format({ async = false, lsp_format = "fallback", range = range })
      end, { range = true })

      conform.setup({
        formatters_by_ft = {
          sh = { "shfmt" },
          lua = { "stylua" },
          javascript = { "prettierd" },
          typescript = { "prettierd" },
          javascriptreact = { "prettierd" },
          typescriptreact = { "prettierd" },
          svelte = { "prettierd" },
          ["_"] = { "trim_whitespace" },
        },
        notify_on_error = true,
        format_on_save = {
          -- These options will be passed to conform.format()
          timeout_ms = 500,
          async = false,
          lsp_format = "fallback",
        },
        formatters = {
          prettierd = {
            env = {
              PRETTIERD_LOCAL_PRETTIER_ONLY = "true",
            },
            -- condition = function()
            --   -- Use eslint/eslint_d lsp if available
            --   if next(vim.lsp.get_clients({ name = "eslint" })) then
            --     return false
            --   end
            -- end,
            require_cwd = true,
            cwd = require("conform.util").root_file({
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.yml",
              ".prettierrc.yaml",
              ".prettierrc.json5",
              ".prettierrc.js",
              ".prettierrc.cjs",
              ".prettierrc.mjs",
              ".prettierrc.toml",
              "prettier.config.js",
              "prettier.config.cjs",
              "prettier.config.mjs",
            }),
          },
          shfmt = {
            prepend_args = { "-i", "2" },
          },
        },
      })
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
