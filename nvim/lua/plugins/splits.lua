local splits = require("smart-splits")

vim.keymap.set('n', '<C-H>', splits.move_cursor_left, { desc = "Move to left split" })
vim.keymap.set('n', '<C-J>', splits.move_cursor_down, { desc = "Move to below split" })
vim.keymap.set('n', '<C-K>', splits.move_cursor_up, { desc = "Move to above split" })
vim.keymap.set('n', '<C-L>', splits.move_cursor_right, { desc = "Move to right split" })

vim.keymap.set('n', '<C-Up>', splits.resize_up, { desc = "Resize split up" })
vim.keymap.set('n', '<C-Down>', splits.resize_down, { desc = "Resize split down" })
vim.keymap.set('n', '<C-Left>', splits.resize_left, { desc = "Resize split left" })
vim.keymap.set('n', '<C-Right>', splits.resize_right, { desc = "Resize split right" })
