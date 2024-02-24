vim.wo.number = true
vim.wo.relativenumber = true

vim.g.did_load_filetypes = 1
vim.g.formatoptions = "qrn1"
vim.opt.showmode = false
vim.opt.updatetime = 100
vim.wo.signcolumn = "yes:1"
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.wo.linebreak = true
vim.opt.virtualedit = "block"
vim.opt.undofile = true
vim.opt.shell = "/usr/bin/fish"

-- Mouse
vim.opt.mouse = "a"
vim.opt.mousefocus = true

-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Shorter messages
vim.opt.shortmess:append("c")

-- Indent Settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true

-- Fillchars
vim.opt.fillchars = {
    vert = "┃",
    fold = "t",
    vertright = "┣",
    vertleft = "┫",
    verthoriz = "┳",
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    eob = " ", -- suppress ~ at EndOfBuffer
    diff = "⣿", -- alternatives = ⣿ ░ ─ ╱
    msgsep = "━",
    foldopen = "▾",
    foldsep = "d",
    foldclose = "▸"
}

vim.opt.showtabline = 2

vim.cmd([[sign define DiagnosticSignError text=󰅚 texthl=DiagnosticSignError linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignWarn text=󰀪 texthl=DiagnosticSignWarn linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignInfo text=󰋽 texthl=DiagnosticSignInfo linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignHint text=󰌶 texthl=DiagnosticSignHint linehl= numhl=]])
-- vim.cmd([[highlight clear LineNr]])
-- vim.cmd([[highlight clear SignColumn]])
-- vim.cmd.colorscheme{'gruvbox'}
