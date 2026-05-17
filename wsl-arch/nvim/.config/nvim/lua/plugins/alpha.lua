return {
    'goolord/alpha-nvim',
    lazy = false,
    -- We removed priority=1000 so it doesn't break directory opening
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- 1. FLAMING SKULL HEADER
        dashboard.section.header.val = {
            [[                                                                        ]],
            [[                  _________-----_____                                   ]],
            [[       _____------           __      ----_                              ]],
            [[___----             ___------              \                            ]],
            [[   ----________        ----                 \                           ]],
            [[               -----__    |             _____)                          ]],
            [[                    __-                /     \                          ]],
            [[        _______-----    ___--          \    /)\                         ]],
            [[  ------_______      ---____            \__/  /                         ]],
            [[               -----__    \ --    _          /\                         ]],
            [[                      --__--__     \_____/   \_/\                       ]],
            [[                              ----|   /          |                      ]],
            [[                                  |  |___________|                      ]],
            [[                                  |  | ((_(_)| )_)                      ]],
            [[                                  |  \_((_(_)|/(_)                      ]],
            [[                                  \             (                       ]],
            [[                                   \_____________)                      ]],
            [[                                                                        ]],
            [[                   [ SYSTEM STATUS: ONLINE ]                            ]],
        }

        -- 2. THE BUTTONS
        dashboard.section.buttons.val = {
            dashboard.button("f", "  Find File", ":Telescope find_files <CR>"),
            dashboard.button("r", "  Recent", ":Telescope oldfiles <CR>"),
            dashboard.button("e", "  New File", ":ene <BAR> startinsert <CR>"),
            dashboard.button("s", "  Settings", ":e $MYVIMRC <CR>"),
            dashboard.button("q", "󰅚  Quit", ":qa <CR>"),
        }

        -- 3. MINIMAL FOOTER
        dashboard.section.footer.val = "v3.10.20 | Arch Linux"

        alpha.setup(dashboard.opts)

        -- FIX 3: ONLY show the dashboard if there are zero arguments
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                if vim.fn.argc() == 0 then
                    vim.cmd("NvimTreeClose")
                end
            end
        })

        -- Clean up UI on start screen
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "alpha",
            callback = function()
                vim.opt_local.number = false
                vim.opt_local.relativenumber = false
                vim.opt_local.laststatus = 0
                vim.opt_local.cursorline = false
            end,
        })
    end
}
