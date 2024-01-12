return {
    'hrsh7th/nvim-cmp',
    event = "VeryLazy",
    dependencies = {
        'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip',
        "rafamadriz/friendly-snippets",
        "roobert/tailwindcss-colorizer-cmp.nvim", 'hrsh7th/cmp-emoji',
        'hrsh7th/cmp-buffer'
    },
    config = function()

        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        local tw = require 'tailwindcss-colorizer-cmp'

        luasnip.config.setup {}
        tw.setup {color_square_width = 2}

        vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg = "#6CC644"})
        vim.api.nvim_set_hl(0, "CmpItemKindCrate", {fg = "#F64D00"})
        vim.api.nvim_set_hl(0, "CmpItemKindEmoji", {fg = "#FDE030"})

        require("luasnip/loaders/from_vscode").lazy_load()
        require("luasnip").filetype_extend("typescriptreact", {"html"})

        local icons = require "jpporta.icons"

        cmp.setup {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },
            mapping = cmp.mapping.preset.insert {
                ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(),
                                        {"i", "c"}),
                ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(),
                                        {"i", "c"}),
                ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(),
                                         {"i", "c"}),
                ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(),
                                       {"i", "c"}),
                ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), {"i", "c"}),
                ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), {"i", "c"}),
                ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), {"i", "c"}),

                ["<CR>"] = cmp.mapping.confirm {select = true},

                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, {"i", "s"}),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, {"i", "s"})
            },
            formatting = {
                expandable_indicator = true,
                fields = {"kind", "abbr", "menu"},
                format = function(entry, vim_item)
                    vim_item.kind = icons.kind[vim_item.kind]
                    vim_item.menu = ({
                        nvim_lsp = "",
                        nvim_lua = "",
                        luasnip = "",
                        buffer = "",
                        path = "",
                        emoji = ""
                    })[entry.source.name]

                    if vim.tbl_contains({"nvim_lsp"}, entry.source.name) then
                        local duplicates = {
                            buffer = 1,
                            path = 1,
                            nvim_lsp = 0,
                            luasnip = 1
                        }

                        local duplicates_default = 0

                        vim_item.dup = duplicates[entry.source.name] or
                                           duplicates_default
                    end

                    if vim.tbl_contains({"nvim_lsp"}, entry.source.name) then
                        local words = {}
                        for word in string.gmatch(vim_item.word, "[^-]+") do
                            table.insert(words, word)
                        end

                        local color_name, color_number
                        if words[2] == "x" or words[2] == "y" or words[2] == "t" or
                            words[2] == "b" or words[2] == "l" or words[2] ==
                            "r" then
                            color_name = words[3]
                            color_number = words[4]
                        else
                            color_name = words[2]
                            color_number = words[3]
                        end

                        if color_name == "white" or color_name == "black" then
                            local color
                            if color_name == "white" then
                                color = "ffffff"
                            else
                                color = "000000"
                            end

                            local hl_group = "lsp_documentColor_mf_" .. color
                            -- vim.api.nvim_set_hl(0, hl_group, { fg = "#" .. color, bg = "#" .. color })
                            vim.api.nvim_set_hl(0, hl_group, {
                                fg = "#" .. color,
                                bg = "NONE"
                            })
                            vim_item.kind_hl_group = hl_group

                            -- make the color square 2 chars wide
                            vim_item.kind = string.rep("▣", 1)

                            return vim_item
                        elseif #words < 3 or #words > 4 then
                            -- doesn't look like this is a tailwind css color
                            return vim_item
                        end

                        if not color_name or not color_number then
                            return vim_item
                        end

                        local color_index = tonumber(color_number)
                        local tailwindcss_colors = require(
                                                       "tailwindcss-colorizer-cmp.colors").TailwindcssColors

                        if not tailwindcss_colors[color_name] then
                            return vim_item
                        end

                        if not tailwindcss_colors[color_name][color_index] then
                            return vim_item
                        end

                        local color =
                            tailwindcss_colors[color_name][color_index]

                        local hl_group = "lsp_documentColor_mf_" .. color
                        -- vim.api.nvim_set_hl(0, hl_group, { fg = "#" .. color, bg = "#" .. color })
                        vim.api.nvim_set_hl(0, hl_group,
                                            {fg = "#" .. color, bg = "NONE"})

                        vim_item.kind_hl_group = hl_group

                        -- make the color square 2 chars wide
                        vim_item.kind = string.rep("▣", 1)

                        -- return vim_item
                    end

                    if entry.source.name == "copilot" then
                        vim_item.kind = icons.git.Octoface
                        vim_item.kind_hl_group = "CmpItemKindCopilot"
                    end

                    if entry.source.name == "crates" then
                        vim_item.kind = icons.misc.Package
                        vim_item.kind_hl_group = "CmpItemKindCrate"
                    end

                    if entry.source.name == "lab.quick_data" then
                        vim_item.kind = icons.misc.CircuitBoard
                        vim_item.kind_hl_group = "CmpItemKindConstant"
                    end

                    if entry.source.name == "emoji" then
                        vim_item.kind = icons.misc.Smiley
                        vim_item.kind_hl_group = "CmpItemKindEmoji"
                    end

                    return vim_item
                end
            },
            sources = {
                {name = "copilot"}, {name = 'nvim_lsp'}, {name = 'luasnip'},
                {name = "treesitter"}, {name = 'buffer'}
            },
            window = {
                completion = {
                    border = "rounded",
                    winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,FloatBorder:FloatBorder,Search:None",
                    col_offset = -3,
                    side_padding = 1,
                    scrollbar = false,
                    scrolloff = 8
                },
                documentation = {
                    scrollbar = false,
                    border = "rounded",
                    winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,Search:None"
                }
            },
            experimental = {ghost_text = false}
        }

    end
}
