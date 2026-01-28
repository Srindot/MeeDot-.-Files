-- LuaLine | A Plugin for status bar below for nvim
return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    config = function()
        require("lualine").setup({
            options = {
                theme = "catppuccin",
                component_separators = '|',
                section_separators = '',
            }
        })
    end
}
