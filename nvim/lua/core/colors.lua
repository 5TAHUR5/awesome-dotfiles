vim.opt.termguicolors = true

function SetColor(color)
    color = color or "everforest"
    vim.cmd.colorscheme(color)

    -- vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
    -- vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none"})
    -- vim.api.nvim_set_hl(0, "ColorColumn", {bg = "none"})
    -- vim.api.nvim_set_hl(0, "LineNr", {bg = "none"})
end

-- SetColor('kanagawa-wave')
-- SetColor('catppuccin') 
-- SetColor('catppuccin-latte')
-- SetColor('catppuccin-frappe')
-- SetColor('catppuccin-macchiato')
-- SetColor('catppuccin-mocha')
SetColor('everforest')
-- SetColor('mountain')
