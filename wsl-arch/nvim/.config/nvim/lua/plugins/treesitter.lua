-- Treesitter | Plugin for syntax highlighter
return {
    "nvim-treesitter/nvim-treesitter",
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python" },
    build = ":TSUpdate",
}
