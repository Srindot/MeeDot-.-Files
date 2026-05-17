return {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
        require("toggleterm").setup({
            size = 20,
            -- Explicit notation for Alt + Space then t
            open_mapping = [[<A-Space>t]],
            hide_numbers = true,
            shade_terminals = false,
            start_in_insert = true,
            persist_size = true,
            direction = 'float',
            close_on_exit = true,
            float_opts = {
                border = 'curved',
                -- Must be 0 to avoid the "Black Box" on transparent setups
                winblend = 0,
            },
            highlights = {
                -- This forces the terminal to be transparent like your code
                NormalFloat = { link = 'Normal' },
                FloatBorder = { link = 'FloatBorder' },
            },
        })

        function _G.set_terminal_keymaps()
            local opts = { buffer = 0 }
            -- Mapping Alt + Space + t inside the terminal to close it
            vim.keymap.set('t', '<A-Space>t', [[<Cmd>ToggleTerm<CR>]], opts)
            -- Mapping Esc to enter normal mode for scrolling
            vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        end

        vim.api.nvim_create_autocmd("TermOpen", {
            pattern = "term://*",
            callback = function()
                _G.set_terminal_keymaps()
            end
        })
    end
}
