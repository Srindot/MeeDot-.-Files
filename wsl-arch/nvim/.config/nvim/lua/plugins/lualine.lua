-- LuaLine | A Plugin for status bar below for nvim
return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- 1. Safety Switch: Wait until the UI is ready before loading the bar
    event = "VeryLazy",

    config = function()
        require("lualine").setup({
            options = {
                -- 2. Safety Switch: "auto" tells Lualine to just copy
                -- whatever colors are currently on the screen (Catppuccin).
                theme = "auto",
                component_separators = '|',
                section_separators = '',
            }
        })
    end
}
