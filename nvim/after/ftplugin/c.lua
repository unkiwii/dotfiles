vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true

vim.keymap.set('n', '<leader>a', ':e %:p:s,.h$,.X123X,:s,.c$,.h,:s,.X123X$,.c,<cr>', { buffer = true })
