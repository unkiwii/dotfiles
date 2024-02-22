-- [[ To get my vim configuration in nvim just uncomment the next 3 lines ]]
-- vim.opt.rtp:prepend('~/.vim')
-- vim.opt.rtp:append('~/.vim/after')
-- vim.api.nvim_command('source ~/.vimrc')

local initrc = vim.fn.stdpath('config') .. '/init.lua'

vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- disable netrw (because of NvimTree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-------------------
-- [[ Options ]] --
-------------------

vim.o.autoindent = true
vim.o.autoread = true
vim.o.autowrite = true
vim.o.background = 'dark'
vim.o.backspace = 'indent,eol,start'
vim.o.backup = false
vim.o.clipboard = 'unnamedplus'
vim.o.completeopt = 'longest,menu'
vim.o.cursorline = true
vim.o.errorbells = false
vim.o.expandtab = true
vim.o.fillchars = 'fold:-,vert:│'
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.laststatus = 2
vim.o.list = true
vim.o.listchars = 'eol:¶,tab:| ,trail:·,nbsp:◊'
vim.o.modeline = true
vim.o.modelines = 5
vim.o.mouse = ''
vim.o.number = true
vim.o.path = '.,**'
vim.o.ruler = true
vim.o.rulerformat = '%30(%=%y %l,%c %P%)'
vim.o.shiftwidth = 2
vim.o.showcmd = true
vim.o.showmatch = true
vim.o.showmode = false
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.softtabstop = 2
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 2
vim.o.textwidth = 0
vim.o.timeoutlen = 300
vim.o.ttimeoutlen = 0
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.visualbell = false
vim.o.wildmenu = true
vim.o.wildmode = 'longest,full'
vim.o.wrap = false
vim.o.writebackup = false
vim.wo.signcolumn = 'yes'


-------------------
-- [[ Plugins ]] --
-------------------
require('lazy').setup({
    -- :Tabularize command
    'godlygeek/tabular',

    -- comment/uncomment with "gc"
    { 'numToStr/Comment.nvim', opts = {} },

    -- integration with tmux
    'preservim/vimux',
    'christoomey/vim-tmux-navigator',

    -- niceer start screen
    'mhinz/vim-startify',

    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',

    -- show color on 'css-like' colors like #ff0000 or #deadbeef
    'ap/vim-css-color',

    -- integration with git
    'tpope/vim-fugitive',

    -- NERDTree alternative
    'nvim-tree/nvim-tree.lua',

    {
        -- Go specifics
        'ray-x/go.nvim',
        dependencies = {
            'ray-x/guihua.lua',
            'mfussenegger/nvim-dap',
            'rcarriga/nvim-dap-ui',
            'theHamsta/nvim-dap-virtual-text',
        },
        event = { "CmdlineEnter" },
        ft = { "go", 'gomod' },
        build = ':lua require("go.install").update_all_sync()'
    },

    {
        -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '-' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
    },

    {
        -- Fuzzy Finder (files, lsp, etc)
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                -- NOTE: If you are having trouble with this installation,
                --       refer to the README for telescope-fzf-native for more instructions.
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
        },
    },

    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },

    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
        },
    },

    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
            'L3MON4D3/LuaSnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
        },
    },

    {
        -- Choose code actions to apply and preview them
        'aznhe21/actions-preview.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
        },
    },
}, {})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup({
    defaults = {
        mappings = {
            i = {
                ['<C-k>'] = require('telescope.actions').move_selection_previous,
                ['<C-j>'] = require('telescope.actions').move_selection_next,
                ['<esc>'] = require('telescope.actions').close,
            },
        },
    },
})

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Setup actions preview to view code actions and apply them
require("actions-preview").setup({
    telescope = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
            width = 0.8,
            height = 0.9,
            prompt_position = "top",
            preview_cutoff = 20,
            preview_height = function(_, _, max_lines)
                return max_lines - 15
            end,
        },
    },
})

-- Setup neovim lua configuration
require('neodev').setup({})

