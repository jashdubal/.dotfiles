

-- Map Ctrl+R to run Python scripts
vim.keymap.set('n', '<C-p>', ':!python3 %<CR>', { noremap = true, silent = true })

-- Map Enter to add a new line below in normal mode
vim.keymap.set('n', '<CR>', 'o', { noremap = true, silent = true })

-- Map Ctrl+S to save in normal and insert modes
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-s>', '<ESC>:w<CR>a', { noremap = true, silent = true })

-- Map Ctrl+D to duplicate line
vim.keymap.set('n', '<C-d>', ':t.<CR>', { noremap = true, silent = true })

-- Option+Up: Go to the top of the buffer
vim.keymap.set('n', '<M-Up>', ':silent! normal! gg<CR>', { noremap = true, silent = true })

-- Option+Down: Go to the bottom of the buffer
vim.keymap.set('n', '<M-Down>', ':silent! normal! G<CR>', { noremap = true, silent = true })

-- Option+Left: Go to the end of the line
vim.keymap.set('n', ',', ':silent! normal! ^<CR>', { noremap = true, silent = true })

-- Option+Right: Go to the start of the line
vim.keymap.set('n', '.', ':silent! normal! $<CR>', { noremap = true, silent = true })

-- Ctrl+F to perform a replace all in the file
vim.keymap.set('n', '<C-f>', ':%s///g<Left><Left>', { noremap = true, silent = true })

-- Move lines in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Ctrl+H and Ctrl+V for horizontal and vertical splits
vim.keymap.set('n', '<C-h>', ':split<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-v>', ':vsplit<CR>', { noremap = true, silent = true })

-- Shift selection in visual mode
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })

-- Ctrl+Q to quit
vim.keymap.set('n', '<C-q>', ':q<CR>', { noremap = true, silent = true })

-- Delete without yanking in normal and visual mode
vim.keymap.set('n', 'd', '"_d', { noremap = true, silent = true })
vim.keymap.set('v', 'd', '"_d', { noremap = true, silent = true })



vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>");
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)
