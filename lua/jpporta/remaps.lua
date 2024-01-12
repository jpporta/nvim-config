vim.keymap.set({'n', 'v'}, '<Space>', '<Nop>', {silent = true})
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'",
               {expr = true, silent = true})
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'",
               {expr = true, silent = true})
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,
               {desc = "Go to previous diagnostic message"})
vim.keymap.set('n', ']d', vim.diagnostic.goto_next,
               {desc = "Go to next diagnostic message"})
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float,
               {desc = "Open floating diagnostic message"})
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist,
               {desc = "Open diagnostics list"})

vim.keymap.set('n', '<leader>l', function()
    local wins = vim.fn.getwininfo()
    for _, win in pairs(wins) do
        if win["quickfix"] == 1 then
            vim.cmd.cclose()
            return
        end
    end
    vim.cmd.copen()
end, {desc = "Toggle quickfix list"})

