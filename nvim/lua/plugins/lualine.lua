local get_hex = require('cokeline.hlgroups').get_hl_attr
local colors = {
    red = get_hex('PaletteRed', 'fg') or "#000000",
    yellow = get_hex('PaletteYellow', 'fg') or "#000000",
    blue = get_hex('PaletteBlue', 'fg') or "#000000",
    orange = get_hex('PaletteOrange', 'fg') or "#000000",
    fg = get_hex('PaletteFg', 'fg') or "#000000",
    fg_alt = get_hex('PaletteFgAlt', 'fg') or "#000000",
    bg_accent  = get_hex('PaletteBgAccent', 'fg') or "#000000",
    bg_urgent = get_hex('PaletteBgUrgent', 'fg') or "#000000",
    gray = get_hex('PaletteGray', 'fg') or "#000000",
}

local function on_colorscheme_change()
    colors = {
        red = get_hex('PaletteRed', 'fg'),
        yellow = get_hex('PaletteYellow', 'fg'),
        blue = get_hex('PaletteBlue', 'fg'),
        orange = get_hex('PaletteOrange', 'fg'),
        fg = get_hex('PaletteFg', 'fg'),
        fg_alt = get_hex('PaletteFgAlt', 'fg'),
        bg_accent  = get_hex('PaletteBgAccent', 'fg'),
        bg_urgent = get_hex('PaletteBgUrgent', 'fg'),
        gray = get_hex('PaletteGray', 'fg'),
    }
    require('lualine').setup {
        options = {
            theme = 'auto',
            component_separators = { '' },
            section_separators = {left = '', right = ''},
            globalstatus = true
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {{'filetype', icon_only = true}, {'filename', path = 3}},
            lualine_c = {
                {
                    'branch',
                    icon = ''
                },
                {
                    'diff',
                    symbols = { added = '+', modified = '~', removed = '-' },
                    colored = false
                }
            },
            lualine_x = {},
            lualine_y = {
                {
                    -- Lsp server name
                    function()
                        local msg = 'No lsp('
                        local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                        local clients = vim.lsp.get_active_clients()
                        if next(clients) == nil then
                            return msg 
                        end
                        for _, client in ipairs(clients) do
                            local filetypes = client.config.filetypes
                            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                                return client.name
                            end
                        end
                        return msg
                    end,
                    separator = { left = "", right = "" }
                },
                {
                    'diagnostics',
                    source = { 'nvim_diagnostic' },
                    sections = { 'hint' },
                    diagnostics_color = { hint = { bg = colors.blue, fg = colors.bg_accent } },
                    always_visible = true,
                    separator = { left = "" }
                },
                {
                    'diagnostics',
                    source = { 'nvim_diagnostic' },
                    sections = { 'info' },
                    diagnostics_color = { info = { bg = colors.yellow, fg = colors.bg_accent } },
                    always_visible = true,
                    separator = { left = "" }
                },
                {
                    'diagnostics',
                    source = { 'nvim_diagnostic' },
                    sections = { 'warn' },
                    diagnostics_color = { warn = { bg = colors.orange, fg = colors.bg_accent } },
                    always_visible = true,
                    separator = { left = "" }

                },
                {
                    'diagnostics',
                    source = { 'nvim_diagnostic' },
                    sections = { 'error' },
                    diagnostics_color = { error = { bg = colors.red, fg = colors.bg_accent } },
                    always_visible = true,
                    separator = { left = "" },
                },

            },
            lualine_z = { '%l:%c %L┆%p%%' },
        }
    }
end
on_colorscheme_change()
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = '*',
  callback = on_colorscheme_change,
})

vim.cmd([[
    augroup lualine_augroup
        autocmd!
        autocmd User LspProgressStatusUpdated lua require("lualine").refresh()
    augroup END
]])
-- require('lualine').setup {
-- 	options = {
-- 		theme = 'auto',
-- 		component_separators = { '' },
-- 		section_separators = {left = '', right = ''},
-- 		globalstatus = true
-- 	},
-- 	sections = {
-- 		lualine_a = {'mode'},
-- 		lualine_b = {{'filetype', icon_only = true}, 'filename'},
-- 		lualine_c = {
-- 			{
-- 				'branch',
-- 				icon = ''
-- 			},
-- 			{
-- 				'diff',
-- 				symbols = { added = '+', modified = '~', removed = '-' },
-- 				colored = false
-- 			}
-- 		},
-- 		lualine_x = {},
-- 		lualine_y = {
--             {
-- 				-- Lsp server name
-- 				function()
-- 					local msg = 'No lsp('
-- 					local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
-- 					local clients = vim.lsp.get_active_clients()
-- 					if next(clients) == nil then
-- 						return msg 
-- 					end
-- 					for _, client in ipairs(clients) do
-- 						local filetypes = client.config.filetypes
-- 						if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
-- 							return client.name
-- 						end
-- 					end
-- 					return msg
-- 			    end,
--                 separator = { left = "", right = "" }
-- 			},
--             {
--                 'diagnostics',
--                 source = { 'nvim_diagnostic' },
--                 sections = { 'hint' },
--                 diagnostics_color = { hint = { bg = colors.blue, fg = colors.bg_accent } },
--                 always_visible = true,
--                 separator = { left = "" }
--             },
--             {
--                 'diagnostics',
--                 source = { 'nvim_diagnostic' },
--                 sections = { 'info' },
--                 diagnostics_color = { info = { bg = colors.yellow, fg = colors.bg_accent } },
--                 always_visible = true,
--                 separator = { left = "" }
--             },
--             {
--                 'diagnostics',
--                 source = { 'nvim_diagnostic' },
--                 sections = { 'warn' },
--                 diagnostics_color = { warn = { bg = colors.orange, fg = colors.bg_accent } },
--                 always_visible = true,
--                 separator = { left = "" }
--
--             },
--             {
--                 'diagnostics',
--                 source = { 'nvim_diagnostic' },
--                 sections = { 'error' },
--                 diagnostics_color = { error = { bg = colors.red, fg = colors.bg_accent } },
--                 always_visible = true,
--                 separator = { left = "" },
--             },
--
--         },
--         lualine_z = { '%l:%c %L┆%p%%' },
-- 	}
-- }
