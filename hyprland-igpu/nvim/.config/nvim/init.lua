require("srindot")
-- Copy selected text to system clipboard using wl-copy
vim.keymap.set("v", "<leader>y", ":w !wl-copy<CR><CR>", { silent = true })

-- Copy entire file to clipboard
vim.keymap.set("n", "<leader>Y", ":%w !wl-copy<CR><CR>", { silent = true })

-- Paste from clipboard into insert mode
vim.keymap.set("n", "<leader>p", ":r !wl-paste<CR>", { silent = true })

