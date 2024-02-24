local util = require('sonokai.util')

local M = {}

function M.colorscheme()
	if vim.g.colors_name then
		vim.cmd('hi clear')
	end

	vim.opt.termguicolors = true
	vim.g.colors_name = 'sonokai'

	local theme = require('sonokai.theme').set_colors()
	-- Set theme highlights
	for group, color in pairs(theme) do
		util.highlight(group, color)
	end
end

return M
