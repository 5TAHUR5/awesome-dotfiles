local statuss, starter = pcall(require, "mini.starter")
local statusl, lazy = pcall(require, 'lazy')
if not statuss and not statusl then
	return
end

local package_manager_stats = { name = '', count = 0, loaded = 0, time = 10.0 }
package_manager_stats.name = 'lazy'
package_manager_stats.loaded = lazy.stats().loaded
package_manager_stats.count = lazy.stats().count
package_manager_stats.time = lazy.stats()

local function default_header()
    return table.concat({
        [[┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓]],
        [[┃          /\                                                          ▀████┃]],
        [[┃         /**\                               /\                          ▀▀█┃]],
        [[┃        /****\   /\                     _  /**\                _           ┃]],
        [[┃       /      \ /**\        _          /*\/****\     /\   __  /*\   _      ┃]],
        [[┃      /  /\    /    \      /*\    /\  /  /    /\\   /  \ /**\/  /\ /*\     ┃]],
        [[┃     /  /  \  /      \    /***\/\/  \/  /  /\/  \/\/    V   /  /  \   \    ┃]],
        [[┃    /  /    \/ /\     \  /     \ \  /  /  /**\  /  \   /   //\/    \   \   ┃]],
        [[┃   /  /      \/  \/\   \/      /\ \/  /  /    \     \ /   //  \         \  ┃]],
        [[┃__/__/_______/___/__\___\_____/__\_\_/__/______\_____/___//____\_________\_┃]],
        [[┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛]],
    }, "\n")
end

starter.setup({
	content_hooks = {
		starter.gen_hook.adding_bullet(""),
        starter.gen_hook.padding(0, 2),
		starter.gen_hook.aligning("center", "top"),
	},
	evaluate_single = true,
	footer = 'Plugins(Lazy): ' .. package_manager_stats.loaded .. ' loaded / ' .. package_manager_stats.count .. ' installed',
	header = default_header,
	query_updaters = [[abcdefghilmoqrstuvwxyz0123456789_-,.ABCDEFGHIJKLMOQRSTUVWXYZ]],
	items = {
   		{ action = ":NvimTreeToggle<CR>", name = "e: Open nvim-tree", section = "Neovim" },
        { action = ":Telescope find_files", name = "f: Telescope: find from file name", section = "Neovim"},
        { action = ":Telescope live_grep", name = "w: Telescope: find from text", section = "Neovim"},
		{ action = ":Lazy", name = "l: Open Lazy", section = "Neovim" },
   		{ action = ":ToggleTerm direction=float", name = "t: Open terminal", section = "Neovim" },
		{ action = "qall!", name = "q: Quit Neovim", section = "Neovim" },
        { action = ":colorscheme everforest", name = "c1: Everforest theme", section = "Themes"},
        { action = ":colorscheme biscuit", name = "c2: Biscuit theme", section = "Themes"},
        { action = ":colorscheme catppuccin", name = "c3: Catppuccin theme", section = "Themes"},
        { action = ":colorscheme gruvbox", name = "c4: Gruvbox theme", section = "Themes"},
        { action = ":colorscheme mountain", name = "c5: Mountain theme", section = "Themes"},
        { action = ":colorscheme stardew", name = "c6: Stardew theme", section = "Themes"},
        { action = ":colorscheme nord", name = "c7: Nord theme", section = "Themes"},
        { action = ":colorscheme edge", name = "c8: Edge theme", section = "Themes"},
        { action = ":colorscheme sonokai", name = "c9: Sonokai theme", section = "Themes"},
        { action = ":colorscheme red_alarm", name = "ca: RedAlarm theme", section = "Themes"},
        { action = ":colorscheme alien_blood", name = "cb: AlienBlood theme", section = "Themes"},
	},
})
