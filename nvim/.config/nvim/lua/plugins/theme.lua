-- Catpuccin Theme | Applies Catpuccin Theme for all text and other structure.
return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            transparent_background = true,
            integrations = {
                treesitter = true,
                telescope = true,
                harpoon = true,
                mason = true,
                cmp = true,
                gitsigns = true,
                illuminate = true,
                indent_blankline = {
                    enabled = true,
                    colored_indent_levels = false,
                },
                native_lsp = {
                    enabled = true,
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "undercurl" },
                        warnings = { "undercurl" },
                        information = { "undercurl" },
                    },
                },
            }
        })

        vim.cmd.colorscheme "catppuccin"
    end
}
