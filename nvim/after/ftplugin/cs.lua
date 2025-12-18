vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true

vim.cmd('compiler dotnet')

vim.keymap.set('n', '<leader>b', ':w<cr>:silent make | cwindow<cr>', { buffer = true })
