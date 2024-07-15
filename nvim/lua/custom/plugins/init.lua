-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {

  { -- Integration with tmux
    'preservim/vimux',
    dependencies = {
      'christoomey/vim-tmux-navigator',
    },
    config = function()
      vim.keymap.set('n', '<leader>vl', ':VimuxRunLastCommand<cr>', { silent = true })
      vim.keymap.set('n', '<leader>vp', ':VimuxPromptCommand<cr>', { silent = true })
    end,
  },

  { -- HTTP REST-Client Interface
    'mistweaverco/kulala.nvim',
    config = function()
      local kulala = require 'kulala'
      kulala.setup {
        -- default_view, body or headers
        default_view = 'body',
        -- dev, test, prod, can be anything
        -- see: https://learn.microsoft.com/en-us/aspnet/core/test/http-files?view=aspnetcore-8.0#environment-files
        default_env = 'dev',
        -- enable/disable debug mode
        debug = false,
        -- default formatters for different content types
        formatters = {
          json = { 'jq', '.' },
          xml = { 'xmllint', '--format', '-' },
          html = { 'xmllint', '--format', '--html', '-' },
        },
        -- additional cURL options
        -- e.g. { "--insecure", "-A", "Mozilla/5.0" }
        additional_curl_options = {},
      }
      vim.keymap.set('n', '<leader>rr', kulala.run, { desc = '[R]un HTTP [R]equest with Kulala' })
    end,
  },
}
