-- 1. CLIPBOARD SETUP (WSL SPECIAL)
-- Set the clipboard to use the system clipboard (unnamedplus)
vim.opt.clipboard = "unnamedplus"

-- Define the clipboard provider specifically for WSL
if vim.fn.has("wsl") == 1 then
    vim.g.clipboard = {
        name = "win32yank-wsl",
        copy = {
            ["+"] = "win32yank.exe -i --crlf",
            ["*"] = "win32yank.exe -i --crlf",
        },
        paste = {
            ["+"] = "win32yank.exe -o --lf",
            ["*"] = "win32yank.exe -o --lf",
        },
        cache_enabled = 0,
    }
end

-- 2. THE "CLEAN CLIPBOARD" KEYMAPS
-- "Black Hole" Delete: d and dd will NEVER overwrite your copied code
vim.keymap.set({ "n", "v" }, "d", '"_d', { desc = "Delete to black hole (no copy)" })
vim.keymap.set("n", "dd", '"_dd', { desc = "Delete line to black hole (no copy)" })

-- "System Cut": Leader + x (and xx) will actually Cut to your Windows clipboard
vim.keymap.set({ "n", "v" }, "<leader>x", '"+d', { desc = "Cut to system clipboard" })
vim.keymap.set("n", "<leader>xx", '"+dd', { desc = "Cut line to system clipboard" })

-- "Black Hole" Change/Replace: c and C won't overwrite clipboard either
vim.keymap.set({ "n", "v" }, "c", '"_c', { desc = "Change to black hole" })
vim.keymap.set({ "n", "v" }, "C", '"_C', { desc = "Change line to black hole" })

-- "Greatest Paste": Paste over a selection without losing your original copy
-- Perfect for replacing "BS" code blocks over and over
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste and keep original clipboard" })

-- "Safe Character Delete": x won't steal your clipboard for a single letter
vim.keymap.set("n", "x", '"_x', { desc = "Delete char to black hole" })
