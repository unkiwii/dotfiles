-- Set the leader key
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Use gui colors
vim.opt.termguicolors = true

-- Use C syntax for .h files instead of CPP
-- TODO: maybe move this to a c or cpp after script?
vim.g.c_syntax_for_h = 1

-------------------
-- [[ OPTIONS ]] --
-------------------

-- Disable the mouse
vim.opt.mouse = ''

-- Show line numbers
vim.opt.number = true

-- Show the mode in the statusline
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
-- See `:help 'clipboard'`
vim.opt.clipboard = 'unnamed,unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Do not create swap or backup files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Default tabs configuration
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- Read and write files automatically when they are changed outside of vim
vim.opt.autowrite = true
vim.opt.autoread = true

-- Highlight search and do it incrementally
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Set background to change between light and dark themes
vim.opt.background = 'dark'

-- Do not wrap lines
vim.opt.wrap = false

-- Case-sensitive searching
vim.opt.ignorecase = false
vim.opt.smartcase = false

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Set how the complete menu works
vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }

-- Make windows border rounded
vim.opt.winborder = 'rounded'

-------------------
-- [[ PLUGINS ]] --
-------------------

vim.pack.add({
  -- gruvbox colorscheme
  { src = 'https://github.com/ellisonleao/gruvbox.nvim' },

  -- autoformat on save
  { src = 'https://github.com/stevearc/conform.nvim' },

  -- nice notifications (for LSP mainly)
  { src = 'https://github.com/j-hui/fidget.nvim' },

  -- collection of several tools (used mostly for mini.files)
  { src = 'https://github.com/nvim-mini/mini.nvim' },

  -- navitage between tmux and vim panes
  { src = 'https://github.com/christoomey/vim-tmux-navigator' },

  -- run commands in a tmux pane
  { src = 'https://github.com/preservim/vimux' },

  -- fuzzy finder over lists
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
})

-- nicer notifications
require('fidget').setup()
vim.notify = require('fidget.notification').notify

-- gruvbox colorscheme
require('gruvbox').setup({
  contrast = 'hard',
  transparent_mode = true,
  italic = {
    strings = false,
    comments = false,
  },
})

-- autoformat on save
require('conform').setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    go = { 'goimports', 'gofumpt' },
  },
  format_on_save = {
    lsp_format = 'fallback',
    timeout_ms = 500,
  },
})

-- file manager setup and config
require('mini.files').setup({
  mappings = {
    go_in_plus = '<CR>',
  },
  windows = {
    preview = true,
    width_preview = 120,
  },
})

-- status line setup and config
local empty_section = function()
  return ''
end
local statusline = require('mini.statusline')
statusline.setup({ use_icons = true })
statusline.section_location = function()
  return '%2l:%-2v'
end
statusline.section_lsp = empty_section
statusline.section_diff = empty_section
statusline.section_git = empty_section

-- fuzzy finder over lists
require('telescope').setup({
  defaults = {
    file_ignore_patterns = {
      '^node_modules/',
      '^dist/',
    },
  },
})

-------------------
-- [[ KEYMAPS ]] --
-------------------

-- Set highlight on search, but clear on pressing ; in normal mode
vim.keymap.set('n', ';', '<cmd>nohlsearch<CR>')

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<nop>')
vim.keymap.set('n', '<right>', '<nop>')
vim.keymap.set('n', '<up>', '<nop>')
vim.keymap.set('n', '<down>', '<nop>')

-- SORT as a verb
vim.keymap.set('n', 'sip', 'vip:sort<cr>', { desc = 'Sort inner paragraph' })

-- Format JSON as a verb
vim.keymap.set('n', '<leader>fj', 'V:!jq<cr>', { desc = 'Format line with [j]q' })

-- Format SQL as a verb
vim.keymap.set('n', '<leader>fs', 'V:!sqlformat - -r<cr>', { desc = 'Format line with [s]qlformat' })

-- Edit/reload init.lua
local initrc = vim.fn.stdpath('config') .. '/init.lua'
vim.keymap.set('n', '<leader>v', ':tabedit ' .. initrc .. '<cr>', { silent = true, desc = 'Edit [v]imrc (init.lua)' })
vim.keymap.set('n', '<leader>rv', ':source ' .. initrc .. '<cr>', { silent = true, desc = '[R]eload [v]imrc (init.lua)' })

