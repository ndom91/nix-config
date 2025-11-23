return {
  "saghen/blink.cmp",
  lazy = false, -- lazy loading handled internally

  dependencies = {
    "giuxtaposition/blink-cmp-copilot", -- Blink Copilot Source
    "Kaiser-Yang/blink-cmp-avante", -- Blink Avante Source
    -- "L3MON4D3/LuaSnip", -- Snippets Engine
    -- "rafamadriz/friendly-snippets", -- Snippets
    -- "onsails/lspkind-nvim", -- Icons
  },

  -- use a release tag to download pre-built binaries
  version = "v0.*",
  -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- see the "default configuration" section below for full documentation on how to define
    -- your own keymap.
    keymap = {
      preset = "super-tab",
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
    },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },

    -- snippets = {
    --   expand = function(snippet)
    --     require("luasnip").lsp_expand(snippet)
    --   end,
    --   active = function(filter)
    --     if filter and filter.direction then
    --       return require("luasnip").jumpable(filter.direction)
    --     end
    --     return require("luasnip").in_snippet()
    --   end,
    --   jump = function(direction)
    --     require("luasnip").jump(direction)
    --   end,
    -- },

    sources = {
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
        },
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", fallbacks = { "lsp" } },
        avante = {
          module = "blink-cmp-avante",
          name = "Avante",
          opts = {
            -- options for blink-cmp-avante
          },
        },
      },
      default = { "lsp", "path", "snippets", "buffer", "copilot", "lazydev", "omni" },
    },

    completion = {
      menu = {
        draw = {
          padding = { 0, 1 },
          gap = 1,
          columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                return " " .. ctx.kind_icon .. " " .. ctx.icon_gap
              end,
              highlight = function(ctx)
                -- return require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx)
                -- or ("BlinkCmpKind" .. ctx.kind)
                -- retu "BlinkCmpKind" .. ctx.kind
                return "BlinkCmpKind" .. ctx.kind
              end,
            },
            source_name = {
              width = { max = 30 },
              -- source_name or source_id are supported
              text = function(ctx)
                return ctx.source_name
              end,
              highlight = "BlinkCmpSource",
            },
          },
        },
      },
      documentation = {
        auto_show = true,
      },
      ghost_text = {
        enabled = true,
      },
    },

    -- experimental signature help support
    signature = { enabled = true },
  },
  -- allows extending the enabled_providers array elsewhere in your config
  -- without having to redefine it
  opts_extend = { "sources.completion.enabled_providers" },
}
