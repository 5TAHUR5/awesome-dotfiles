local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable",
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    
    -- themes
    { dir = '~/.config/nvim/lua/colors/biscuit' },
	{ dir = '~/.config/nvim/lua/colors/mountain' },
	{ dir = '~/.config/nvim/lua/colors/gruvbox' },
	{ dir = '~/.config/nvim/lua/colors/everforest' },
	{ dir = '~/.config/nvim/lua/colors/catppuccin' },
	{ dir = '~/.config/nvim/lua/colors/stardew' },
    { dir = '~/.config/nvim/lua/colors/red_alarm' },
    { dir = '~/.config/nvim/lua/colors/edge' },
    { dir = '~/.config/nvim/lua/colors/alien_blood' },
    { dir = '~/.config/nvim/lua/colors/sonokai' },
    { dir = '~/.config/nvim/lua/colors/nord' },

    -- telescope
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {'stevearc/aerial.nvim'},

    -- statusline
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons', 'linrongbin16/lsp-progress.nvim'
        }
    },

    {'nvim-tree/nvim-web-devicons'},

    -- terminal
    {'akinsho/toggleterm.nvim', version = "*", config = true},
    
    {'windwp/nvim-autopairs'},
    {'Djancyp/outline'},
    {'terrortylor/nvim-comment'},
    {'windwp/nvim-ts-autotag'},
    {'folke/todo-comments.nvim'},
    {'mrjones2014/smart-splits.nvim'},
    {'stevearc/resession.nvim'},

    -- start page
    { 'echasnovski/mini.starter', version = false },
    
    -- which key
    {"folke/which-key.nvim"},
       { 'hrsh7th/vim-vsnip' },
       {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
          "nvim-tree/nvim-web-devicons",
        }
       },

	-- buffers
	{
		"willothy/nvim-cokeline",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true
	},

    -- treesitter
    {'nvim-treesitter/nvim-treesitter'},

    -- lsp
    {'neovim/nvim-lspconfig'},

    -- cmp
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/cmp-buffer'},
    {'hrsh7th/cmp-path'},
    {'hrsh7th/cmp-cmdline'},
    {'hrsh7th/nvim-cmp'},
    {'hrsh7th/cmp-vsnip'},
    {'hrsh7th/vim-vsnip'},
    {'L3MON4D3/LuaSnip'},
    {'saadparwaiz1/cmp_luasnip'},

    -- mason
    {'williamboman/mason.nvim'},

    -- conform
    {'stevearc/conform.nvim'},

    -- snippets
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
    },


});
