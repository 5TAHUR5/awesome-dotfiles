-- local ls = require("luasnip")

-- vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
-- vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
-- vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

-- vim.keymap.set({"i", "s"}, "<C-E>", function()
-- 	if ls.choice_active() then
-- 		ls.change_choice(1)
-- 	end
-- end, {silent = true})

-- vscode format
require("luasnip.loaders.from_vscode").lazy_load { exclude = vim.g.vscode_snippets_exclude or {} }
require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }

-- snipmate format
require("luasnip.loaders.from_snipmate").load()
require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }

-- lua format
require("luasnip.loaders.from_lua").load()
require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    if
      require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
      and not require("luasnip").session.jump_active
    then
      require("luasnip").unlink_current()
    end
  end,
})