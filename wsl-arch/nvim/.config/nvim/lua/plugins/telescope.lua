return {
    'nvim-telescope/telescope.nvim',
    -- FIX: Version 0.1.8 is the most stable for modern Arch/Neovim
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('telescope').setup({
            defaults = {
                -- THE CRASH FIX: Disabling treesitter in the previewer stops the
                -- 'ft_to_lang' nil value error you saw in the screenshot.
                preview = {
                    treesitter = false,
                },
                -- Keeps the search results clean for your project folders
                file_ignore_patterns = { "node_modules", ".git/", "target/", "build/" },
                prompt_prefix = "   ",
                selection_caret = "  ",
            }
        })
    end
}
