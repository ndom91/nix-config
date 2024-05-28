-- everything else here, the order *shouldn't* matter as much I prefer to put
-- plugins as far towards the end of my require statements so that if you
-- introduce a bug on accident, its likely that the rest of your config works
-- fine other than some plugin configuration that is going awry
require("settings")

-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  install = {
    -- install missing plugins on startup. This doesn't increase startup time.
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "catppuccin" },
    dev = {
      path = "/opt/ndomino/nvim/",
    },
  },
})
require("mappings")
require("autocmds")
