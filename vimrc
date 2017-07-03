" vim:foldmethod=marker:expandtab:

let loaded_netrwPlugin = 1  " disable netrwPlugin

let mapleader=","

source ~/.vimrc.bundles

syntax on
filetype plugin indent on

" ========================================
" => Options
" ========================================

set mouse=

set nocompatible

set cryptmethod=blowfish2

set encoding=utf8
set fileencoding=utf8
set termencoding=utf8

set autowrite
set autoread

set clipboard=unnamedplus

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
set wildmode=longest,full

set ttyfast       " faster drawing
set lazyredraw    " redraw only when need to

set nowrap
set textwidth=0

set cursorline
set guioptions=ai
set number
set path=.,**

" source a .vimrc in the current folder if there is one
set exrc
" and restrict the execution of some commands on those non default .vimrc files
set secure

set laststatus=2 "show status bar always
set ruler
set rulerformat=%30(%=%y\ %l,%c\ %P%)

set ts=2 sts=2 sw=2 expandtab smarttab

" set timeoutlen and ttimeoutlen so <esc> doesn't wait forever
set timeoutlen=1000 ttimeoutlen=0

" tell vim that the terminal supports 256 colors
set t_Co=256
set background=dark
colorscheme mlessnau

" change cursor shape
if &term == "st" || &term == "st-256color"
  let &t_SI="\033[6 q"
  let &t_SR="\033[4 q"
  let &t_EI="\033[2 q"
elseif exists('$TMUX')
  let &t_SI="\033Ptmux;\033\033[6 q\033\\"
  let &t_SR="\033Ptmux;\033\033[4 q\033\\"
  let &t_EI="\033Ptmux;\033\033[2 q\033\\"
endif

" ========================================
" => Autocommands
" ========================================

if has('autocmd') && !exists('autocommands_loaded')
  let autocommands_loaded = 1

  autocmd FileType nerdtree setlocal nolist

  autocmd BufNewFile,BufRead *.jsdoc setf javascript

  autocmd FileType javascript   setlocal ts=2 sts=2 sw=2    expandtab     smarttab
  autocmd FileType go           setlocal ts=4 sts=4 sw=4  noexpandtab   nosmarttab
  autocmd FileType c            setlocal ts=2 sts=2 sw=2    expandtab     smarttab
  autocmd FileType python       setlocal ts=4 sts=4 sw=4    expandtab   nosmarttab

  autocmd FileType c    call s:SetupTags('c')
  autocmd FileType cpp  call s:SetupTags('c')

  autocmd InsertEnter * hi StatusLine ctermfg=15 ctermbg=88
  autocmd InsertLeave * hi StatusLine ctermfg=0 ctermbg=15

  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
endif

" ========================================
" => Mappings
" ========================================

" set the leader key
nnoremap <leader>v :tabedit $MYVIMRC<cr>
nnoremap <leader>b :tabedit $MYVIMRC.bundles<cr>

" move visually
nnoremap j gj
nnoremap k gk

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
nnoremap <silent> % %zz
vnoremap <silent> n nzz
vnoremap <silent> N Nzz
vnoremap <silent> * *zz
vnoremap <silent> # #zz
vnoremap <silent> g* g*zz
vnoremap <silent> g# g#zz
vnoremap <silent> % %zz

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
nnoremap <silent> ; :nohlsearch<cr>
vnoremap <silent> ; <esc>:nohlsearch<cr>

" <Shift-s>: inverse of <Shift-j>
nnoremap <silent> <s-s> a<cr><esc>

" navigate through tabs
nnoremap <c-l> :tabnext<cr>
nnoremap <c-h> :tabprev<cr>

" make Y to yank to end of line (like other commands)
nnoremap <s-y> y$

" find using vimgrep
nnoremap <leader>s :vimgrep /
cmap <leader>s / src/*

" show current word hightlight info
nnoremap <leader>h :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>

" diff mappings
if &diff
  nnoremap <silent> <c-j> ]c
  nnoremap <silent> <c-k> [c
  nnoremap <silent> <c-h> :diffget<cr>]c
  nnoremap <silent> <c-l> :diffput<cr>]c
  nnoremap <silent> <leader>r :diffupdate<cr>
endif

" ========================================
" => Aliases / Abbreviations
" ========================================

abbreviate funciton function
abbreviate fucntion function

" ========================================
" => Script Functions
" ========================================

function! s:SetupTags(type)
  let l:ctags_args = {
    \ "c": '--recurse --extra=+q --fields=+iaS --c++-kinds=+p'
    \ }
  silent execute "!ctags " . l:ctags_args[a:type] . " ."
endfunction
