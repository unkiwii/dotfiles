" vim:foldmethod=marker:expandtab:

if exists("g:loaded_unkiwiivimrc")
    finish
endif
let g:loaded_unkiwiivimrc = 1

let g:pyflakes_use_quickfix = 0
let g:pep8_map = '<leader>p'

try
    execute pathogen#infect()
catch
    echom "ERROR: Can't find pathogen"
endtry

let mapleader=","

"" vimrc edit
nnoremap <leader>v <esc>:tabedit $MYVIMRC<cr>

"" Source project.vimrc (if there is one)
try
    exec "source " . getcwd() . "/.project.vimrc"
    nnoremap <leader>lv <esc>:tabedit .project.vimrc<cr>
catch
endtry

if !has('gui_running')
    set t_Co=256
else
    set encoding=utf-8
endif

if has('multi_byte')
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  set fileencodings=utf-8,latin1
endif

syntax on
filetype on
filetype indent on
filetype plugin on

" general config {{{1
set modeline
set ruler
set number
set autoindent
set smartindent
set guioptions=ai
set smarttab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set nowrap
set showcmd
set showmode
set showmatch
set hlsearch
set incsearch
set clipboard=unnamed
set nobackup
set cursorline
set list
set listchars=eol:¶,tab:»\ ,trail:·
set wildmode=full
set wildmenu
set path=.,**
set laststatus=2 "show status bar always
set splitbelow
set backspace=indent,eol,start
set noerrorbells
set visualbell
set t_vb=
set expandtab
" }}}1

set rulerformat=%=%y\ %l,%c\ %P
if has('statusline')
    set statusline=%<%f\ \%=%{&ff}\ %y\ %l,%c\ %P
endif

" os specific config {{{1
if has("win16") || has("win32") || has("win64")
    set guifont=Consolas:h10
    set undodir=
    let g:vimfilespath=system("echo %userprofile%/vimfiles")
    let g:openurlcommand="start"
    let g:echonewline='echo|set /p='
else
    set guifont=Inconsolata\ 10
    set undodir=~/.vim/undo
    let g:vimfilespath='~/.vim'
    let g:openurlcommand="xdg-open"
    let g:echonewline='echo -e -n "\n'
endif
" }}}1

set undofile
set undolevels=1000
set undoreload=10000

" useful functions {{{1
function! s:nprint(...)
    let l:message = ""
    if a:0 > 0
        let l:message = join(a:000, ' ')
    endif
    execute "silent !" . g:echonewline . l:message . '"'
endfunction

function! s:SaveCursorPosition()
    let s:cursorPosition = getpos(".")
endfunction

function! s:RestoreCursorPosition()
    call setpos(".", s:cursorPosition)
    call cursor(s:cursorPosition[1], s:cursorPosition[2], s:cursorPosition[3])
    unlet s:cursorPosition
endfunction

function! s:Make(makeprg, errorformat)
    try
        let savedMakePrg=&makeprg
        set makeprg=a:makeprg
        let savedErrorFormat=&errorformat
        set errorformat=a:errorformat
        :make!
    finally
        let &makeprg=savedMakePrg
        let &errorformat=savedErrorFormat
    endtry
endfunction

function! s:GrepInPath(word, extensions)
    let l:fullPath = &path
    let l:pathList = split(l:fullPath, ",")
    let l:dict = {}
    for folder in l:pathList
        let l:dict[folder] = ''
    endfor
    let l:pathList = keys(l:dict)
    let l:searchPath = ""
    for folder in l:pathList
        for extension in a:extensions
            let l:searchPath = l:searchPath . " " . folder . "/*." . extension
        endfor
    endfor
    echom "vimgrep /" . a:word . "/j " . l:searchPath . " | cw"
    silent execute "vimgrep /" . a:word . "/j " . l:searchPath . " | cw"
endfunction

function! s:FindInFiles(extensions)
    call inputsave()
    let l:word = input('Search in files: ')
    call inputrestore()
    call s:GrepInPath(l:word, a:extensions)
endfunction

function! s:HashWord()
    call s:SaveCursorPosition()
    normal! viwy
    normal! A //
    execute ":read !hasher -u " . getreg('"')
    normal! kJ
    call s:RestoreCursorPosition()
