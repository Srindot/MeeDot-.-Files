-- Telescope to Find files and switch Instantly
--
-- <Space>sf: Searches for file names (e.g., finding main.cpp or sensor.h).
--
-- <Space>sg: Searches for words inside files (e.g., finding where you wrote void update_pid()).
--
-- <Space>sb: Searches your open tabs (switches between files you are already editing).
--
return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- We don't need a specific config function anymore
    -- unless you want to change the look/theme later.
    config = function()
        require('telescope').setup({})
    end
}
