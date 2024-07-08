-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {

  -- Integration with tmux
  {
    'preservim/vimux',
    dependencies = {
      'christoomey/vim-tmux-navigator',
    },
    config = function()
      vim.keymap.set('n', '<leader>vl', ':VimuxRunLastCommand<cr>', { silent = true })
      vim.keymap.set('n', '<leader>vp', ':VimuxPromptCommand<cr>', { silent = true })
    end,
  },
}
