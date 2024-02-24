local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})


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

-- vim.keymap.set('n', '<Tab>', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
-- vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols, {})
-- vim.keymap.set('n', 'gr', builtin.lsp_references,
--                {noremap = true, silent = true})
-- vim.keymap.set('n', 'gd', builtin.lsp_definitions,
--                {noremap = true, silent = true})





-- local telescope_status, telescope = pcall(require, 'telescope')
-- if not telescope_status then
--   print('Failed to require telescope')
--   return
-- end
--
-- local telescope_actions_status, telescope_actions = pcall(require, "telescope.actions")
-- if not telescope_actions_status then
--   print('Failed to require telescode.actions')
--   return
-- end
--
-- telescope.setup {}
-- telescope.load_extension("fzf")
--
-- local builtin = require('telescope.builtin')
-- vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
