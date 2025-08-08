return {
  "lewis6991/gitsigns.nvim", -- gutter git signs + git blame virtual text
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    vim.api.nvim_set_hl(0, "GitSignsAdd", {})
    vim.api.nvim_set_hl(0, "GitSignsAddNr", { link = "GitSignAdd" })
    vim.api.nvim_set_hl(0, "GitSignsAddLn", { link = "GitSignAdd" })
    vim.api.nvim_set_hl(0, "GitSignsChange", {})
    vim.api.nvim_set_hl(0, "GitSignsChangeNr", { link = "GitSignsChange" })
    vim.api.nvim_set_hl(0, "GitSignsChangeLn", { link = "GitSignsChange" })
    vim.api.nvim_set_hl(0, "GitSignsDelete", {})
    vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { link = "GitSignsDelete" })
    vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { link = "GitSignsDelete" })
    vim.api.nvim_set_hl(0, "GitSignsTopdelete", { link = "GitSignsDelete" })
    vim.api.nvim_set_hl(0, "GitSignsTopdeleteNr", { link = "GitSignsDelete" })
    vim.api.nvim_set_hl(0, "GitSignsTopdeleteLn", { link = "GitSignsDelete" })
    vim.api.nvim_set_hl(0, "GitSignsChangedelete", { link = "GitSignsChange" })
    vim.api.nvim_set_hl(0, "GitSignsChangedeleteLn", { link = "GitSignsChange" })
    vim.api.nvim_set_hl(0, "GitSignsChangedeleteNr", { link = "GitSignsChange" })

    require("gitsigns").setup({
      numhl = true,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text_pos = "eol",
        delay = 500,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Open PR in GitHub
        map("n", "<leader>gpr", function()
          -- Use git command directly since gitsigns blame_line doesn't provide data to callback
          local current_line = vim.api.nvim_win_get_cursor(0)[1]
          local file_path = vim.api.nvim_buf_get_name(0)
          local cmd = string.format("git blame -L %d,%d --porcelain %s", current_line, current_line, file_path)
          
          vim.fn.jobstart(cmd, {
            stdout_buffered = true,
            on_stdout = function(_, data)
              if data and data[1] and data[1] ~= "" then
                -- Parse porcelain format to get commit hash
                local commit_hash = data[1]:match("^([%w]+)")
                if commit_hash and commit_hash ~= "0000000000000000000000000000000000000000" then
                  -- Get commit message
                  local msg_cmd = string.format("git log --format=%%s -n 1 %s", commit_hash)
                  vim.fn.jobstart(msg_cmd, {
                    stdout_buffered = true,
                    on_stdout = function(_, msg_data)
                      if msg_data and msg_data[1] and msg_data[1] ~= "" then
                        local pr_match = msg_data[1]:match("#(%d+)")
                        if pr_match then
                          local gh_cmd = string.format("gh pr view %s --web", pr_match)
                          vim.fn.jobstart(gh_cmd, { detach = true })
                          vim.notify("Opening PR #" .. pr_match .. " in browser")
                        else
                          vim.notify("No PR number found in commit message: " .. msg_data[1])
                        end
                      end
                    end
                  })
                else
                  vim.notify("No commit found for this line")
                end
              end
            end
          })
        end, { desc = "Open PR in GitHub" })
      end,
    })
  end,
}