-- Go specific configuration
require('go').setup({
    gofmt = 'goimports', -- stricter form of gofmt
    icons = false,
    dap_debug = true,    -- debug using nvim-dap
    lsp_cfg = false,     -- true: use non-default gopls setup specified in go/lsp.lua
    -- false: do nothing
    -- if lsp_cfg is a table, merge table with with non-default gopls setup in go/lsp.lua, e.g.
    --   lsp_cfg = {settings={gopls={matcher='CaseInsensitive', ['local'] = 'your_local_module_path', gofumpt = true }}}
    lsp_gofumpt = true,  -- true: set default gofmt in gopls format to gofumpt
    lsp_keymaps = true,  -- set to false to disable gopls/lsp keymap
    lsp_codelens = true, -- set to false to disable codelens, true by default, you can use a function
    diagnostic = {       -- set diagnostic to false to disable vim.diagnostic setup
        hdlr = false,    -- hook lsp diag handler and send diag to quickfix
        underline = true,
        -- virtual text setup
        virtual_text = { spacing = 0, prefix = '█' },
        signs = true,
        update_in_insert = false,
    },
    lsp_document_formatting = true,
    lsp_inlay_hints = {
        enable = false,
    },
    textobjects = true, -- enable default text objects through treesittter-text-objects
    test_runner = 'go', -- one of {`go`, `richgo`, `dlv`, `ginkgo`, `gotestsum`}
})

-- Setup nvim tree
require('nvim-tree').setup({
    git = { enable = false },
})

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
    require('nvim-treesitter.configs').setup({
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = {
            'c', 'cpp',
            'go', 'rust',
            'lua', 'python',
            'tsx', 'javascript', 'typescript',
            'vimdoc', 'vim',
            'bash',
        },

        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = false,
        -- Install languages synchronously (only applied to `ensure_installed`)
        sync_install = true,
        -- List of parsers to ignore installing
        ignore_install = {},

        -- mandatory key that must always be there
        modules = {},

        -- do not use treesitter highlighter or indentation
        highlight = { enable = false },
        indent = { enable = false },

        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ['af'] = '@function.outer',
                    ['if'] = '@function.inner',
                },
            },
        },
    })
end, 0)

---------------------
-- [[ LSP setup ]] --
---------------------

-- lsp servers we want installed
local lsp_servers = {
    gopls = {},
    rust_analyzer = {},
    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = { disable = { 'missing-fields' } },
        },
    },
}

-- lsp_on_attach is called when an LSP connects to a particular buffer, this is
-- passed as the on_attach callback when configuring each server
local lsp_on_attach = function(client, bufnr)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
    vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, { buffer = bufnr })
    vim.keymap.set('n', '<c-]>', require('telescope.builtin').lsp_definitions, { buffer = bufnr })
    vim.keymap.set('n', '<c-y>', require('telescope.builtin').lsp_implementations, { buffer = bufnr })
    vim.keymap.set('n', '<leader>f', require('actions-preview').code_actions, { buffer = bufnr })

    -- Format file on save on supported clients
    if client.supports_method("textDocument/formatting") then
        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format()
                vim.lsp.buf.code_action({
                    context = { only = { "source.organizeImports" } },
                    apply = true
                })
            end,
        })
    end
end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup({
    ensure_installed = vim.tbl_keys(lsp_servers),
})
mason_lspconfig.setup_handlers({
    function(server_name)
        local config = {
            capabilities = capabilities,
            on_attach = lsp_on_attach,
            settings = lsp_servers[server_name],
            filetypes = (lsp_servers[server_name] or {}).filetypes,
        }
        if server_name == "lua_ls" then
            config.root_dir = function()
                return ""
            end
        end
        require('lspconfig')[server_name].setup(config)
    end
})

------------------------
-- [[ Autocomplete ]] --
------------------------
local cmp = require('cmp')
local luasnip = require('luasnip')
luasnip.config.setup({})

cmp.setup({
    enabled = false,
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    completion = {
        completeopt = 'menu,menuone,noinsert',
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
        ['<Tab>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'path' },
    },
})

-------------------------
-- [[ Autocommands ]] --
-------------------------

-- paint the status line red on insert mode
vim.api.nvim_create_augroup('status_line_colors', { clear = true })
vim.api.nvim_create_autocmd('InsertEnter', {
    group = 'status_line_colors',
    pattern = '',
    command = 'hi StatusLine ctermfg=15 ctermbg=88'
})
vim.api.nvim_create_autocmd('InsertLeave', {
    group = 'status_line_colors',
    pattern = '',
    command = 'hi StatusLine ctermfg=0 ctermbg=15'
})


-- [[ Show cursor line only on the focused window ]]
vim.api.nvim_create_augroup('auto_cursor_line', { clear = true })
vim.api.nvim_create_autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter' }, {
    group = 'auto_cursor_line',
    pattern = '',
    callback = function()
        vim.wo.cursorline = true
    end
})
vim.api.nvim_create_autocmd('WinLeave', {
    group = 'auto_cursor_line',
    pattern = '',
    callback = function()
        vim.wo.cursorline = false
    end
})

