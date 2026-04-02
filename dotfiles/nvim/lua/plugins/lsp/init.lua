local function goto_next_error()
  vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity[1] })
end
local function goto_prev_error()
  vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity[1] })
end

return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "neovim/nvim-lspconfig", -- provides default cmd/filetypes/root_dir for servers
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
    config = function()
      require("mason").setup()

      require("mason-tool-installer").setup({
        ensure_installed = {
          -- LSP servers
          "css-lsp",
          "lua-language-server",
          "eslint-lsp",
          "html-lsp",
          "json-lsp",
          "terraform-ls",
          "astro-language-server",
          "rust-analyzer",
          "svelte-language-server",
          "tailwindcss-language-server",
          "typescript-language-server",
          "yaml-language-server",
          -- Formatters & tools
          "stylua",
          "prettierd",
          "rustywind",
          "js-debug-adapter",
          "shellcheck",
          "shfmt",
        },
      })

      vim.diagnostic.config({ jump = { float = true } })

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

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Built-in LSP document color (inline color squares)
          if client and client:supports_method("textDocument/documentColor") then
            vim.lsp.document_color.enable(true, { bufnr = event.buf }, { style = 'virtual' })
          end

          map("]e", goto_next_error, "Goto Next Error")
          map("[e", goto_prev_error, "Goto Previous Error")
          map("<Leader>e", builtin.diagnostics, "Show [E]rrors")

          map("gd", function() lsp_utils.list_or_jump("textDocument/definition", "LSP Definitions") end, "[G]oto [d]efinition")
          map("gr", function() Snacks.picker.lsp_references() end, "[G]oto [r]eferences")
          map("gi", function() Snacks.picker.lsp_implementations() end, "[G]oto [i]mplementations")
          map("gt", builtin.lsp_type_definitions, "[G]oto [t]ype definitions")
          map("<space>ca", "<cmd>Lspsaga code_action<CR>", "[C]ode [A]ctions")
          map("<space>re", vim.lsp.buf.rename, "[R][e]name")

          if client ~= nil then
            -- Highlight symbol references on hover
            if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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
        end,
      })

      -- Enable all LSP servers (configs auto-loaded from lsp/ directory)
      vim.lsp.enable({
        "astro",
        "cssls",
        "eslint",
        "html",
        "jsonls",
        "lua_ls",
        "rust_analyzer",
        "svelte",
        "tailwindcss",
        "terraformls",
        "tsgo",
        "yamlls",
      })
    end,
  },
  {
    "stevearc/conform.nvim",
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

      local prettier_root = require("conform.util").root_file({
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
      })

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
            env = { PRETTIERD_LOCAL_PRETTIER_ONLY = "true" },
            command = "prettier",
            require_cwd = true,
            cwd = prettier_root,
            prepend_args = { "--plugin prettier-plugin-astro" },
          },
          prettierd_svelte = {
            env = { PRETTIERD_LOCAL_PRETTIER_ONLY = "true" },
            command = "prettier",
            require_cwd = true,
            cwd = prettier_root,
            prepend_args = { "--plugin prettier-plugin-svelte" },
          },
          prettierd = {
            env = { PRETTIERD_LOCAL_PRETTIER_ONLY = "true" },
            require_cwd = true,
            cwd = prettier_root,
          },
          shfmt = {
            prepend_args = { "-i", "2" },
          },
        },
      })
    end,
  },
}
