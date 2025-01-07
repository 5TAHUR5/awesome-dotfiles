local wk = require("which-key")


wk.setup({
    win = {
        border = { "┏", "━", "┓", "┃", "┛","━", "┗", "┃" },
    },
    icons = {
        group = vim.g.icons_enabled ~= false and "" or "+",
        rules = false,
        separator = "-",
    },
})

-- wk.register({
--     f = {
--         name = "Find",
--         f = {"Find File"},
--         b = {"Find Buffer"},
--         w = {"Find Text"}
--     },
--     e = {"File Manager"},
--     b = {name = "Buffer",
--         d = "Close current buffer",
--         n = "Focus next buffer",
--         v = "Focus previous buffer"
--     },
--     -- w = {"Save"},
--     t = {"Open terminal"},
--     h = {"No highlight"},
--     -- g = {name = "Git", b = "Branches", c = "Commits", s = "Status"},
--     c = {name = "Comment", l = "Comment Line"},
--     l = {
--         name = "LSP",
--         d = "Diagnostic",
--         -- D = "Hover diagnostic",
--         -- f = "Format",
--         -- r = "Rename",
--         -- a = "Action",
--         -- s = "Symbol"
--     }
-- }, {prefix = "<leader>"})
