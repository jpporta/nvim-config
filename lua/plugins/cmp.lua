return {
    'hrsh7th/nvim-cmp',
    event = {"InsertEnter", "CmdlineEnter"},
    dependencies = {
        'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip',
        'rafamadriz/friendly-snippets',
        "roobert/tailwindcss-colorizer-cmp.nvim", 'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path', 'roobert/tailwindcss-colorizer-cmp.nvim'
    },

    config = function()
        local cmp_status_ok, cmp = pcall(require, "cmp")
        if not cmp_status_ok then return end

        local snip_status_ok, luasnip = pcall(require, "luasnip")
        if not snip_status_ok then return end

        local has_words_before = function()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and
                       vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(
                           col, col):match("%s") == nil
        end
        require("luasnip/loaders/from_vscode").lazy_load()

        local icons = require("jpporta.icons")

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },

            mapping = cmp.mapping.preset.insert({
                ["<M-J>"] = cmp.mapping.select_next_item(),
                ["<M-K>"] = cmp.mapping.select_prev_item(),
                ['<C-B>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), {'i', 'c'}),
                ['<C-F>'] = cmp.mapping(cmp.mapping.scroll_docs(1), {'i', 'c'}),
                ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
                ["<C-Y>"] = cmp.config.disable,
                ['<C-Q>'] = cmp.mapping({
                    i = cmp.mapping.abort(),
                    c = cmp.mapping.close()
                }),

                ["<CR>"] = cmp.mapping.confirm({select = true}),

                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
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

            }),
            formatting = {
                fields = {"kind", "abbr", "menu"},
                expandable_indicator = true,
                format = function(entry, vim_item)
                    if entry.source.name == 'tailwindcss-colorizer-cmp' then
                        return require('tailwindcss-colorizer-cmp').formatter(
                                   entry, vim_item)
                    end

                    vim_item.kind = string.format("%s",
                                                  icons.kind[vim_item.kind])
                    vim_item.menu = ({
                        luasnip = "[Snippet]",
                        buffer = "[Buffer]",
                        path = "[Path]"
                    })[entry.source.name]
                    return vim_item
                end
            },
            sources = cmp.config.sources({
                {name = 'nvim_lsp'}, {name = 'luasnip'}, {name = 'buffer'},
                {name = "path"}
            }),
            confirm_opts = {
                behavior = cmp.ConfirmBehavior.Replace,
                select = false
            },
            view = {entries = "custom"},
            window = {documentation = cmp.config.window.bordered()}

        })
    end
}
