local get_hex = require('cokeline.hlgroups').get_hl_attr

require('cokeline').setup({
	default_hl = {
		fg = function(buffer)
			return get_hex('PaletteFg', 'fg')-- return buffer.is_focused and get_hex('PaletteBgAccent', 'fg') or get_hex('PaletteBg', 'fg')
		end,
		bg = function(buffer)
            -- return get_hex('PaletteFgAlt', 'fg')
			return buffer.is_focused and get_hex('PaletteBg', 'fg') or get_hex('PaletteBgAlt', 'fg')
		end,
    },
	fill_hl = 'PaletteBgAccent',
	sidebar = {
		filetype = {'NvimTree'},
		components = {
            {
                text = '',
                fg = function(buffer)
                    return buffer.is_focused and get_hex('PaletteAccent', 'fg') or get_hex('PaletteFgAlt', 'fg')
                end
            },
			{
				text = '  NvimTree                            ',
                bold = true,
                fg = get_hex('PaletteFg', 'fg'),
                truncation = {
                    direction = 'left',
                },
			},
            {
                text = '',
                fg = function(buffer)
                    return buffer.is_focused and get_hex('PaletteAccent', 'fg') or get_hex('PaletteFgAlt', 'fg')
                end
            }
		}
	},
	components = {
		{
			text = '',
			fg = function(buffer)
		        return buffer.is_focused and get_hex('PaletteAccent', 'fg') or get_hex('PaletteFgAlt', 'fg')
		    end
		},
        {
            text = function(buffer)
                return " " .. buffer.devicon.icon
            end,
            fg = function(buffer)
                return buffer.devicon.color
            end,
        },
        {
            text = function(buffer) return buffer.filename end,
            fg = function(buffer)
                return buffer.diagnostics.errors > 0 and get_hex('PaletteRed', 'fg') or get_hex('PaletteFg', 'fg')
            end
        },
		{
			text = function(buffer) return buffer.is_modified and '  ' or '   ' end,
			fg = function(buffer) return get_hex('PaletteOrange', 'fg') end
		},
        {
            text = '',
            fg = function(buffer)
		        return buffer.is_focused and get_hex('PaletteAccent', 'fg') or get_hex('PaletteFgAlt', 'fg')
		    end
        }
	}
})
