return {
    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {'nvim-treesitter/nvim-treesitter-textobjects'},
        build = ":TSUpdate",
        event = "VeryLazy",
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx',
                    'typescript', 'vim', 'graphql', 'markdown',
                    'markdown_inline'
                },
                auto_install = false,
                highlight = {enable = true},
                indent = {enable = true, disable = {'python'}},
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '<c-space>',
                        node_incremental = '<c-space>',
                        scope_incremental = '<c-s>',
                        node_decremental = '<M-space>'
                    }
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ['aa'] = '@parameter.outer',
                            ['ia'] = '@parameter.inner',
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = '@class.inner'
                        }
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            [']m'] = '@function.outer',
                            [']]'] = '@class.outer'
                        },
                        goto_next_end = {
                            [']M'] = '@function.outer',
                            [']['] = '@class.outer'
                        },
                        goto_previous_start = {
                            ['[m'] = '@function.outer',
                            ['[['] = '@class.outer'
                        },
                        goto_previous_end = {
                            ['[M'] = '@function.outer',
                            ['[]'] = '@class.outer'
                        }
                    },
                    swap = {
                        enable = true,
                        swap_next = {['<leader>sa'] = '@parameter.inner'},
                        swap_previous = {['<leader>sA'] = '@parameter.inner'}
                    }
                }
            })
        end
    }
}
