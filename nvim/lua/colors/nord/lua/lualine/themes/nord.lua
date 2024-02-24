local p = require('nord.palette')

return {
    normal = {
        a = { bg = p.green, fg = p.bg_urgent, gui = 'bold' },
        b = { bg = p.bg_accent, fg = p.fg },
        c = { bg = p.bg_alt, fg = p.fg_alt },
    },
    insert = {
        a = { bg = p.blue, fg = p.bg_urgent, gui = 'bold'},
        b = { bg = p.bg_accent, fg = p.fg },
        c = { bg = p.bg_alt, fg = p.fg_alt },
    },
    command = {
        a = { bg = p.orange, fg = p.bg_urgent, gui = 'bold' },
        b = { bg = p.bg_accent, fg = p.fg },
        c = { bg = p.bg_alt, fg = p.fg_alt },
    },
    terminal = {
        a = { bg = p.cyan, fg = p.bg_urgent, gui = 'bold' },
        b = { bg = p.bg_accent, fg = p.fg },
        c = { bg = p.bg_alt, fg = p.fg_alt },
    },
    visual = {
        a = { bg = p.magenta, fg = p.bg_urgent, gui = 'bold' },
        b = { bg = p.bg_accent, fg = p.fg },
        c = { bg = p.bg_alt, fg = p.fg_alt },
    },
    replace = {
        a = { bg = p.yellow, fg = p.bg_urgent, gui = 'bold' },
        b = { bg = p.bg_accent, fg = p.fg },
        c = { bg = p.bg_alt, fg = p.fg_alt },
    },
    inactive = {
        a = { bg = p.bg_alt, fg = p.fg },
        b = { bg = p.bg_alt, fg = p.fg },
        c = { bg = p.bg_alt, fg = p.fg_alt },
    },
}