-- select tabs with Alt-L and Alt-H
vim.keymap.set('n', '<a-l>', ':tabnext<cr>', { silent = true })
vim.keymap.set('n', '<a-h>', ':tabprev<cr>', { silent = true })

-- move visually
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- go to file nicely: read line (:nn) and center after the fact
vim.keymap.set('n', 'gf', 'gFzz', { silent = true })

-- remove Ex mode map
vim.keymap.set('n', 'Q', '<nop>', { silent = true })

-- write. always.
vim.keymap.set('c', 'w!!', 'w !SUDO_ASKPASS=/usr/bin/ssh-askpass sudo -A tee % >/dev/null')

-- move selected text easily
vim.keymap.set('v', '<', '<gv', { silent = true })
vim.keymap.set('v', '>', '>gv', { silent = true })

-- maintain search result in the middle of the screen
for _, key in ipairs({ 'n', 'N', '*', '#', 'g*', 'g#', '%' }) do
  vim.keymap.set({ 'n', 'v' }, key, key .. 'zz', { silent = true })
end

-- <shift-s>: split, the inverse of <shift-j>
vim.keymap.set('n', '<s-s>', 'a<cr><esc>', { silent = true })

-- make Y to yank to the end of line (like D, C, etc)
vim.keymap.set('n', 'Y', 'y$', { silent = true })

-- Open mini.files with \ (it breaks if mini.files is not installed)
vim.keymap.set('n', '\\', function()
  require('mini.files').open(vim.fn.expand('%:p:h'))
end, { noremap = true, silent = true })

-- Run commands with vimux (it breaks if vimux is not installed)
vim.keymap.set('n', '<leader>vl', ':VimuxRunLastCommand<cr>', { silent = true })
vim.keymap.set('n', '<leader>vp', ':VimuxPromptCommand<cr>', { silent = true })

-- Telescope keymaps
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })

--------------------
-- [[ AUTOCMDS ]] --
--------------------

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Setup completion for LSPs',
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
      vim.keymap.set('i', '<C-Space>', function()
        vim.lsp.completion.get()
      end)
    end

    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {
      buffer = event.buf,
      desc = 'LSP: [C]ode [A]ction',
    })
  end,
})

vim.api.nvim_create_autocmd('LspProgress', {
  desc = 'Show messages received from LSP servers',
  callback = function()
    vim.notify(vim.lsp.status())
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Open :help on a vertical split to the right',
  group = vim.api.nvim_create_augroup('vertical-help', { clear = true }),
  pattern = '*.txt',
  callback = function()
    if vim.bo.buftype == 'help' then
      vim.cmd('wincmd L')
    end
  end,
})

local float_diagnostics_group = vim.api.nvim_create_augroup('float_diagnostics_group', {})
vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave' }, {
  desc = 'Open diganostics as a floating window',
  group = float_diagnostics_group,
  callback = function()
    local opts = {
      focusable = false,
      scope = 'cursor',
      close_events = { 'BufLeave', 'InsertEnter', 'CursorMoved' },
    }
    vim.diagnostic.open_float(nil, opts)
  end,
})
vim.api.nvim_create_autocmd('InsertEnter', {
  desc = 'Disable diagnostics on Insert Mode',
  group = float_diagnostics_group,
  callback = function()
    vim.diagnostic.enable(false)
  end,
})
vim.api.nvim_create_autocmd('InsertLeave', {
  desc = 'Enable diagnostics when not in Insert Mode',
  group = float_diagnostics_group,
  callback = function()
    vim.diagnostic.enable(true)
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.dot',
  desc = 'Write dot file',
  group = float_diagnostics_group,
  callback = function()
    local fullpath = vim.fn.expand('%:p')
    local filename = vim.fn.expand('%:r')
    local command = 'dot -Tpng -o ' .. filename .. '.png ' .. fullpath
    pcall(vim.fn.system, command)
  end,
})

---------------
-- [[ LSP ]] --
---------------

-- NOTE: Install lsp servers/clients by hand

-- Each call to vim.lsp.enable(name) reads a file in lsp/name.lua
vim.lsp.enable('lua_ls') -- requires lua-language-server installed
vim.lsp.enable('gopls') -- requires gopls installed

-- Show errors as virtual line only when inisde the problematic line
vim.diagnostic.config({
  virtual_lines = false,
  float = true,
})

-----------------------
-- [[ COLORSCHEME ]] --
-----------------------
vim.cmd.colorscheme('gruvbox')

-- vim: ts=2 sts=2 sw=2 et
