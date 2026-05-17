return {
    "epwalsh/obsidian.nvim",
    version = "*", -- Use latest release
    lazy = true,
    ft = "markdown", -- Only loads when you open a markdown file
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("obsidian").setup({
            -- 1. YOUR WORKSPACE (Link this to your actual vault folder)
            workspaces = {
                {
                    name = "brain",
                    path = "~/notes/brain", -- CHANGE THIS to your actual path!
                },
            },

            -- 2. DAILY NOTES (Perfect for tracking Hackathon progress)
            daily_notes = {
                folder = "dailies",
                date_format = "%Y-%m-%d",
            },

            -- 3. COMPLETION
            completion = {
                nvim_cmp = true, -- If you use cmp for autocompletion
                min_chars = 2,
            },

            -- 4. UI SETTINGS (Makes checkboxes and links look clean)
            ui = {
                enable = true,
                update_debounce = 200,
                checkboxes = {
                    [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
                    ["x"] = { char = "", hl_group = "ObsidianDone" },
                },
            },

            -- 5. PURE CONVENIENCE
            -- Automatically pick a nice name for new notes
            note_id_func = function(title)
                if title ~= nil then
                    return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                else
                    return tostring(os.time())
                end
            end,
        })

        -- KEYBINDS
        -- Create a new note
        vim.keymap.set("n", "<leader>on", ":ObsidianNew<CR>", { desc = "New Obsidian Note" })
        -- Search for notes (Requires Telescope)
        vim.keymap.set("n", "<leader>os", ":ObsidianSearch<CR>", { desc = "Search Obsidian Notes" })
        -- Follow a link [[Link]]
        vim.keymap.set("n", "gf", function()
            if require("obsidian").util.cursor_on_markdown_link() then
                return "<cmd>ObsidianFollowLink<CR>"
            else
                return "gf"
            end
        end, { noremap = false, expr = true })
    end,
}
