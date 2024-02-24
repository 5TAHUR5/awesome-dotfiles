local p = require('everforest.palette')
local M = {}

function M.set_colors()

	local theme = {
		-- base highlights
		Normal = { fg = p.fg, bg = p.bg },
		NormalNC = { fg = p.fg, bg = p.bg },
		SignColumn = { fg = p.bg_alt, bg = p.bg_urgent },
		FoldColumn = { fg = p.fg_alt, bg = p.bg },
		VertSplit = { fg = p.accent, bg = p.bg },
		Folded = { fg = p.fg, bg = p.bg },
		EndOfBuffer = { fg = p.bg },
		ColorColumn = { bg = p.bg_accent },
		Conceal = { fg = p.fg_alt },
		QuickFixLine = { bg = p.bg },
		Terminal = { fg= p.fg, bg = p.fg },

		IncSearch = { fg = p.bg, bg = p.cyan },
		Search = { fg = p.bg, bg = p.cyan },
		Visual = { fg = p.bg, bg = p.cyan },
		VisualNOS = { bg = p.bg },

		Cursor = { fg = p.fg, bg = p.fg },
		CursorColumn = { bg = p.bg_alt },
		CursorIM = { fg = p.fg, bg = p.fg },
		CursorLine = { fg = p.red,  bg = p.bg_alt },
		CursorLineNr = { fg = p.accent, bg = p.bg_accent, fmt = 'bold' },
		lCursor = { fg = p.fg, bg = p.fg },
		LineNr = { fg = p.fg, bg = p.bg_alt },
		TermCursor = { fg = p.fg, bg = p.fg },
		TermCursorNC = { fg = p.fg, bg = p.fg },
        WinSeparator = { fg = p.accent, bg = p.bg },

		DiffAdd = { fg = p.green, bg = p.bg },
		DiffChange = { fg = p.yellow, bg = p.bg },
		DiffDelete = { fg = p.red, bg = p.bg },
		DiffText = { fg = p.fg, bg = p.bg },

		Directory = { fg = p.blue },
		ErrorMsg = { fg = p.red },
		WarningMsg = { fg = p.yellow },
		ModeMsg = { fg = p.fg },
		MoreMsg = { fg = p.fg },
		MsgArea = { fg = p.fg, bg = p.bg },
		MsgSeparator = { fg = p.bg_urgent, bg = p.bg },
		Question = { fg = p.cyan },

        PaletteBg = { fg = p.bg, bg = p.bg },
        PaletteBgAlt = { fg = p.bg_alt, bg = p.bg_alt },
        PaletteBgUrgent = { fg = p.bg_urgent, bg = p.bg_urgent },
        PaletteBgAccent = { fg = p.bg_accent, bg = p.bg_accent },
        PaletteFg = { fg = p.fg, bg = p.fg},
        PaletteFgAlt = { fg = p.fg_alt, bg = p.fg_alt },
        PaletteGray = { fg = p.gray, bg = p.gray },
        PaletteOrange = { fg = p.orange, bg = p.orange},
        PaletteRed = { fg = p.red, bg = p.red},
        PaletteGreen = { fg = p.green, bg = p.green },
        PaletteYellow = { fg = p.yellow, bg = p.yellow },
        PaletteBlue = { fg = p.blue, bg = p.blue },
        PaletteMagenta = { fg = p.magenta, bg = p.magenta },
        PaletteCyan = { fg = p.cyan, bg = p.cyan },
        PaletteAccent = { fg = p.accent, bg = p.accent },

		MatchParen = { fg = p.yellow },
		NonText = { fg = p.fg_alt },
		SpecialKey = { fg = p.fg_alt },
		Whitespace = { fg = p.bg_alt },

		Pmenu = { fg = p.fg, bg = p.bg_alt },
		PmenuSbar = { bg = p.bg_urgent },
		PmenuSel = { fg = p.bg, bg = p.cyan },
		PmenuThumb = { bg = p.cyan },
		WildMenu = { fg = p.fg, bg = p.bg_alt },
		NormalFloat = { fg = p.fg, bg = p.bg_alt },

		TabLine = { fg = p.fg, bg = p.bg },
		TabLineFill = { fg = p.fg, bg = p.bg },
		TabLineSel = { fg = p.cyan, bg = p.bg },
		StatusLine = { fg = p.fg, bg = p.bg },
		StatusLineNC = { bg = p.bg, fg = p.bg },

		SpellBad = { fg = p.red },
		SpellCap = { fg = p.blue },
		SpellLocal = { fg = p.cyan },
		SpellRare = { fg = p.magenta },

		-- syntax
		Boolean = { fg = p.orange },
		Character = { fg = p.orange },
		Conditional = { fg = p.magenta },
		Constant = { fg = p.blue },
		Debug = { fg = p.blue },
		Define = { fg = p.red },
		Error = { fg = p.red },
		Exception = { fg = p.magenta },
		Float = { fg = p.yellow },
		FloatBorder = { fg = p.accent, bg = p.bg },
        FloatTitle = { fg = p.accent, bg = p.bg },
		Function = { fg = p.blue },
		Include = { fg = p.red },
		Keyword = { fg = p.red },
		Label = { fg = p.blue },
		Macro = { fg = p.blue },
		Number = { fg = p.yellow },
		Operator = { fg = p.red },
		PreCondit = { fg = p.blue },
		PreProc = { fg = p.blue },
		Repeat = { fg = p.magenta },
		Special = { fg = p.blue },
		SpecialChar = { fg = p.orange },
		Statement = { fg = p.blue },
		Storage = { fg = p.blue },
		StorageClass = { fg = p.blue },
		String = { fg = p.green },
		Structure = { fg = p.blue },
		Substitute = { fg = p.cyan },
		Tag = { fg = p.red },
		Title = { fg = p.magenta },
		Type = { fg = p.blue },
		Typedef = { fg = p.blue },
		Variable = { fg = p.blue },

		Comment = { fg = p.fg_alt, fmt = 'italic' },
		SpecialComment = { fg = p.fg_alt },
		Todo = { fg = p.fg_alt },
		Delimiter = { fg = p.fg },
		Identifier = { fg = p.fg },
		Ignore = { fg = p.fg },
		Underlined = { underline = true },

		-- bufferline.nvim: https://github.com/akinsho/bufferline.nvim
		BufferLineFill = { fg = p.bg, bg = p.bg },
		BufferLineIndicatorSelected = { fg = p.cyan },

		-- Diagnostic
		DiagnosticError = { fg = p.red, bg = p.bg_urgent },
		DiagnosticHint = { fg = p.cyan, bg = p.bg_urgent },
		DiagnosticInfo = { fg = p.blue, bg = p.bg_urgent },
		DiagnosticWarn = { fg = p.yellow, bg = p.bg_urgent },

		-- diff
		diffAdded = { fg = p.blue },
		diffChanged = { fg = p.yellow },
		diffFile = { fg = p.fg },
		diffIndexLine = { fg = p.fg },
		diffLine = { fg = p.fg },
		diffNewFile = { fg = p.magenta },
		diffOldFile = { fg = p.orange },
		diffRemoved = { fg = p.red },

		-- gitsigns: https://github.com/lewis6991/gitsigns.nvim
		GitSignsAdd = { fg = p.green },
		GitSignsChange = { fg = p.yellow },
		GitSignsDelete = { fg = p.red },

		-- indent-blankline.nvim: https://github.com/lukas-reineke/indent-blankline.nvim
		IndentBlanklineChar = { fg = p.bg_alt },

		-- nvim-tree.lua: https://github.com/nvim-tree/nvim-tree.lua
        NvimTreeWinSeparator = { fg = p.accent, bg = p.bg },
		NvimTreeEmptyFolderName = { fg = p.fg_alt },
		NvimTreeEndOfBuffer = { fg = p.fg, bg = p.bg },
		NvimTreeEndOfBufferNC = { fg = p.fg, bg = p.bg },
		NvimTreeFolderIcon = { fg = p.fg, bg = p.bg },
		NvimTreeFolderName = { fg = p.fg },
		NvimTreeGitDeleted = { fg = p.red },
		NvimTreeGitDirty = { fg = p.red },
		NvimTreeGitNew = { fg = p.blue },
		NvimTreeImageFile = { fg = p.fg_alt },
		NvimTreeIndentMarker = { fg = p.accent },
		NvimTreeNormal = { fg = p.fg, bg = p.bg },
		NvimTreeNormalNC = { fg = p.fg, bg = p.bg },
        NvimTreeCursorLineNr = { fg = p.accent, bg = p.bg_urgent, fmt = 'bold' },
        NvimTreeCursorLine = { bg = p.bg_alt, fmt = 'bold' },
		NvimTreeOpenedFolderName = { fg = p.accent },
		NvimTreeRootFolder = { fg = p.accent, fmt = 'bold' },
		NvimTreeSpecialFile = { fg = p.red },
		NvimTreeStatusLineNC = { bg = p.bg, fg = p.bg },
		NvimTreeSymlink = { fg = p.blue },
		NvimTreeVertSplit = { fg = p.bg, bg = p.bg },

		-- nvim-treesitter: https://github.com/nvim-treesitter/nvim-treesitter
        ["@annotation"] = { fg = p.magenta },
		["@attribute"] = { fg = p.magenta },
		["@boolean"] = { fg = p.magenta },
		["@character"] = { fg = p.cyan },
   		["@character.special"] = { fg = p.yellow },
		["@comment"] = { fg = p.gray, fmt = 'italic' },
		["@comment.error"] = { fg = p.red },
		["@comment.note"] = { fg = p.green },
		["@comment.todo"] = { fg = p.blue },
        ["@comment.warning"] = { fg = p.yellow },
        ["@conceal"] = { fg = p.gray },
		["@conditional"] = { fg = p.red },
		["@constant"] = { fg = p.fg },
		["@constant.builtin"] = { fg = p.magenta, fmt = 'italic' },
		["@constant.macro"] = { fg = p.magenta, fmt = 'italic' },
		["@constructor"] = { fg = p.green },
        ["@debug"] = { fg = p.orange },
        ["@define"] = { fg = p.magenta },
        ["@diff.delta"] = { fg = p.blue },
        ["@diff.minus"] = { fg = p.red},
        ["@diff.plus"] = { fg = p.green },
		["@exception"] = { fg = p.red },
		["@field"] = { fg = p.blue },
		["@float"] = { fg = p.magenta },
		["@function"] = { fg = p.green },
		["@function.builtin"] = { fg = p.green },
		["@function.macro"] = { fg = p.green },
        ["@function.call"] = { fg = p.green },
        ["@function.method"] = { fg = p.green },
        ["@function.method.call"] = { fg = p.green },
		["@include"] = { fg = p.red },
		["@keyword"] = { fg = p.red },
		["@keyword.function"] = { fg = p.red },
		["@keyword.operator"] = { fg = p.red },
		["@keyword.return"] = { fg = p.red },
        ["@keyword.debug"] = { fg = p.orange },
        ["@keyword.conditional"] = { fg = p.red },
        ["@keyword.directive"] = { fg = p.magenta },
        ["@keyword.directive.define"] = { fg = p.magenta },
        ["@keyword.exception"] = { fg = p.red },
        ["@keyword.import"] = { fg = p.magenta },
        ["@keyword.repeat"] = { fg = p.red },
        ["@keyword.storage"] = { fg = p.orange },
		["@label"] = { fg = p.orange },
        ["@markup.emphasis"] = { fg = p.none },
        ["@markup.environment"] = { fg = p.cyan },
        ["@markup.environment.name"] = { fg = p.yellow },
        ["@markup.heading"] = { fg = p.orange },
        ["@markup.link"] = { fg = p.blue },
        ["@markup.link.label"] = { fg = p.yellow },
        ["@markup.link.url"] = { fg = p.blue },
        ["@markup.list"] = { fg = p.blue },
        ["@markup.list.checked"] = { fg = p.green },
        ["@markup.list.unchecked"] = { fg = p.gray },
        ["@markup.math"] = { fg = p.blue },
        ["@markup.note"] = { fg = p.green },
        ["@markup.quote"] = { fg = p.gray },
        ["@markup.raw"] = { fg = p.green },
        ["@markup.strike"] = { fg = p.gray },
        ["@markup.strong"] = { fg = p.none },
        ["@markup.underline"] = { fg = p.none },
        ["@math"] = { fg = p.blue },
        ["@method"] = { fg = p.green },
        ["@method.call"] = { fg = p.green },
        ["@module"] = { fg = p.yellow, fmt = 'italic' },
        ["@namespace"] = { fg = p.yellow, fmt = 'italic' },
        ["none"] = { fg = p.fg },
		["@number"] = { fg = p.magenta },
		["@number.float"] = { fg = p.magenta },
		["@operator"] = { fg = p.orange },
		["@parameter"] = { fg = p.fg },
		["@parameter.reference"] = { fg = p.fg },
        ["@preproc"] = { fg = p.blue },
		["@property"] = { fg = p.cyan },
		["@punctuation.bracket"] = { fg = p.fg },
		["@punctuation.delimiter"] = { fg = p.gray },
		["@punctuation.special"] = { fg = p.blue },
		["@repeat"] = { fg = p.red },
        ["@storageclass"] = { fg = p.orange },
        ["@storageclass.lifetime"] = { fg = p.orange },
        ["@strike"] = { fg = p.gray },
		["@string"] = { fg = p.cyan },
		["@string.escape"] = { fg = p.green },
		["@string.regex"] = { fg = p.green },
		["@string.special"] = { fg = p.yellow },
		["@string.special.symbol"] = { fg = p.fg },
		["@string.special.uri"] = { fg = p.blue },
		["@symbol"] = { fg = p.red },
		["@tag"] = { fg = p.orange },
		["@tag.attribute"] = { fg = p.green },
		["@tag.delimiter"] = { fg = p.green },
		["@type"] = { fg = p.yellow, fmt = 'italic' },
		["@type.builtin"] = { fg = p.yellow, fmt = 'italic' },
		["@type.definition"] = { fg = p.yellow, fmt = 'italic' },
		["@type.qualifier"] = { fg = p.orange },
		["@variable"] = { fg = p.fg },
		["@variable.builtin"] = { fg = p.magenta, fmt = 'italic' },
		["@variable.member"] = { fg = p.blue },
		["@variable.parameter"] = { fg = p.fg },
        ["@uri"] = { fg = p.blue },
        ["@todo"] = { fg = p.blue },
		["@text"] = { fg = p.fg },
		["@text.danger"] = { fg = p.red },
        ["@text.diff.add"] = { fg = p.green },
        ["@text.diff.delete"] = { fg = p.red },
        ["@text.emphasis"] = { fg = p.none, fmt = 'italic' },
        ["@text.environment"] = { fg = p.cyan },
        ["@text.environment.name"] = { fg = p.yellow },
        ["@text.literal"] = { fg = p.green},
        ["@text.math"] = { fg = p.blue },
        ["@text.note"] = { fg = p.green },
        ["@text.reference"] = { fg = p.cyan },
        ["@text.strike"] = { fg = p.gray },
        ["@text.strong"] = { fg = p.none, fmt = 'bold' },
        ["@text.title"] = { fg = p.orange },
        ["@text.todo"] = { fg = p.bg, bg = p.blue },
        ["@text.todo.checked"] = { fg = p.green },
        ["@text.todo.unchecked"] = { fg = p.gray },
        ["@text.underline"] = { fg = p.none },
        ["@text.uri"] = { fg = p.blue },
        ["@text.warning"] = { fg = p.yellow },

		--["@text.emphasis"]
		--["@text.environment.name"]
		--["@text.environtment"]
		--["@text.literal"]
		--["@text.math"]
		--["@text.note"]
		--["@text.reference"]
		--["@text.strike"]
		--["@text.strong"]
		--["@text.title"]
		--["@text.underline"]
		--["@text.uri"]
		--["@text.warning"]

		-- LSP semantic tokens
		["@lsp.type.comment"] = { link = "@comment" },
		["@lsp.type.enum"] = { link = "@type" },
		["@lsp.type.interface"] = { link = "Identifier" },
		["@lsp.type.keyword"] = { link = "@keyword" },
		["@lsp.type.namespace"] = { link = "@namespace" },
		["@lsp.type.parameter"] = { link = "@parameter" },
		["@lsp.type.property"] = { link = "@property" },
		["@lsp.type.variable"] = {}, -- use treesitter styles for regular variables
		["@lsp.typemod.method.defaultLibrary"] = { link = "@function.builtin" },
		["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
		["@lsp.typemod.operator.injected"] = { link = "@operator" },
		["@lsp.typemod.string.injected"] = { link = "@string" },
		["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
		["@lsp.typemod.variable.injected"] = { link = "@variable" },
        LspInfoBorder = { fg = p.accent, bg = p.bg },

        -- mini starter
        MiniStarterCurrent = {},
        MiniStarterFooter = {fg = p.blue, fmt = 'italic'},
        MiniStarterHeader = {fg = p.accent },
        MiniStarterInactive = {},
        MiniStarterItem = {fg = p.fg},
        MiniStarterItemPrefix = {fg = p.orange},
        MiniStarterSection = {fg = p.cyan},
        MiniStarterQuery = {},

		-- telescope.nvim: https://github.com/nvim-telescope/telescope.nvim
        TelescopeBorder = { fg = p.red},
        TelescopePromptBorder = { fg = p.accent },
        TelescopeResultsBorder = { fg = p.accent },
        TelescopePreviewBorder = { fg = p.accent },
		TelescopeNormal = { fg = p.fg, bg = p.bg },
		TelescopeSelection = { fg = p.bg, bg = p.yellow },
	}

	vim.g.terminal_color_0 = p.bg
	vim.g.terminal_color_1 = p.red
	vim.g.terminal_color_2 = p.green
	vim.g.terminal_color_3 = p.yellow
	vim.g.terminal_color_4 = p.blue
	vim.g.terminal_color_5 = p.magenta
	vim.g.terminal_color_6 = p.cyan
	vim.g.terminal_color_7 = p.fg
	vim.g.terminal_color_8 = p.fg_alt
	vim.g.terminal_color_9 = p.red
	vim.g.terminal_color_10 = p.green
	vim.g.terminal_color_11 = p.yellow
	vim.g.terminal_color_12 = p.blue
	vim.g.terminal_color_13 = p.magenta
	vim.g.terminal_color_14 = p.cyan
	vim.g.terminal_color_15 = p.fg

	return theme
end

return M
