vim.g.mapleader = " "

-- NeoTree
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')

-- Navigation
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')
vim.keymap.set('n', '<leader>/', ':CommentToggle<CR>')

-- Splits
vim.keymap.set('n', '|', ':vsplit<CR>')
vim.keymap.set('n', '\\', ':split<CR>')

-- Other
vim.keymap.set('n', '<c-s>', ':w<CR>')
vim.keymap.set('i', 'jj', '<Esc>')
vim.keymap.set('n', '_', '-')
vim.keymap.set('n', '-', '$')
vim.keymap.set('v', '_', '-')
vim.keymap.set('v', '-', '$')
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.keymap.set('n', '<Left>', ':echoe "Use h"<CR>')
vim.keymap.set('n', '<Right>', ':echoe "Use l"<CR>')
vim.keymap.set('n', '<Up>', ':echoe "Use k"<CR>')
vim.keymap.set('n', '<Down>', ':echoe "Use j"<CR>')
vim.keymap.set('n', '<leader>j', ":call cursor(line('.')+5, col('.'))<CR>")
vim.keymap.set('n', '<leader>k', ":call cursor(line('.')-5, col('.'))<CR>")

-- Buffer
vim.keymap.set("n", "<leader>bv", "<Plug>(cokeline-focus-prev)", { silent = true })
vim.keymap.set("n", "<leader>bn", "<Plug>(cokeline-focus-next)", { silent = true })
vim.keymap.set("n", "<leader>bd", ":bp<bar>sp<bar>bn<bar>bd<CR>")

-- Terminal
vim.keymap.set('n', '<leader>t', ':ToggleTerm direction=float<CR>')
