" vim:foldmethod=marker:expandtab:

let loaded_netrwPlugin = 1  " disable netrwPlugin

let mapleader=","

try
  source ~/.vimrc.bundles
catch
  echom "no .vimrc.bundles file, no plugins to load"
endtry

syntax on
filetype plugin indent on

if has('mouse')
  set mouse=a
endif

set nocompatible

set autowrite
set autoread

set clipboard=unnamed

set modeline
set modelines=5

set nowritebackup
set nobackup
set noswapfile

set hlsearch
set incsearch

set backspace=indent,eol,start

set autoindent
set smartindent

set noerrorbells
set visualbell
set t_vb=

set showcmd
set showmatch
set showmode

set list
set listchars=eol:¶,tab:\|\ ,trail:·

set wildmenu
set wildmode=full

" faster drawing
set ttyfast

set nowrap
set textwidth=0

set cursorline
set guioptions=ai
set number
set path=.,**

set laststatus=2 "show status bar always
set ruler
set rulerformat=%=%y\ %l,%c\ %P

set ts=2 sts=2 sw=2 expandtab smarttab

" tell vim that the terminal supports 256 colors
set encoding=utf8
set t_Co=256
set background=dark
colorscheme mlessnau

if has('autocmd') && !exists('autocommands_loaded')
  let autocommands_loaded = 1
  autocmd FileType javascript   setlocal ts=4 sts=4 sw=4    expandtab     smarttab
  autocmd FileType go           setlocal ts=4 sts=4 sw=4  noexpandtab   nosmarttab
  autocmd FileType c            setlocal ts=2 sts=2 sw=2    expandtab     smarttab
  autocmd FileType python       setlocal ts=4 sts=4 sw=4    expandtab   nosmarttab

  autocmd InsertEnter * hi StatusLine ctermfg=15 ctermbg=88
  autocmd InsertLeave * hi StatusLine ctermfg=0 ctermbg=15
endif

" ========================================
" => Mappings
" ========================================

" set the leader key
nnoremap <leader>v :tabedit $MYVIMRC<cr>
nnoremap <leader>b :tabedit $MYVIMRC.bundles<cr>

" copy and paste multiple lines
vnoremap <silent> y y']
vnoremap <silent> p p']
nnoremap <silent> p p']

" move visually
nnoremap j gj
nnoremap k gk
nnoremap ^ g^
nnoremap $ g$

" remove Ex mode map
nnoremap Q <nop>

" write. always.
cmap w!! w !sudo tee % >/dev/null

" move lines up or down
vnoremap <silent> <c-j> :m '>+1<cr>gv=gv
vnoremap <silent> <c-k> :m '<-2<cr>gv=gv
nnoremap <silent> <c-j> :m .+1<cr>==
nnoremap <silent> <c-k> :m .-2<cr>==
inoremap <silent> <c-j> <esc>:m .+1<cr>==gi
inoremap <silent> <c-k> <esc>:m .-2<cr>==gi

" move selected text easily
vnoremap < <gv
vnoremap > >gv

" mantain search result in the middle of the screen
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz
vnoremap <silent> n nzz
vnoremap <silent> N Nzz
vnoremap <silent> * *zz
vnoremap <silent> # #zz
vnoremap <silent> g* g*zz
vnoremap <silent> g# g#zz

" map arrow keys to nothing in normal and visual mode
nnoremap <silent> <up> <nop>
nnoremap <silent> <down> <nop>
nnoremap <silent> <left> <nop>
nnoremap <silent> <right> <nop>
vnoremap <silent> <up> <nop>
vnoremap <silent> <down> <nop>
vnoremap <silent> <left> <nop>
vnoremap <silent> <right> <nop>

" remove highlight
nnoremap <silent> <leader>, :nohlsearch<cr>

" easy out of insert
inoremap <silent> jk <esc>
inoremap <silent> <esc> <nop>

" navigate through tabs
nnoremap <c-l> :tabnext<cr>
nnoremap <c-h> :tabprev<cr>
