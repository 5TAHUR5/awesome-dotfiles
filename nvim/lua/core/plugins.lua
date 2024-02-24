local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
        {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
-- or                              , branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
    -- {
    --     'nvim-telescope/telescope.nvim',
    --     tag = '0.1.1',
    --     dependencies = {'nvim-lua/plenary.nvim'}
    -- },
    {'mfussenegger/nvim-jdtls'},
    {'cooperuser/glowbeam.nvim'},
    {'rebelot/kanagawa.nvim'},
    {'nvim-treesitter/nvim-treesitter'},
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/cmp-buffer'},
    {'hrsh7th/cmp-path'},
    {'hrsh7th/cmp-cmdline'},
    {'hrsh7th/nvim-cmp'},
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons', 'linrongbin16/lsp-progress.nvim'
        }
    },
    {'nvim-tree/nvim-web-devicons'},
    {"williamboman/mason.nvim", build = ":MasonUpdate"},
    {"williamboman/mason-lspconfig.nvim"},
    {'akinsho/toggleterm.nvim', version = "*", config = true},
    {'windwp/nvim-autopairs'},
    {'Djancyp/outline'},
    {'terrortylor/nvim-comment'},
    {'windwp/nvim-ts-autotag'},
    {'hrsh7th/cmp-nvim-lsp-signature-help'}, {
        'linrongbin16/lsp-progress.nvim',
        event = {'VimEnter'},
        dependencies = {'nvim-tree/nvim-web-devicons'},
        config = function() require('lsp-progress').setup() end
    },
    { 'echasnovski/mini.starter', version = false },
    -- {
    --     'glepnir/dashboard-nvim',
    --     event = 'VimEnter',
    --     dependencies = {{'nvim-tree/nvim-web-devicons'}}
    -- },
    {"folke/which-key.nvim"},
       { 'hrsh7th/vim-vsnip' },
       {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
          "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        }
       },
	-- buffer
	{
		"willothy/nvim-cokeline",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true
	},
    -- themes
    -- {'navarasu/onedark.nvim'},
    -- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
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


    {'hrsh7th/vim-vsnip-integ'},
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump({
                        search = {
                        mode = function(str)
                            return "\\<" .. str
                        end,
                        },
                    })
                end,
                desc = "Flash",
            },
            {
                "S",
                mode = { "n", "o", "x" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Flash Treesitter Search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function()
                    require("flash").toggle()
                end,
            desc = "Toggle Flash Search",
            },
        },
    },
    ui = {
        size = { width = 0.9, height = 0.9 },
        border = { "┏", "━", "┓", "┃", "┛","━", "┗", "┃" },
    },
});
