-- 1. DISABLE NETRW
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("nvim-tree").setup({
            hijack_netrw = true,
            -- FIX 1: This makes `nvim .` actually open the tree instead of a blank file!
            hijack_directories = {
                enable = true,
                auto_open = true,
            },
            update_focused_file = { enable = true },
            view = {
                width = 30,
                side = "right",
            },
        })

        -- Keybinds
        vim.keymap.set("n", "<leader>pv", ":NvimTreeFocus<CR>")
        vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")

        -- FIX 2: THE 1-SHOT QUIT.
        -- If NvimTree is the last window open, this kills it automatically.
        vim.api.nvim_create_autocmd("QuitPre", {
            callback = function()
                local tree_wins = {}
                local floating_wins = {}
                local wins = vim.api.nvim_list_wins()
                for _, w in ipairs(wins) do
                    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
                    if bufname:match("NvimTree_") ~= nil then
                        table.insert(tree_wins, w)
                    end
                    if vim.api.nvim_win_get_config(w).relative ~= '' then
                        table.insert(floating_wins, w)
                    end
                end
                if 1 == #wins - #floating_wins - #tree_wins then
                    for _, w in ipairs(tree_wins) do
                        vim.api.nvim_win_close(w, true)
                    end
                end
            end
        })
    end,
}
