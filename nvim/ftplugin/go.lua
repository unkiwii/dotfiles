vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = false

vim.keymap.set('n', '<leader>a', ':GoAlt<cr>', { buffer = true })
vim.keymap.set('n', '<leader>gt', ':GoTest<cr>', { buffer = true })
vim.keymap.set('n', '<leader>gf', ':GoTestFunc<cr>', { buffer = true })
vim.keymap.set('n', '<leader>k', ':GoDbgKeys<cr>', { buffer = true })
vim.keymap.set('n', 'gct', ':GoCoverage<cr>', { buffer = true })
