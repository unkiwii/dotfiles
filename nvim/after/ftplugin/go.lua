vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = false

vim.keymap.set('n', '<leader>a', ':GoAlt<cr>', { buffer = true })
vim.keymap.set('n', '<leader>r', ':GoRun<cr>', { buffer = true })
vim.keymap.set('n', '<leader>gt', ':GoTest<cr>', { buffer = true })
vim.keymap.set('n', '<leader>gf', ':GoTestFunc<cr>', { buffer = true })
vim.keymap.set('n', '<leader>bt', ':GoBreakToggle<cr>', { buffer = true })
vim.keymap.set('n', '<leader>db', ':GoDebug<cr>', { buffer = true })
vim.keymap.set('n', '<leader>k', ':GoDbgKeys<cr>', { buffer = true })
vim.keymap.set('n', 'gct', ':GoCoverage<cr>', { buffer = true })
