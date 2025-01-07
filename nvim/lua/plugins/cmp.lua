local cmp = require 'cmp'

cmp.setup {
    completion = { completeopt = "menu,menuone" },

    snippet = {
        expand = function(args)
        require("luasnip").lsp_expand(args.body)
        end,
    },

    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),

        ["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
        },

        ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif require("luasnip").expand_or_jumpable() then
            require("luasnip").expand_or_jump()
        else
            fallback()
        end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif require("luasnip").jumpable(-1) then
            require("luasnip").jump(-1)
        else
            fallback()
        end
        end, { "i", "s" }),
    },

    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
    },
}

-- cmp.setup({
--     snippet = {
--         -- REQUIRED - you must specify a snippet engine
--         expand = function(args)
--             vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
--             -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
--             -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
--             -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
--         end
--     },
--     window = {
--         completion = cmp.config.window.bordered(),
--         documentation = cmp.config.window.bordered()
--     },
--     mapping = cmp.mapping.preset.insert({
--         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--         ['<C-f>'] = cmp.mapping.scroll_docs(4),
--         ['<C-Space>'] = cmp.mapping.complete(),
--         ['<C-e>'] = cmp.mapping.abort(),
--         ['<CR>'] = cmp.mapping.confirm({select = true}),
--         ["<Tab>"] = cmp.mapping(function(fallback)
--             if cmp.visible() then
--                 cmp.select_next_item()
--             else
--                 fallback()
--             end
--         end, {"i", "s"}),
--         ["<S-Tab>"] = cmp.mapping(function(fallback)
--             if cmp.visible() then
--                 cmp.select_prev_item()
--             else
--                 fallback()
--             end
--         end, {"i", "s"})
--     }),
--     sources = cmp.config.sources({
--         {name = 'nvim_lsp'}, {name = 'vsnip'} -- For vsnip users.
--     }, {{name = 'buffer'}, {name = 'nvim_lsp_signature_help'}})
-- })

-- -- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--     sources = cmp.config.sources({
--         {name = 'cmp_git'} -- You can specify the `cmp_git` source if you were installed it.
--     }, {{name = 'buffer'}})
-- })

-- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({'/', '?'}, {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = {{name = 'buffer'}}
-- })

-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})
-- })