endfunction
nnoremap <silent> <leader>h <esc>:call <sid>HashWord()<cr>

function! s:OpenUrl(url)
    execute "!" . g:openurlcommand . " " . a:url
endfunction
" }}}1

" maps {{{1
"" search using <space>
nnoremap <space> /

"" move visually
nnoremap j gj
nnoremap k gk

"" remove Ex mode map
nnoremap Q <nop>

"" bye bye :Q errors!
command! Q q
command! Qall qall

"" write. always.
cmap w!! w !sudo tee % >/dev/null

"" move lines up or down
vnoremap <silent> <c-j> :m '>+1<cr>gv=gv
vnoremap <silent> <c-k> :m '<-2<cr>gv=gv
nnoremap <silent> <c-j> :m .+1<cr>==
nnoremap <silent> <c-k> :m .-2<cr>==
inoremap <silent> <c-j> <esc>:m .+1<cr>==gi
inoremap <silent> <c-k> <esc>:m .-2<cr>==gi

"" move selected text easily
vnoremap < <gv
vnoremap > >gv

"" mantain search resul in the middle of the screen
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz

"" map arrow keys to nothing in insert and normal mode
nnoremap <silent> <up> <nop>
nnoremap <silent> <down> <nop>
nnoremap <silent> <left> <nop>
nnoremap <silent> <right> <nop>
vnoremap <silent> <up> <nop>
vnoremap <silent> <down> <nop>
vnoremap <silent> <left> <nop>
vnoremap <silent> <right> <nop>

"" split lines (inverse of J)
nnoremap <silent> <c-s> ylpr<Enter>

"" remove highlight with <esc>
nnoremap <silent> <esc> :nohlsearch<cr>

"" jump to tag (changed for compatibility with strange keyboards)
nnoremap <silent> <c-t> <c-]>

"" fix indentation
function! s:FixIndentation()
    call s:SaveCursorPosition()
    normal! gg=G
    call s:RestoreCursorPosition()
endfunction
noremap <silent> <leader>i <esc>:call <sid>FixIndentation()<cr>

"" tagbar
nnoremap <silent> <leader>t <esc>:TagbarToggle<cr>

"" navigate through tabs
nnoremap <c-l> :tabnext<cr>
nnoremap <c-h> :tabprev<cr>

"" insert line numbers
nnoremap <silent> <leader>n <esc>:%s/^/\=printf('%d ', line('.'))<cr>
" }}}1

