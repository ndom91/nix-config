-- move lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { silent = true })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { silent = true })
vim.keymap.set("i", "<A-j>", "j<Esc>:m .+1<CR>==gi", { silent = true })
vim.keymap.set("i", "<A-k>", "j<Esc>:m .-2<CR>==gi", { silent = true })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true })

-- keep line centered on search/join
vim.keymap.set("n", "n", "nzz", { silent = true })
vim.keymap.set("n", "N", "Nzz", { silent = true })
vim.keymap.set("n", "J", "mzJ`z", { silent = true })
vim.keymap.set("n", "*", "*zz", { silent = true })
vim.keymap.set("n", "#", "#zz", { silent = true })

-- window movement
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })

-- resizing splits
vim.keymap.set("n", "<C-Up>", ":resize +2<cr>", { silent = true })
vim.keymap.set("n", "<C-Down>", ":resize -2<cr>", { silent = true })
vim.keymap.set("n", "<C-Left>", ":vertical resize +2<cr>", { silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize -2<cr>", { silent = true })

-- remap Y to yank to end of line
vim.keymap.set("n", "Y", "y$", { silent = true })
vim.keymap.set("v", "Y", "y$", { silent = true })

-- break up undo chain to add more granularity
vim.keymap.set("i", ".", ".<c-g>u", { silent = true })
vim.keymap.set("i", ",", ",<c-g>u", { silent = true })
vim.keymap.set("i", "!", "!<c-g>u", { silent = true })
vim.keymap.set("i", "?", "?<c-g>u", { silent = true })

-- delete text without yanking
vim.keymap.set("n", "<leader>d", '"_d', { silent = true })
vim.keymap.set("v", "<leader>d", '"_d', { silent = true })

-- turn off search highlighting
vim.keymap.set("n", "<enter>", ":nohlsearch<cr>", { silent = true })

-- neovim terminal can exit to normal mode with <esc> now
vim.keymap.set("t", "<esc>", [[<c-\><c-n>]], { silent = true })

-- disable keys
vim.keymap.set("n", "<c-z>", "<Nop>", { silent = true }) -- disable ctrl-z suspend
vim.keymap.set("n", "Q", "<Nop>", { silent = true }) -- disable ex mode

-- Map capital 'W' to also write
vim.api.nvim_create_user_command("W", ":write", {})
