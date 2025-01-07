local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Sntup language servers.
local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.ts_ls.setup {}
lspconfig.prismals.setup {}
lspconfig.emmet_ls.setup {}
lspconfig.lua_ls.setup {}
lspconfig.cssls.setup {
    capabilities = capabilities
}
lspconfig.golangci_lint_ls.setup {}
lspconfig.rust_analyzer.setup {
  settings = {
    ['rust-analyzer'] = {
            diagnostics = {
                enable = true,
                experimental = {
                    enable = true,
                },
            },
    },
  },
}

require("aerial").setup({
    attach_mode = "global",
    backends = { "lsp", "treesitter", "markdown", "man" },
    layout = { min_width = 28 },
    show_guides = true,
    filter_kind = false,
    guides = {
        mid_item = "┣ ",
        last_item = "┗ ",
        nested_top = "┃ ",
        whitespace = "  ",
    },
    -- optionally use on_attach to set keymaps when aerial has attached to a buffer
    on_attach = function(bufnr)
      -- Jump forwards/backwards with '{' and '}'
      vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
      vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
    end,
})



local function diagnostic_goto(dir, severity)
    local go = vim.diagnostic["goto_" .. (dir and "next" or "prev")]
    if type(severity) == "string" then severity = vim.diagnostic.severity[severity] end
    return function() go { severity = severity } end
end

vim.keymap.set('n', '[d', diagnostic_goto(false), { desc = "Previous diagnostic" })
vim.keymap.set('n', ']d', diagnostic_goto(true), { desc = "Next diagnostic" })
vim.keymap.set('n', '[e', diagnostic_goto(false, "ERROR"), { desc = "Previous error" })
vim.keymap.set('n', ']e', diagnostic_goto(true, "ERROR"), { desc = "Next error" })
vim.keymap.set('n', '[w', diagnostic_goto(false, "WARN"), { desc = "Previous warning" })
vim.keymap.set('n', ']w', diagnostic_goto(true, "WARN"), { desc = "Next warning" })


vim.keymap.set('n', '<leader>lS', require("aerial").toggle, { desc = "Symbols outline" })
vim.keymap.set('n', '<leader>ld', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        local opts = {buffer = ev.buf}

        vim.keymap.set({'n', 'v'}, '<Leader>la', vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code action" })
        vim.keymap.set('n', '<Leader>lf', function() vim.lsp.buf.format {async = true} end, { buffer = ev.buf, desc = "Format buff" })
        vim.keymap.set('n', '<Leader>lR', vim.lsp.buf.references, { buffer = ev.buf, desc = "Search references" })
        vim.keymap.set('n', '<Leader>lr', vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename current symbol" })
        vim.keymap.set('n', '<Leader>lG', vim.lsp.buf.workspace_symbol, { buffer = ev.buf, desc = "Search workspace symbols" })
        -- vim.keymap.set('n', '<Leader>', vim., opts, { desc = "" })
        -- vim.keymap.set('n', '<Leader>', vim., opts, { desc = "" })
        -- vim.keymap.set('n', '<Leader>', vim., opts, { desc = "" })
        -- vim.keymap.set('n', '<Leader>', vim., opts, { desc = "" })
        -- vim.keymap.set('n', '<Leader>', vim., opts, { desc = "" })


        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        -- vim.keymap
        --     .set('n', '<Leader>sa', vim.lsp.buf.add_workspace_folder, opts)
        -- vim.keymap.set('n', '<Leader>sr', vim.lsp.buf.remove_workspace_folder,
        --                opts)
        -- vim.keymap.set('n', '<Leader>sl', function()
        --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        -- end, opts)
        -- vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
        -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    end
})