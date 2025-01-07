local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
vim.keymap.set('n', '<leader>fw', builtin.live_grep, { desc = "Find words" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find buffers" })
vim.keymap.set('n', '<Leader>f<CR>', builtin.resume, { desc = "Resume previous search" })
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = "Find history" })
vim.keymap.set('n', '<Leader>f\'', builtin.marks, { desc = "Find marks" })
vim.keymap.set('n', '<leader>f/', builtin.current_buffer_fuzzy_find, { desc = "Find words in current buffer" })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = "Find keymaps" })
vim.keymap.set('n', '<leader>ft', builtin.colorscheme, { desc = "Find themes" })
vim.keymap.set('n', '<leader>fC', builtin.commands, { desc = "Find commands" })
vim.keymap.set('n', '<leader>fc', builtin.grep_string, { desc = "Find word under cursor" })
vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols, { desc = "Search symbols" })
vim.keymap.set('n', '<leader>lD', builtin.diagnostics, { desc = "Search diagnostics" })


-- local actions = require("telescope.actions")
-- vim.keymap.set('i', "<C-J>", actions.move_selection_next)
-- vim.keymap.set('i', "<C-K>", actions.move_selection_previous)

require('telescope').setup {
    pickers = {
        find_files = {
            hidden = true
        },
        live_grep = {
            additional_args = function(opts)
                return {"--hidden"}
            end
        }
    },
    defaults = {
        borderchars = {
        prompt = {"━", "┃", "━", "┃", "┏", "┓", "┛", "┗"},
        -- preview = {"━", "┃", "━", "┃", "┏", "┓", "┛", "┗"},
        -- results = {"━", "┃", "━", "┃", "┏", "┓", "┛", "┗"},
        -- prompt = {" ", " ", " ", " ", " ", " ", " ", " "},
        preview = {"─", "│", "─", "│", "┌", "┐", "┘", "└"},
        results = {"─", "│", "─", "│", "┌", "┐", "┘", "└"},
      },
    }
}