return {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,    -- Make sure we load this during startup
    priority = 1000, -- Make sure to load this before all the other start plugins
    config = function()
        require("rose-pine").setup({
            styles = {
                transparency = true, -- This is the magic toggle
            }
        })

        vim.cmd("colorscheme rose-pine")
    end
}

-- -- Catppuccin Theme | Applies Catppuccin Theme
--
-- return {
--     "catppuccin/nvim",
--     name = "catppuccin",
--     priority = 1000, -- Load this before everything else
--     lazy = false,    -- Load on startup
--     config = function()
--         require("catppuccin").setup({
--             flavour = "mocha", -- Set to dark Mocha flavor
--             transparent_background = true,
--             integrations = {
--                 treesitter = true,
--                 telescope = true,
--                 harpoon = true,
--                 mason = true,
--                 cmp = true,
--                 gitsigns = true,
--                 illuminate = true,
--                 -- These three make Noice and Notify look like Catppuccin
--                 noice = true,
--                 notify = true,
--                 native_notify = true,
--                 indent_blankline = {
--                     enabled = true,
--                 },
--                 native_lsp = {
--                     enabled = true,
--                     underlines = {
--                         errors = { "undercurl" },
--                         hints = { "undercurl" },
--                         warnings = { "undercurl" },
--                         information = { "undercurl" },
--                     },
--                 },
--             }
--         })
--
--         -- Turn on the theme
--         vim.cmd.colorscheme "catppuccin"
--     end
-- }
