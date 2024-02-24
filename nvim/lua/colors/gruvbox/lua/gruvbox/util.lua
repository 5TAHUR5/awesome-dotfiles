local util = {}

local function parse_color(color)
	if color == nil then
		return print('invalid color')
	end

	color = color:lower()

	if not color:find('#') and color ~= 'none' then
		color = require('gruvbox.palette')[color]
			or vim.api.nvim_get_color_by_name(color)
	end

	return color
end

util.highlight = function(group, color)
	local fg = color.fg and parse_color(color.fg) or 'none'
	local bg = color.bg and parse_color(color.bg) or 'none'
	local sp = color.sp and parse_color(color.sp) or 'none'
    local fmt = color.fmt or 'none'
    vim.api.nvim_command(string.format("highlight %s guifg=%s guibg=%s guisp=%s gui=%s", group, fg, bg, sp, fmt))
end

-- util.highlight = function(group, color)
-- 	local fg = color.fg and parse_color(color.fg) or 'none'
-- 	local bg = color.bg and parse_color(color.bg) or 'none'
-- 	local sp = color.sp and parse_color(color.sp) or ''
--     local italic = color.italic or false
-- 	color = vim.tbl_extend('force', color, { fg = fg, bg = bg, sp = sp, italic = italic })
-- 	vim.api.nvim_set_hl(0, group, color)
-- end

return util
