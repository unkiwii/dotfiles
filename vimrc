" vim:foldmethod=marker:expandtab:

let loaded_netrwPlugin = 1  " disable netrwPlugin

let mapleader = ","

let s:vimrc = "~/.vimrc"
let s:vundles = "~/.vimrc.bundles"

let s:isMacOSX = has("unix") && (system("echo -n \"$(uname -s)\"") == "Darwin")
let s:isWindows = has("win32")
let s:isLinux = has("linux")

if s:isWindows
  set guifont=Consolas:h14
  let s:vundles = "~/_vimrc.bundles"
endif

execute ":source " . s:vundles

syntax on
filetype plugin indent on

" ========================================
" => Options
" ========================================

set mouse=

set nocompatible

if s:isWindows
  set cryptmethod=blowfish2
  set encoding=utf8
  set fileencoding=utf8
  set termencoding=utf8
endif

set autowrite
set autoread

if s:isLinux
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

set completeopt=longest,menuone

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
if s:isWindows
  set listchars=eol:$,tab:\|\ ,trail:-,nbsp:X
else
  set listchars=eol:¶,tab:\|\ ,trail:·,nbsp:◊
endif

set wildmenu
set wildmode=longest,full

set ttyfast       " faster drawing
" set lazyredraw    " redraw only when need to

set nowrap
set textwidth=0

set splitright    " open new buffer on the right of the current one (with vsplit)
set splitbelow    " open new buffer below the current one (with split)

set cursorline
set guioptions=ai
set number
set path=.,**

" source a .vimrc in the current folder if there is one
set exrc
" and restrict the execution of some commands on those non default .vimrc files
set secure

" syntax max columns (default is 3000 and can be slow)
set synmaxcol=1000

set laststatus=2 "show status bar always
set ruler
set rulerformat=%30(%=%y\ %l,%c\ %P%)

set ts=2 sts=2 sw=2 expandtab smarttab

" set timeoutlen and ttimeoutlen so <esc> doesn't wait forever
set timeoutlen=1000 ttimeoutlen=0

" tell vim that the terminal supports 256 colors
set t_Co=256
set background=dark

if executable('ag')
  set grepprg=ag\ --hidden\ --nogroup\ --nocolor\ --column\ --vimgrep\ -i\ -r\ $*
  set grepformat=%f:%l:%c:%m
endif

if s:isWindows
  colorscheme unkiwii
else
  colorscheme mlessnau
endif

" change cursor shape
if &term == "st" || &term == "st-256color"
  let &t_SI = "\033[6 q"
  let &t_SR = "\033[4 q"
  let &t_EI = "\033[2 q"
elseif exists('$TMUX')
  let &t_SI = "\033Ptmux;\033\033[6 q\033\\"
  let &t_SR = "\033Ptmux;\033\033[4 q\033\\"
  let &t_EI = "\033Ptmux;\033\033[2 q\033\\"
endif

" ========================================
" => Autocommands
" ========================================

if has('autocmd') && !exists('autocommands_loaded')
  let autocommands_loaded = 1

  autocmd FileType nerdtree setlocal nolist

  augroup file_detection
    autocmd!
    autocmd BufNewFile,BufRead *.jsdoc setf javascript
    autocmd BufNewFile,BufRead *.apib setf apiblueprint
  augroup END

  augroup file_type_spacing
    autocmd!
    autocmd FileType javascript   setlocal ts=2 sts=2 sw=2    expandtab     smarttab
    autocmd FileType go           setlocal ts=4 sts=4 sw=4  noexpandtab   nosmarttab
    autocmd FileType c            setlocal ts=2 sts=2 sw=2    expandtab     smarttab
    autocmd FileType python       setlocal ts=4 sts=4 sw=4    expandtab   nosmarttab
    autocmd FileType groovy       setlocal ts=4 sts=4 sw=4    expandtab   nosmarttab
    autocmd FileType java         setlocal ts=4 sts=4 sw=4    expandtab   nosmarttab
    autocmd FileType apiblueprint setlocal ts=4 sts=4 sw=4    expandtab   nosmarttab
  augroup END

  augroup tags_generation
    autocmd!
    autocmd FileType c      call s:GenerateTags('c', 0)
    autocmd FileType cpp    call s:GenerateTags('c', 0)
    autocmd FileType groovy call s:GenerateTags('groovy', 0)
    autocmd FileType java   call s:GenerateTags('java', 0)
  augroup END

  augroup status_line_colors
    autocmd!
    autocmd InsertEnter * hi StatusLine ctermfg=15 ctermbg=88
    autocmd InsertLeave * hi StatusLine ctermfg=0 ctermbg=15
  augroup END

  augroup auto_cursor_line
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
  augroup END

  augroup error_maps
    autocmd!
    autocmd WinEnter quickfix call s:SetErrorListMaps(1)
    autocmd WinLeave quickfix call s:SetErrorListMaps(0)
  augroup END

  if exists("##CmdlineEnter") && exists("##CmdlineLeave")
    let s:searched = 0
    autocmd CursorMoved * call s:OnCursorMoved()
    autocmd CmdlineEnter [\/?] let s:searched = 0
    autocmd CmdlineLeave [\/?] let s:searched = 1
  endif