" autocmd maps {{{1
if has("autocmd")
    """ C++ {{{2
    function! s:SwitchSourceHeader()
        let extension = expand("%:e")
        if extension == "c" || extension == "cpp"
            try
                find %:t:r.h
            catch
                new %:r.h
            endtry
        elseif extension == "h" || extension == "hpp"
            try
                find %:t:r.cpp
            catch
                let includeFile = expand("%:t")
                new %:r.cpp
                execute "normal! i#include \"" . includeFile . "\""
            endtry
        endif
    endfunction

    function! s:CppCheck()
        call s:Make("cppcheck\ --enable=all\ -j\ 4\ .", "\[%f:%l\]:\ (%t%s)\ %m")
    endfunction

    function! s:WriteSafeGuard()
        let l:cursor_position = line('.') + 3
        let l:prefix = "PROJECT"
        if exists("g:unkiwii_project")
            let l:prefix = g:unkiwii_project.name
        endif
        let l:safename = l:prefix . "_" . expand("%:t")
        let l:safename = substitute(toupper(l:safename), "[\\.\-]", "_", "g")
        normal! gg
        execute "normal! O#ifndef " . l:safename
        execute "normal! o#define " . l:safename
        normal! o
        execute "normal! Go#endif//" . l:safename
        normal! O
        execute l:cursor_position
    endfunction

    function! s:CppApi()
        call s:OpenUrl("http://www.cplusplus.com/search.do?q=" . expand("<cword>"))
    endfunction

    """" find the word under cursor
    autocmd FileType cpp nnoremap <c-f> :call <sid>GrepInPath(expand("<cword>"), ["cpp", "h"])<cr>
    autocmd FileType cpp nnoremap <leader>f :call <sid>FindInFiles(["cpp", "h"])<cr>

    """" set options for c indentation
    autocmd FileType cpp set cinoptions=g0,N-s,i0,W4,m1,(s

    autocmd FileType cpp noremap <silent> <leader>s <esc>:call <sid>SwitchSourceHeader()<cr>
    autocmd FileType cpp noremap <silent> <leader>S <esc>:split<cr>:call <sid>SwitchSourceHeader()<cr>
    autocmd FileType cpp noremap <silent> <leader>ca <esc>:call <sid>CppApi()<cr><cr>
    autocmd FileType cpp noremap <c-f9> :call <sid>CppCheck()<cr>

    autocmd BufWinEnter *.h,*.hpp,*.h++ nnoremap <leader>. :call <sid>WriteSafeGuard()<cr>
    """ }}}2

    """ Java {{{2
    function! s:CompileAndroid()
        lcd proj.android
        call s:Make("ant", "%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#")
        lcd -
    endfunction
    autocmd FileType java nnoremap <silent> <leader>jb <esc>:call <sid>CompileAndroid()<cr>
    """ }}}2

    """ Unity3d {{{2
    function! s:UnityApi()
        call s:OpenUrl("http://unity3d.com/support/documentation/ScriptReference/30_search.html?q=" . expand("<cword>"))
    endfunction

    function! s:NewMonobehavior()
        tabnew
        execute "normal Ousing UnityEngine;"
        execute "normal ousing System.Collections;"
        execute "normal o"
        execute "normal opublic class NewBehaviourScript : MonoBehaviour {"
        execute "normal ovoid Start () {"
        execute "normal o"
        execute "normal o	}"
        execute "normal o"
        execute "normal o	void Update () {"
        execute "normal o"
        execute "normal o	}"
        execute "normal o}"
        setf cs
        execute "normal 4Gww"
    endfunction

    function! s:CSharpPropertyDoc()
        execute "normal O/// <summary>\n/// \n/// </summary>"
        execute "normal j"
    endfunction

    " create xml comments for the method defined in the cursor line
    function! s:CSharpMethodDoc() 
        let matches = matchlist(getline("."), '\s*\(.*\)(\(.*\)).*')
        if len(matches) > 0
            execute "normal O/// <summary>\n/// \n/// </summary>"
            execute "normal j"
            if strwidth(matches[2]) > 0
                let params = split(matches[2], ',')
                normal k
                let i = 0
                let paramCount = 0
                while i < len(params)
                    if len(params[i]) > 0
                        execute 'normal o/// <param type="' . matchlist(params[i], '\(\w\+\) \w\+')[1] . '" name="' . matchlist(params[i], '\w\+ \(\w\+\)')[1] .'"></param>'
                        let paramCount = paramCount + 1
                    endif
                    let i = i + 1
                endwhile
                execute "normal " . (1 + paramCount) . "k"
            endif
        else
            call s:CSharpPropertyDoc()
        endif
    endfunction

    autocmd FileType cs set expandtab
    autocmd FileType cs nnoremap <silent> <leader>ua :call <sid>UnityApi()<cr>
    autocmd FileType cs nnoremap <silent> <leader>uc :call <sid>CSharpMethodDoc()<cr>
    autocmd FileType cs nnoremap <silent> <leader>unb :call <sid>NewMonobehavior()<cr>
    """ }}}2

    """ Python {{{2
    function! s:SetPythonEnv()
        set list
        set expandtab
        set tabstop=4
        set shiftwidth=4
        set softtabstop=4
        set foldmethod=indent
        set foldlevel=99

        highlight OverLength ctermbg=red ctermfg=white guibg=#592929
        match OverLength /\%81v.\+/
    endfunction

    function! s:PythonRun()
        execute "!python ./" . expand("%")
    endfunction

    function! s:PythonCheck()
        try
            call Pep8()
            let tlist=getqflist() ", 'get(v:val, ''bufnr'')')
            if !empty(tlist)
                cc
            endif
        catch
            echohl ErrorMsg
            echom "Can't call Pep8()"
            echohl NONE
            echom ""
        endtry
    endfunction

    autocmd FileType python call <sid>SetPythonEnv()
    autocmd FileType python nnoremap <silent> <leader>r :call <sid>PythonRun()<cr>
    autocmd FileType python nnoremap <c-f> :call <sid>GrepInPath(expand("<cword>"), ["py", "pyw"])<cr>
    autocmd FileType python nnoremap <leader>f :call <sid>FindInFiles(["py", "pyw"])<cr>
    autocmd BufWrite *.py,*.pyw call <sid>PythonCheck()
    """ }}}2

    """ Markdown {{{2
    function! s:ViewMarkdown()
        execute "!pandoc -f markdown_github -t html5 " . expand("%") . " > md.html ; google-chrome md.html; rm md.html"
    endfunction

    autocmd FileType markdown nnoremap <leader>r :call<sid>ViewMarkdown()<cr>
    autocmd FileType markdown set wrap
    """ }}}2

    """ sh {{{2
    function! s:ShellCheck(file)
        set makeprg=shellcheck\ -f\ gcc
        set errorformat=%f:%l:%c:\ %trror:\ %m,%f:%l:%c:\ %tarning:\ %m,%f:%l:%c:\ %tote:\ %m
        execute "make " . a:file
        cw
    endfunction

    autocmd FileType sh nnoremap <leader>r :call <sid>ShellCheck(expand("%"))<cr>
    """ }}}2

    autocmd FileType text set nolist

    autocmd BufRead .vimrc,vimrc setf vim

    autocmd BufRead *.as setf javascript
    autocmd BufRead *.as nnoremap <c-f> :call <sid>GrepInPath(expand("<cword>"), ["as"])<cr>
    autocmd BufRead *.as nnoremap <leader>f :call <sid>FindInFiles(["as"])<cr>

    " show cursor line in the current window only
    augroup CursorLine
        au!
        au VimEnter * setlocal cursorline
        au WinEnter * setlocal cursorline
        au BufWinEnter * setlocal cursorline
        au WinLeave * setlocal nocursorline
    augroup END

    """ ANTLR {{{2
    autocmd BufNewFile,BufRead *.g4 setf antlr
    autocmd BufNewFile,BufRead *.g4 set makeprg="antlr4"
    """ }}}2

    """ go to the last visited line in a file when reopen it
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif	"has(autocmd)
" }}}1

" unkiwii_project related stuff {{{1
if exists("g:unkiwii_project")
    function! s:Compile()
        exec "lcd " . g:unkiwii_project.makepath
        if exists("g:unkiwii_project.cmake")
            execute "!" . g:unkiwii_project.cmake
        endif
        make
        cc
        lcd -
    endfunction

    function! s:CompileAsian()
        exec "lcd " . g:unkiwii_project.makepath
        if exists("g:unkiwii_project.cmake")
            execute "!" . g:unkiwii_project.cmake
        endif
        make -f Makefile-asian
        cc
        lcd -
    endfunction

    function! s:CleanCompile()
        exec "lcd " . g:unkiwii_project.makepath
        if exists("g:unkiwii_project.cmake")
            execute "!" . g:unkiwii_project.cmake
        endif
        make clean
        make
        cc
        lcd -
    endfunction

    function! s:CleanDepsCompile()
        exec "lcd " . g:unkiwii_project.makepath
        if exists("g:unkiwii_project.cmake")
            execute "!" . g:unkiwii_project.cmake
        endif
        make cleandeps
        make
        cc
        lcd -
    endfunction

    function! s:Run()
        exec "!" . g:unkiwii_project.executable
    endfunction

    function! s:RunGrepCWORD()
        exec "!" . g:unkiwii_project.executable . " | grep '<cword>'"
    endfunction

    function! s:AndroidRun()
        exec "!" . g:unkiwii_project.path . "/android_build_install.sh -d -i"
    endfunction

    function! s:AndroidRunAsian()
        exec "!" . g:unkiwii_project.path . "/android_build_install.sh -d -i -l asian"
    endfunction

    noremap <silent> <leader>b <esc>:call <sid>Compile()<cr><cr>:cl<cr>
    noremap <silent> <leader>C <esc>:call <sid>CompileAsian()<cr><cr>:cl<cr>
    noremap <silent> <leader>B <esc>:call <sid>CleanCompile()<cr>:cl<cr>
    noremap <silent> <leader>d <esc>:call <sid>CleanDepsCompile()<cr>:cl<cr>
    noremap <silent> <leader>r <esc>:call <sid>Run()<cr>
    noremap <silent> <leader>R <esc>:call <sid>RunGrepCWORD()<cr>
    noremap <silent> <leader>a <esc>:call <sid>AndroidRun()<cr>
    noremap <silent> <leader>A <esc>:call <sid>AndroidRunAsian()<cr>

    let s:ctagsArgs = {
                \ "cpp" : '--recurse --extra=+fq --fields=+ianmzS --c++-kinds=+p',
                \ "cs" : '--recurse --extra=+fq --fields=+ianmzS --c\#-kinds=cimnp'
                \ }

    if has_key(g:unkiwii_project, 'ctagstype') && has_key(s:ctagsArgs, g:unkiwii_project.ctagstype)
        " set tags variable
        for library_path in g:unkiwii_project.libraries
            let tagfile = g:vimfilespath . "/tags/" . substitute(library_path, "[\\/]", "_", "g")
            execute "set tags+=" . tagfile
        endfor

        " function to build all tags needed for the project (need exuberant-ctags installed) (works with C/C++)
        function! s:BuildTags()
            let tagsdir = g:vimfilespath . "/tags/"
            execute "!mkdir " . tagsdir . " 2&> /dev/null"
            for library_path in g:unkiwii_project.libraries
                " create tags for libraries
                let tagfile = tagsdir . substitute(library_path, "[\\/]", "_", "g")
                call s:nprint()
                call s:nprint(">> Building tags for", library_path)
                execute "!ctags " . s:ctagsArgs[g:unkiwii_project.ctagstype] . " -f " . tagfile . " " . l:library_path
            endfor
            " create tags for current project
            call s:nprint()
            call s:nprint(">> Building tags for project", g:unkiwii_project.name)
            execute "!ctags " . s:ctagsArgs[g:unkiwii_project.ctagstype] . " *"
        endfunction
        nnoremap <leader>T <esc>:call <sid>BuildTags()<cr>
    endif
endif
"" end "project" related stuff }}}1

" comment and uncomment lines {{{1
let s:commentPrefixes = {
            \ "cpp" : '// ',
            \ "c" : '// ',
            \ "cs" : '// ',
            \ "css" : '// ',
            \ "java" : '// ',
            \ "javascript" : '// ',
            \ "sh" : '# ',
            \ "python" : '# ',
            \ "dosbatch" : '@REM ',
            \ "dosini" : '# ',
            \ "vim" : '" ',
            \ "yaml" : '# ',
            \ "nl" : '# ',
            \ "markdown" : '<!-- '
            \ }

let s:commentSuffixes = {
            \ "markdown" : ' -->'
            \ }

function! s:ToggleLineComment()
    let l:lastSearch = @/
    try
        let l:prefix = ""
        if has_key(s:commentPrefixes, &ft)
            let l:prefix = s:commentPrefixes[&ft]
        endif

        let l:suffix = ""
        if has_key(s:commentSuffixes, &ft)
            let l:suffix = s:commentSuffixes[&ft]
        endif

        let l:isCommented = strpart(getline("."), 0, strlen(l:prefix))
        if l:isCommented == l:prefix
            execute ":silent s/" . escape(l:prefix, '/"[]') . "//"
            execute ":silent s/" . escape(l:suffix, '/"[]') . "$//"
        else
            silent execute "normal! 0i" . l:prefix
            silent execute "normal! A" . l:suffix
        endif
    catch
        echom "[ToggleLineComment] " . v:exception
    endtry
    let @/ = l:lastSearch
endfunction

vnoremap <silent> <leader>+ <esc>:'<,'>call <sid>ToggleLineComment()<cr>gv
nnoremap <silent> <leader>+ <esc>:call <sid>ToggleLineComment()<cr>
" }}}1

" show highlight group of word under cursor {{{1
nnoremap sh :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>
" }}}1

" hide files from netrw
let g:netrw_list_hide='.*\.swp$,.*\.meta$,.*\.pyc$'

try
    set ff=unix
endtry

" colorscheme (at the end for plugins to work)
colorscheme unkiwii

"" Source project.vimrc.after (if there is one)
try
    exec "source " . getcwd() . "/.project.vimrc.after"
    nnoremap <leader>lva <esc>:tabedit .project.vimrc.after<cr>
catch
endtry
