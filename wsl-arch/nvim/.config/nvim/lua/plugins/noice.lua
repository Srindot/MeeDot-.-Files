return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        -- nvim-notify handles the actual "bubbles" on the side
        {
            "rcarriga/nvim-notify",
            opts = {
                background_colour = "#000000", -- Helps with transparency in Mocha
                timeout = 3000,
            },
        },
    },
    opts = {
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.set_autofile_type"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
            },
        },
        presets = {
            bottom_search = true,
            command_palette = true, -- The fancy floating center bar
            long_message_to_split = true,
            inc_rename = false,
            lsp_doc_border = true, -- Adds nice borders to LSP hover windows
        },
        -- This section ensures the floating window looks "Mocha-like"
        views = {
            cmdline_popup = {
                position = {
                    row = 5,
                    col = "50%",
                },
                size = {
                    width = 60,
                    height = "auto",
                },
            },
        },
    },
}
