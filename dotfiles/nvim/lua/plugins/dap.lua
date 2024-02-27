return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "mxsdev/nvim-dap-vscode-js",
      {
        "microsoft/vscode-js-debug",
        version = "1.x",
        build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
      },
    },
    keys = {
      { "<leader>dr", function() require("dap").continue() end, desc = "dap continue" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "dap toggle breakpoint" },
      { "<leader>dv", function() require("dap").step_over() end, desc = "dap step over" },
      { "<leader>di", function() require("dap").step_into() end, desc = "dap step into" },
      { "<leader>do", function() require("dap").step_out() end, desc = "dap step out" },
    },
    config = function()
      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      })

      for _, language in ipairs({ "typescript", "javascript", "svelte" }) do
        require("dap").configurations[language] = {
          -- attach to a node process that has been started with
          -- `--inspect` for longrunning tasks or `--inspect-brk` for short tasks
          -- npm script -> `node --inspect-brk ./node_modules/.bin/vite dev`
          {
            -- use nvim-dap-vscode-js's pwa-node debug adapter
            type = "pwa-node",
            -- attach to an already running node process with --inspect flag
            -- default port: 9222
            request = "attach",
            -- allows us to pick the process using a picker
            processId = require("dap.utils").pick_process,
            -- name of the debug action you have to select for this config
            name = "Attach debugger to existing `node --inspect` process",
            -- for compiled languages like TypeScript or Svelte.js
            sourceMaps = true,
            -- resolve source maps in nested locations while ignoring node_modules
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**",
            },
            -- path to src in vite based projects (and most other projects as well)
            cwd = "${workspaceFolder}/src",
            -- we don't want to debug code inside node_modules, so skip it!
            skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
          },
          {
            type = "pwa-chrome",
            name = "Launch Chrome to debug client",
            request = "launch",
            url = "http://localhost:5173",
            sourceMaps = true,
            protocol = "inspector",
            port = 9222,
            webRoot = "${workspaceFolder}/src",
            -- skip files from vite's hmr
            skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
          },
          -- only if language is javascript, offer this debug action
          language == "javascript"
              and {
                -- use nvim-dap-vscode-js's pwa-node debug adapter
                type = "pwa-node",
                -- launch a new process to attach the debugger to
                request = "launch",
                -- name of the debug action you have to select for this config
                name = "Launch file in new node process",
                -- launch current file
                program = "${file}",
                cwd = "${workspaceFolder}",
              }
            or nil,
        }
      end

      require("dapui").setup()
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open({ reset = true }) end
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close

      require("nvim-dap-virtual-text").setup({
        virt_text_pos = "inline",
        virt_text_win_col = 80,
        highlight_changed_variables = true,
        -- show_stop_reason = false,
      })

      vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "🟦", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "⭐️", texthl = "", linehl = "", numhl = "" })

      -- Mostly set in keys table
      -- vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end)
      -- vim.keymap.set('n', '<leader>dH', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
      -- vim.keymap.set({ 'n', 't' }, '<A-k>', function() dap.step_out() end)
      -- vim.keymap.set({ 'n', 't' }, '<A-l>', function() dap.step_into() end)
      -- vim.keymap.set({ 'n', 't' }, '<A-j>', function() dap.step_over() end)
      -- vim.keymap.set({ 'n', 't' }, 'dr', function() dap.continue() end)
      vim.keymap.set("n", "<leader>dn", function() dap.run_to_cursor() end)
      vim.keymap.set("n", "<leader>dc", function() dap.terminate() end)
      vim.keymap.set("n", "<leader>dR", function() dap.clear_breakpoints() end)
      vim.keymap.set("n", "<leader>de", function() dap.set_exception_breakpoints({ "all" }) end)
      vim.keymap.set("n", "<leader>da", function() require("debugHelper").attach() end)
      vim.keymap.set("n", "<leader>dA", function() require("debugHelper").attachToRemote() end)
      vim.keymap.set("n", "<leader>di", function() require("dap.ui.widgets").hover() end)
      vim.keymap.set("n", "<leader>d?", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.scopes)
      end)
    end,
  },
}
