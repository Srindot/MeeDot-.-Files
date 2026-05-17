return {
    "kylechui/nvim-surround",
    version = "*", -- This ensures you stay on the modern version
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Leave this empty or put non-keymap settings here
        })

        -- This is the "New Way" to set custom keys in v4
        vim.keymap.set("n", "s", "<Plug>(nvim-surround-normal)", { desc = "Add surround" })
        vim.keymap.set("n", "ss", "<Plug>(nvim-surround-normal-cur)", { desc = "Add surround line" })
        vim.keymap.set("v", "s", "<Plug>(nvim-surround-visual)", { desc = "Add surround (visual)" })

        -- Keep these as defaults or change them if you like
        vim.keymap.set("n", "ds", "<Plug>(nvim-surround-delete)", { desc = "Delete surround" })
        vim.keymap.set("n", "cs", "<Plug>(nvim-surround-change)", { desc = "Change surround" })
    end,
}
