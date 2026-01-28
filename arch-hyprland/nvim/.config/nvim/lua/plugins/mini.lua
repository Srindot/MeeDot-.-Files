-- Mini.nvim | A plugin for autocompleting character " {} " | <gcc> = Toggles current line to comment | gc + motion: Comments a specific area | gc: Highlight text with v, then press gc to comment that chunk | Surround (s)
-- -- 1. Pairs (Automatic)
-- Keybinding: None.
--
-- How to use: Just type ( or { or " in Insert Mode. It works automatically.
--
-- 2. Comments (The gc standard)
-- gcc: Toggles comment on the current line. (Memorize this one!)
--
-- gc + motion: Comments a specific area.
--
-- Example: gc2j (Comment current line + 2 lines down).
--
-- Visual Mode gc: Highlight text with v, then press gc to comment that chunk.
--
-- 3. Surround (The s family)
-- This is the most powerful tool, but it has a learning curve. The keys follow a pattern: Surround Action.
--
-- Add Surround (sa): Adds quotes/brackets around text.
--
-- Command: sa + iw (inner word) + "
--
-- Result: Changes hello to "hello"
--
-- Mnemonic: Surround Add Inner Word
--
-- Delete Surround (sd): Removes quotes/brackets.
--
-- Command: sd + "
--
-- Result: Changes "hello" to hello
--
-- Mnemonic: Surround Delete
--
-- Replace Surround (sr): Changes the type of bracket/quote.
--
-- Command: sr + " + )
--
-- Result: Changes "hello" to (hello)
--
--
-- Mnemonic: Surround Replace
return {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
        -- 1. Auto-Pairs: Typo '(' and it gives you '()'
        require("mini.pairs").setup()

        -- 2. Comments: Press 'gcc' to comment a line
        require("mini.comment").setup()

        -- 3. Surround: Press 'saIw"' to wrap a word in quotes
        require("mini.surround").setup()
    end,
}
