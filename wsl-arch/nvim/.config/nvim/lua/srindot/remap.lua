-- =============================================================================
--  KEYBINDING CHEATSHEET
-- =============================================================================
--  LEADER KEY: Space Bar
--
--  [NAVIGATION]
--  <Space>pv   : Open File Explorer (Netrw)
--  Ctrl + u    : Scroll Up (Centered)
--  Ctrl + d    : Scroll Down (Centered)
--  n / N       : Next/Prev Search Result (Centered)
--
--  [EDITING]
--  J / K       : Move selected lines Up/Down (Visual Mode)
--  J           : Join line below to current line (keeps cursor stable)
--  <Space>s    : Search & Replace the word under cursor
--  Esc         : Clear search highlights (turn off the yellow markers)
--
--  [CLIPBOARD]
--  <Space>y    : Copy to System Clipboard (works for lines or blocks)
--  <Space>p    : Paste over selected text WITHOUT losing the copied text
--  <Space>d    : Delete to void (doesn't overwrite your clipboard)
--
--  [PLUGINS]
--  <Space>sf   : Search Files (Telescope)
--  <Space>sg   : Search Text/Grep (Telescope)
--  <Space>mp   : Make Pretty (Format Code)
--  <Space>gs   : Git Status (Fugitive)
-- =============================================================================

vim.g.mapleader = " "

-- 1. FILE NAVIGATION
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) -- Open file explorer

-- 2. BETTER SCROLLING (Keeps cursor in the middle)
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- 3. MOVING LINES (The "Primeagen" Move)
-- Highlight text and press J or K to move the whole block
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- 4. BETTER JOINING
-- Joins the line below but keeps your cursor where it is
vim.keymap.set("n", "J", "mzJ`z")

-- 5. CLIPBOARD MAGIC
-- <leader>p: Paste over text without copying the deleted text
vim.keymap.set("x", "<leader>p", [["_dP]])

-- <leader>y: Copy to system clipboard (so you can paste in browser)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- <leader>d: Delete to void register (doesn't mess up your clipboard)
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- 6. UTILITIES
-- Quick Save (Optional, but handy)
-- vim.keymap.set("n", "<C-s>", ":w<CR>")

-- Clear search highlights when pressing Esc
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Search and Replace the word under cursor (Refactoring Tool)
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make file executable (Useful for scripts)
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Source the current file (Reload config)
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

-- 7. PLUGINS
-- TELESCOPE (Search)
vim.keymap.set('n', '<leader>sf', function() require('telescope.builtin').find_files() end, { desc = "Search Files" })
vim.keymap.set('n', '<leader>sg', function() require('telescope.builtin').live_grep() end, { desc = "Search Grep" })
vim.keymap.set('n', '<leader>sb', function() require('telescope.builtin').buffers() end, { desc = "Search Buffers" })

-- CONFORM (Formatting)
vim.keymap.set("n", "<leader>mp", function()
    require("conform").format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
    })
end)

-- FUGITIVE (Git)
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

-- For fun
-- Make It Rain (The Fun Key)
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")
