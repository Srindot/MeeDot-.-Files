-- Set the clipboard to use the system clipboard (unnamedplus)
vim.opt.clipboard = "unnamedplus"

-- Clipboard provider for Arch Linux (Wayland)
-- This uses wl-copy/wl-paste and integrates with cliphist
if vim.fn.has("wsl") == 0 and vim.fn.executable("wl-copy") == 1 then
    vim.g.clipboard = {
        name = "wl-clipboard",
        copy = {
            ["+"] = "wl-copy",
            ["*"] = "wl-copy",
        },
        paste = {
            ["+"] = "wl-paste --no-newline",
            ["*"] = "wl-paste --no-newline",
        },
        cache_enabled = 0,
    }
end
