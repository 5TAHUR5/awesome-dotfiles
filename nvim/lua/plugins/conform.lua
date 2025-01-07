require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "pyink" },

        -- Conform will run the first available formatter
        javascript = { "prettierd", "prettier", "eslint_d" },
        typescript = { "prettierd", "prettier", "eslint_d" },
    },
    format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 500,
    },
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
      require("conform").format({ bufnr = args.buf })
    end,
})