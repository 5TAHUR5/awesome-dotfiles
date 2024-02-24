require("mason").setup({
    ui = {
        height = 0.7,
        border = {"┏", "━", "┓", "┃", "┛", "━", "┗", "┃"},
        icons = {
        package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})
require("mason-lspconfig").setup()