endif

" ========================================
" => Mappings
" ========================================

" reload .vimrc
execute ":nnoremap <leader>r :source " . s:vimrc . "<cr>"

" edit .vimrc and .vimrc.bundles
execute ":nnoremap <leader>v :tabedit " . s:vimrc . "<cr>"
execute ":nnoremap <leader>b :tabedit " . s:vundles . "<cr>"

" move visually
nnoremap j gj
nnoremap k gk

" remove Ex mode map
nnoremap Q <nop>

" write. always.
cnoremap w!! w !sudo tee % >/dev/null

" traverse the 'error' list
nnoremap <silent> cn :cn<cr>zz
nnoremap <silent> cp :cp<cr>zz

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
nnoremap <silent> <c-]> <c-]>zz

" map arrow keys to nothing in insert, normal and visual mode
inoremap <silent> <up> <nop>
inoremap <silent> <down> <nop>
inoremap <silent> <left> <nop>
inoremap <silent> <right> <nop>
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

" <shift-s>: inverse of <shift-j>
nnoremap <silent> <s-s> a<cr><esc>

" navigate through tabs
if s:isMacOSX
  nnoremap <silent> ¬ :tabnext<cr>
  nnoremap <silent> ˙ :tabprev<cr>
else
  nnoremap <silent> <a-l> :tabnext<cr>
  nnoremap <silent> <a-h> :tabprev<cr>
endif

" move lines up and down
if s:isMacOSX
  nnoremap <silent> ˚ :m .-2<CR>==
  nnoremap <silent> ∆ :m .+1<CR>==
  inoremap <silent> ˚ <esc>:m .-2<cr>==gi
  inoremap <silent> ∆ <esc>:m .+1<cr>==gi
  vnoremap <silent> ˚ :m '<-2<cr>gv=gv
  vnoremap <silent> ∆ :m '>+1<cr>gv=gv
else
  nnoremap <silent> <a-k> :m .-2<CR>==
  nnoremap <silent> <a-j> :m .+1<CR>==
  inoremap <silent> <a-k> <esc>:m .-2<cr>==gi
  inoremap <silent> <a-j> <esc>:m .+1<cr>==gi
  vnoremap <silent> <a-k> :m '<-2<cr>gv=gv
  vnoremap <silent> <a-j> :m '>+1<cr>gv=gv
endif

" make Y to yank to end of line (like other commands)
nnoremap Y y$

" open a terminal and close it when we are done
nnoremap <leader>s :terminal ++close<cr>

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
" => Commands
" ========================================

" :Vtag <tag>
command! -complete=tag -nargs=1 Vtag vert stag <args>

" ========================================
" => Script Functions
" ========================================

let s:tags_command = {
  \ "c": 'ctags --recurse --sort=yes --extra=+q --fields=+iaS --c++-kinds=+p --exclude=.git',
  \ "go": 'ctags --recurse --sort=yes --exclude=.git --language-force=go',
  \ "groovy": 'ctags --recurse --sort=yes --exclude=target --exclude=.git --language-force=groovy',
  \ "java": 'ctags --recurse --sort=yes --exclude=.git --language-force=Java'
  \ }

function! s:GenerateTags(type, force)
  if a:force || !filereadable("tags")
    if has("job")
      let l:job = job_start(s:tags_command[a:type] . " .")
    else
      silent execute "!" . s:tags_command[a:type] . " ."
    endif
  endif
endfunction

function! s:OnCursorMoved()
  if s:searched == 1
    normal zz
    let s:searched = 0
  endif
endfunction