vim.api.nvim_create_augroup('json_format', { clear = true })
vim.api.nvim_create_autocmd({ 'FileType' }, {
    group = 'json_format',
    pattern = 'json',
    callback = function(opts)
        vim.keymap.set('n', '<leader>f', ':%!jq<cr>', { buffer = opts.buf })
    end
})


--------------------
-- [[ Mappings ]] --
--------------------

vim.keymap.set('n', '<leader>v', ':tabedit ' .. initrc .. '<cr>', { silent = true })

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
vim.keymap.set('c', 'w!!', 'w !sudo tee % >/dev/null')

-- move selected text easily
vim.keymap.set('v', '<', '<gv', { silent = true })
vim.keymap.set('v', '>', '>gv', { silent = true })

-- maintain search result in the middle of the screen
for _, key in ipairs({ 'n', 'N', '*', '#', 'g*', 'g#', '%' }) do
    vim.keymap.set({ 'n', 'v' }, key, key .. 'zz', { silent = true })
end

-- map arrow keys to nothing
for _, key in ipairs({ '<up>', '<down>', '<left>', '<right>' }) do
    vim.keymap.set({ 'n', 'v', 'i' }, key, '<nop>', { silent = true })
end

-- remove highlight manually
vim.keymap.set('n', ';', ':nohlsearch<cr>', { silent = true })

-- <shift-s>: split, the inverse of <shift-j>
vim.keymap.set('n', '<s-s>', 'a<cr><esc>', { silent = true })

-- move lines up and down
vim.keymap.set('n', '<a-k>', ':m .-2<cr>==', { silent = true })
vim.keymap.set('n', '<a-j>', ':m .+1<cr>==', { silent = true })
vim.keymap.set('i', '<a-k>', '<esc>:m .-2<cr>==gi', { silent = true })
vim.keymap.set('i', '<a-j>', '<esc>:m .+1<cr>==gi', { silent = true })
vim.keymap.set('v', '<a-k>', ":m '<-2<cr>gv=gv", { silent = true })
vim.keymap.set('v', '<a-j>', ":m '>+1<cr>gv=gv", { silent = true })

-- make Y to yank to the end of line (like D, C, etc)
vim.keymap.set('n', 'Y', 'y$', { silent = true })

vim.keymap.set('n', '<leader>vl', ':VimuxRunLastCommand<cr>', { silent = true })
vim.keymap.set('n', '<leader>vp', ':VimuxPromptCommand<cr>', { silent = true })

vim.keymap.set('n', '<c-p>', require('telescope.builtin').find_files)
vim.keymap.set('n', '<leader>ag', require('telescope.builtin').grep_string)
vim.keymap.set('n', '<leader>lg', require('telescope.builtin').live_grep)

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<cr>')
vim.keymap.set('n', '<leader>g', ':NvimTreeFindFile<cr>')

local function printHighlightInfo()
    local line = vim.fn.line(".") or 0
    local col = vim.fn.col(".") or 0
    if line == 0 or col == 0 then
        -- do nothing if can't get line and column of cursor
        return
    end
    local nameOf = function(id)
        return vim.fn.synIDattr(id, "name")
    end
    local hiID = vim.fn.synID(line, col, 1)
    local loID = vim.fn.synID(line, col, 0)
    local transID = vim.fn.synIDtrans(vim.fn.synID(line, col, 1))
    print(string.format("line:%d col:%d hiID:%s transID:%s loID:%s hi:%s trans:%s lo:%s", line, col, hiID, transID, loID,
        nameOf(hiID), nameOf(transID), nameOf(loID)))
end
vim.keymap.set('n', '<leader>h', printHighlightInfo)

------------------------------
-- [[ Misc configuration ]] --
------------------------------

-- hightlight problematic characters
vim.cmd([[
    highlight Invisible ctermbg=red
    highlight ColorColumn ctermbg=233
    syntax match Invisible /ㅤ/
]])

-- set custom colorscheme
vim.cmd('colorscheme mlessnau')

-- vim: ts=4 sts=4 sw=4 et
