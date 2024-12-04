local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Skip compatibility routines and speed up loading
-- vim.g.skip_ts_context_commentstring_module = true

-- Markdown
vim.api.nvim_set_var("markdown_fenced_languages", {
  "html",
  "javascript",
  "vim",
  "css",
  "javascriptreact",
  "typescript",
  "yaml",
})

vim.filetype.add({
  extension = {
    mdx = "jsx",
    tf = "terraform",
  },
})
-- Treesitter synonyms
-- vim.treesitter.language.register("bash", { "sh", "shell", "text", "robots", "fallback", "pem", "tmux" })
-- vim.treesitter.language.register("svelte", "svelte")

opt.completeopt = "menu,menuone,noselect"
opt.clipboard = "unnamedplus"
opt.cursorline = true

opt.breakindent = true
-- opt.linebreak = true

opt.belloff = "all"
opt.hidden = true
opt.ignorecase = true
opt.inccommand = "split"
opt.incsearch = true
opt.laststatus = 3
opt.mouse = "n"
opt.path = ".,**"
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true

opt.splitbelow = true
opt.splitright = true

-- defaul 'tcqj'
-- opt.formatoptions = "cqj"
-- opt.textwidth = 100
-- opt.colorcolumn = "+1"
opt.scrolloff = 8
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.termguicolors = true
opt.wildmenu = true

opt.wildignorecase = true
opt.wildignore:append("**/node_modules/*")
opt.wildignore:append("**/.git/*")
opt.wildignore:append("**/.next/*")
opt.wildignore:append("**/.svelte-kit/*")
opt.wildignore:append("**/venv/*")

-- Ignore filetypes I'll never open with nvim
opt.wildignore:append(".git,.hg,.svn")
opt.wildignore:append(".aux,*.out,*.toc")
opt.wildignore:append(".o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class")
opt.wildignore:append(".ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp")
opt.wildignore:append(".avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg")
opt.wildignore:append(".mp3,*.oga,*.ogg,*.wav,*.flac")
opt.wildignore:append(".eot,*.otf,*.ttf,*.woff")
opt.wildignore:append(".doc,*.pdf,*.cbr,*.cbz")
opt.wildignore:append(".zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb")
opt.wildignore:append(".swp,.lock,.DS_Store,._*")
opt.wildignore:append(".,..")

-- Psuendotransparency for popup-menu
opt.pumblend = 20
opt.wrap = true
