local resession = require("resession")

resession.setup({
    autosave = {
      enabled = false,
      interval = 60,
      notify = true,
    },
})

vim.keymap.set('n', '<Leader>Sl', function() resession.load "Last Session" end, { desc = "Load last session" })
vim.keymap.set('n', '<Leader>Ss', resession.save,  { desc = "Save this session" })
vim.keymap.set('n', '<Leader>SS', function() require("resession").save(vim.fn.getcwd(), { dir = "dirsession" }) end, { desc = "Save this dirsession" })
vim.keymap.set('n', '<Leader>St', resession.save_tab,  { desc = "Save this tab's session" })
vim.keymap.set('n', '<Leader>Sd', resession.delete,  { desc = "Delete a session" })
vim.keymap.set('n', '<Leader>SD', function() require("resession").delete(nil, { dir = "dirsession" }) end,  { desc = "Delete a dirsession" })
vim.keymap.set('n', '<Leader>Sf', resession.load,  { desc = "Load a session" })
vim.keymap.set('n', '<Leader>SF', function() require("resession").load(nil, { dir = "dirsession" }) end,  { desc = "Load a dirsession" })
vim.keymap.set('n', '<Leader>S.', function() require("resession").load(vim.fn.getcwd(), { dir = "dirsession" }) end,  { desc = "Load current dirsession" })
