local function goto_next_error()
  vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity[1] })
end
local function goto_prev_error()
  vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity[1] })
end

return {
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
      vim.diagnostic.config({ jump = { float = true } })

      -- vim.keymap.set("n", "[d", vim.diagnostic.jump({ count = -1, float = true }))
      -- vim.keymap.set("n", "]d", vim.diagnostic.jump({ count = 1, float = true }))

      -- On Attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspAttach", { clear = true }),
        callback = function(event)
          local builtin = require("telescope.builtin")
          local lsp_utils = require("plugins.lsp.utils")

          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- NOTE: What is this used for?
          vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          map("]e", goto_next_error, "Goto Next Error")
          map("[e", goto_prev_error, "Goto Previous Error")
          map("<Leader>e", builtin.diagnostics, "Show [E]rrors")

          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
          map("gd", function() lsp_utils.list_or_jump("textDocument/definition", "LSP Definitions") end, "[G]oto [d]efinition")
          map("gr", function() Snacks.picker.lsp_references() end, "[G]oto [r]eferences")
          map("gi", function() Snacks.picker.lsp_implementations() end, "[G]oto [i]mplementations")
          map("gt", builtin.lsp_type_definitions, "[G]oto [t]ype definitions")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<space>ca", "<cmd>Lspsaga code_action<CR>", "[C]ode [A]ctions")
          map("<space>re", vim.lsp.buf.rename, "[R][e]name")
          -- map("<C-s>", vim.lsp.buf.signature_help, "Signature Help", "i")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client ~= nil then
            -- Highlight symbol references on hover
            --
            if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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
        -- rnix = {},
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
        -- "nixpkgs-fmt",
        "prettierd",
        "rustywind",
        -- "biome",
        -- "biome_organize_imports",
        -- "demo_fmt",
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
    dependencies = {
      "LittleEndianRoot/mason-conform",
    },
    enabled = true,
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>lf",
        function()
          require("conform").format({ async = true })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    config = function()
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

        require("conform").format({ async = false, lsp_format = "fallback", range = range })
      end, { range = true })

      require("conform").setup({
        -- log_level = vim.log.levels.DEBUG,
        formatters_by_ft = {
          sh = { "shfmt" },
          lua = { "stylua" },
          -- nix = { "rnix", "nixpkgs-fmt" },
          rust = { "rustfmt" },
          astro = { "prettierd_astro" },
          javascript = { "biome", "prettierd", "prettier", stop_after_first = true },
          typescript = { "biome", "prettierd", "prettier", stop_after_first = true },
          javascriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
          typescriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
          json = { "biome", stop_after_first = true },
          css = { "biome", stop_after_first = true },
          svelte = {
            -- "biome",
            "prettierd_svelte",
            -- "prettierd",
            -- "prettier",
            stop_after_first = true,
          },
          ["_"] = { "trim_whitespace" },
        },
        notify_on_error = true,
        default_format_opts = {
          lsp_format = "fallback",
        },
        format_after_save = function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { lsp_format = "fallback" }
        end,
        format_on_save = function(bufnr)
          -- Disable autoformat on certain filetypes
          local ignore_filetypes = { "java" }
          if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
            return
          end
          -- Disable with a global or buffer-local variable
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          -- Disable autoformat for files in a certain path
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          if bufname:match("/node_modules/") then
            return
          end

          return { timeout_ms = 500, lsp_format = "fallback" }
        end,
        formatters = {
          prettierd_astro = {
            env = {
              PRETTIERD_LOCAL_PRETTIER_ONLY = "true",
            },
            command = "prettier",
            -- When cwd is not found, don't run the formatter (default false)
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
            prepend_args = {
              "--plugin prettier-plugin-astro",
            },
          },
          prettierd_svelte = {
            env = {
              PRETTIERD_LOCAL_PRETTIER_ONLY = "true",
            },
            command = "prettier",
            -- When cwd is not found, don't run the formatter (default false)
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
            prepend_args = {
              "--plugin prettier-plugin-svelte",
            },
          },
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
            -- When cwd is not found, don't run the formatter (default false)
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
}
