" vim:foldmethod=marker:expandtab:

" if exists("g:loaded_unkiwiivimrc")
    " finish
" endif
" let g:loaded_unkiwiivimrc = 1

syntax on
filetype plugin indent on

" set the leader key
let mapleader=","

" edit this file with a simple mapping
nnoremap <leader>v <esc>:tabedit $MYVIMRC<cr>

" pathogen stuff {{{1
try
    execute pathogen#infect()
catch
    echom "ERROR: Can't find pathogen"
endtry

try
    execute pathogen#helptags()
catch
    echom "ERROR: Can't run pathogen#helptags()"
endtry
" }}}1

" Source project.vimrc (if there is one)
try
    exec "source " . getcwd() . "/.project.vimrc"
    nnoremap <leader>lv <esc>:tabedit .project.vimrc<cr>
catch
endtry

if !has('gui_running')
    set t_Co=256
endif

" set viewdir (so mkview and loadview save files there)
if exists("*mkdir")
    let &viewdir = expand("$HOME") . "/.vim/views"
    if !isdirectory(&viewdir)
        call mkdir(&viewdir, "p")
    endif
endif

" file encoding
if has('multi_byte')
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8
    set fileencodings=utf-8,latin1
endif

" general config {{{1
set nocompatible

set autowrite
set autoread

set clipboard+=unnamedplus

set modeline
set modelines=5

set nowritebackup
set nobackup

set hlsearch
set incsearch

" do not insert comment leader when o or O is pressed in normal mode
set formatoptions-=o

set nowrap
set textwidth=120

set autoindent
set smartindent

set backspace=indent,eol,start

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

set cursorline
set guioptions=ai
set number
set path=.,**

set splitbelow
set splitright

" show a nicer status bar
set laststatus=2 "show status bar always
set ruler
set rulerformat=%=%y\ %l,%c\ %P
if has('statusline')
    function! StatusLine()
        let l:trunc = "%<"
        let l:modified = "%m"
        let l:name = "%f"
        let l:file_format = "%{&ff}"
        let l:file_type = "%y"
        let l:position = "%l,%c"
        let l:percentage = "%P"

        " let l:folder = expand("%:h")
        " if len(l:folder)
            " execute 'lcd ' . l:folder
        " endif

        " let l:git_branch = substitute(system('git rev-parse --abbrev-ref HEAD 2> /dev/null'), '\n\+$', '', '')

        " if len(l:folder)
            " execute 'lcd -'
        " endif

        " if len(l:git_branch) == 0
            " let l:git_branch = ""
        " else
            " let l:git_branch = "(" . l:git_branch . ") "
        " endif

        let l:left_side = l:trunc . l:modified . l:name
        " let l:right_side = l:git_branch . l:file_format . " " . l:file_type . " " . l:position . " " . l:percentage
        let l:right_side = l:file_format . " " . l:file_type . " " . l:position . " " . l:percentage

        return l:left_side . "%=" . l:right_side
    endfunction
    set statusline=%!StatusLine()
endif
" }}}1

" set indent options, this sets tabstop, shiftwidth, softtabstop, expandtab and smarttab options {{{1
function! s:SetIndentOptions(options)
    let sps = get(a:options, 'spaces', 2)
    let &tabstop=sps
    let &shiftwidth=sps
    let &softtabstop=sps

    if get(a:options, 'expandtab', 1)
        set expandtab
    else
        set noexpandtab
    endif

    if get(a:options, 'smarttab', 1)
        set smarttab
    else
        set nosmarttab
    endif
endfunction

call s:SetIndentOptions({"spaces": 2, "expandtab": 1, "smarttab": 1})
" }}}1

" make a simple 'search' text object
" vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
" omap s :normal vs<CR>

" os specific options {{{1
if has("win16") || has("win32") || has("win64")
    let g:platform="windows"
else
    let g:platform="unix"
endif

if g:platform == "windows"
    set guifont=Consolas:h10
    let s:platform_undodir=''
    let g:vimfilespath=system("echo %userprofile%/vimfiles")
    " remove CR LF from the 'echo' output
    let g:vimfilespath=strpart(g:vimfilespath, 0, strlen(g:vimfilespath) - 2)
    let g:openurlcommand="start"
    let g:echonewline='echo'
else
    set guifont=Inconsolata\ 10
    let s:platform_undodir='~/.vim/undo'
    let g:vimfilespath='~/.vim'
    let g:openurlcommand="open"
    let g:echonewline='echo -e -n "\n'
endif
" }}}1

if v:version > 702
    set undodir=s:platform_undodir
    set undofile
    set undolevels=1000
    set undoreload=10000
endif

" useful functions {{{1
function! s:CenterTitle(fillChar)
    let tmp = "-"
    if a:fillChar == tmp
        tmp = "+"
    endif

    let lineSize = strlen(getline('.'))
    if lineSize < &textwidth && lineSize > 0
        execute ":s/^\\s\\+"
        execute "normal I" . tmp
        execute "normal A" . tmp
        execute ":s/\\s/" . tmp . "/ge"
        execute ":center"
        execute ":s/\\s/" . a:fillChar . "/g"
        execute ":s/" . tmp . "/ /g"
        execute "normal 0viwy"
        execute "normal $p"
    endif

    let lineSize = strlen(getline('.'))
    if lineSize < &textwidth
        execute "normal " . (&textwidth - lineSize) . "A" . a:fillChar
    endif
endfunction

function! s:MakeFolder(folder)
    if has("win16") || has("win32") || has("win64")
        let sysfolder = substitute(a:folder, "[\\/]", "\\", "g")
        execute "!mkdir " . sysfolder . " > NUL 2>&1"
    else
        let sysfolder = substitute(a:folder, "[\\/]", "/", "g")
        execute "!mkdir " . sysfolder . " 2&> /dev/null"
    endif
endfunction

function! s:ShowOverlength(at)
    execute "match overlength /\\%" . (a:at + 1) . "v.\\+/"
endfunction

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

function! s:Make(mkprg, errfmt, fil)
    echom "Make(" . a:mkprg . ", " . a:errfmt . ", " . a:fil . ")"
    try
        let savedMakePrg=&makeprg
        let &makeprg=a:mkprg
        let savedErrorFormat=&errorformat
        let &errorformat=a:errfmt
        if strlen(a:fil) > 0
            execute 'make! ' . a:fil
        else
            :make!
        endif
    finally
        let &makeprg = savedMakePrg
        let &errorformat = savedErrorFormat
    endtry
endfunction

function! s:CommandToQuickfix(command, errormessage)
    echom a:command
    " run the command
    let l:output = system(a:command)
    " check for empty output
    if l:output == ""
        echohl WarningMsg | echomsg a:errormessage | echohl None
    else
        " create temp file
        let l:tmpfile = tempname()
        " redirect output to that file
        exe "redir! > " . l:tmpfile
        " write the output
        silent echon l:output
        " redirect output back to it's default location
        redir END
        " read the temp file for errors
        if exists(":cgetfile")
            execute "silent! cgetfile " . l:tmpfile
        else
            execute "silent! cfile " . l:tmpfile
        endif
        " open the quickfix window
        botright copen
        " delete the temp file
        call delete(l:tmpfile)
    endif
endfunction

function! s:GrepInPath(word, extensions, wholeWord)
    let l:fullPath = &path
    let l:pathList = split(l:fullPath, ",")
    let l:dict = {}
    for folder in l:pathList
        let l:dict[folder] = ''
    endfor
    let l:pathList = keys(l:dict)
    let l:searchPath = ""
    if g:platform == "windows"
        for folder in l:pathList
            for extension in a:extensions
                if folder == "."
                    let l:fixedFolder = getcwd()
                else
                    let l:fixedFolder = substitute(folder, "\*\*", "", "g")
                endif
                if l:fixedFolder != ""
                    let l:searchPath = l:searchPath . " " . l:fixedFolder . "\\*." . extension
                endif
            endfor
        endfor
        let l:command = 'findstr /spn "' . a:word . '" ' . l:searchPath
        let l:errormessage = "Error: pattern " . a:word . " not found"
        call s:CommandToQuickfix(l:command, l:errormessage)
    else
        for folder in l:pathList
            if folder == "."
                let l:fixedFolder = getcwd() . "/"
            else
                let l:fixedFolder = folder . "/"
            endif
            for extension in a:extensions
                let l:searchPath = l:searchPath . " " . l:fixedFolder . "*." . extension
            endfor
        endfor
        if a:wholeWord == 1
            let l:pattern = "\\<" . a:word . "\\>"
        else
            let l:pattern = a:word
        endif
        try
            execute "noautocmd vimgrep /" . l:pattern . "/j " . l:searchPath
            execute "cw"
        catch
        endtry
    endif
endfunction

function! s:FindInFiles(extensions)
    call inputsave()
    let l:word = input('Search in files: ')
    call inputrestore()
    if strlen(l:word) > 0
        call s:GrepInPath(l:word, a:extensions, 0)
    endif
endfunction

function! s:FindInFilesWholeWord(extensions)
    call inputsave()
    let l:word = input('Search in files (whole word): ')
    call inputrestore()
    if strlen(l:word) > 0
        call s:GrepInPath(l:word, a:extensions, 1)
    endif
endfunction

function! s:HashWord()
    call s:SaveCursorPosition()
    normal! viwy
    normal! A //
    execute ":read !hasher -u " . getreg('"')
    normal! kJ
    call s:RestoreCursorPosition()
endfunction
" nnoremap <silent> <leader>h <esc>:call <sid>HashWord()<cr>

function! s:OpenUrl(url)
    execute "!" . g:openurlcommand . " " . a:url
endfunction
" }}}1

" maps {{{1
"" input \(\) on command line
cmap <leader>( \(\)<left><left>

"" do not remove indentation from empty lines
" inoremap <cr> <cr>x<bs>
" nnoremap o ox<bs>
" nnoremap O Ox<bs>

"" center the current line with '=' chars
nnoremap <leader>c :call <SID>CenterTitle("=")<CR>
vnoremap <leader>c :call <SID>CenterTitle("=")<CR>

"" search using <space>
nnoremap <space> /

"" copy and paste multiple lines
vnoremap <silent> y y']
vnoremap <silent> p p']
nnoremap <silent> p p']

"" move visually
nnoremap j gj
nnoremap k gk

"" remove Ex mode map
nnoremap Q <nop>

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

"" mantain search result in the middle of the screen
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

"" map arrow keys to nothing in normal and visual mode
nnoremap <silent> <up> <nop>
nnoremap <silent> <down> <nop>
nnoremap <silent> <left> <nop>
nnoremap <silent> <right> <nop>
vnoremap <silent> <up> <nop>
vnoremap <silent> <down> <nop>
vnoremap <silent> <left> <nop>
vnoremap <silent> <right> <nop>

"" split lines (inverse of J)
nnoremap <silent> <leader>p ylpr<Enter>

"" remove highlight with <esc>
nnoremap <silent> <esc> :nohlsearch<cr>

"" jump to tag (changed for compatibility with strange keyboards)
" nnoremap <silent> <c-t> <c-]>

"" map argwrap#toggle (argwrap) plugin
if exists("argwrap#toggle")
    nnoremap <silent> <leader>w :call argwrap#toggle()<CR>
endif

"" fix indentation in the whole file
function! s:FixIndentation()
    call s:SaveCursorPosition()
    normal! gg=G
    call s:RestoreCursorPosition()
endfunction
nnoremap <silent> <leader>i <esc>:call <sid>FixIndentation()<cr>

"" remove spaces at the end of the line
function! s:RemoveTrailingWhitespaces()
    call s:SaveCursorPosition()
    %s/\s\+$//e
    call s:RestoreCursorPosition()
endfunction
nnoremap <silent> <leader>s <esc>:call <sid>RemoveTrailingWhitespaces()<cr>

"" tagbar
if exists(":TagbarToggle")
    nnoremap <silent> <leader>t <esc>:TagbarToggle<cr>
endif

"" navigate through tabs
nnoremap <c-l> :tabnext<cr>
nnoremap <c-h> :tabprev<cr>

"" insert line numbers
nnoremap <silent> <leader>n <esc>:%s/^/\=printf('%d ', line('.'))<cr>
"
"" maps for diff
if &diff
    if has("mac") || has("macunix") || has("gui_mac") || has("gui_macvim")
        nnoremap <silent> <leader>j <esc>:execute "normal! ]c"<cr>
        nnoremap <silent> <leader>k <esc>:execute "normal! [c"<cr>
        nnoremap <silent> <leader>h <esc>:diffget 2<cr>
        nnoremap <silent> <leader>l <esc>:diffput 2<cr>
    else
        nnoremap <silent> <m-j> <esc>:execute "normal! ]c"<cr>
        nnoremap <silent> <m-k> <esc>:execute "normal! [c"<cr>
        nnoremap <silent> <m-h> <esc>:diffget 2<cr>
        nnoremap <silent> <m-l> <esc>:diffput 2<cr>
    endif
endif
" }}}1

" abbreviations {{{1
abbreviate c_Str c_str
" }}}1

" all autocmd stuff {{{1
if has("autocmd")
    """ go {{{2
    " autocmd FileType go nnoremap <leader>b :w<cr>:call <sid>Make("go\ build", "%f:%l:%c:\ %m,%f:%l:\ %m", expand("%"))<cr>:cw<cr>:redraw!<cr>
    function! s:RunGo()
        let l:executable = fnamemodify(getcwd(), ":p:h:t")
        let l:tmux_pane = ".0"
        if exists("g:unkiwii_project")
            if exists("g:unkiwii_project.go_executable")
                let l:executable = g:unkiwii_project.go_executable
            endif
            if exists("g:unkiwii_project.tmux_window")
                silent exec "!tmux selectw -t '" . g:unkiwii_project.tmux_window . "'"
            endif
            if exists("g:unkiwii_project.tmux_pane")
                let l:tmux_pane = g:unkiwii_project.tmux_pane
            endif
        endif
        silent exec "!tmux send -t '" . l:tmux_pane . "' C-c 'clear' Enter 'go build && ./" . l:executable . "' Enter"
        redraw!
    endfunction

    autocmd FileType go nnoremap <leader>b :w<cr>:GoBuild<cr>
    autocmd FileType go nnoremap <leader>r :w<cr>:call <sid>RunGo()<cr>
    autocmd FileType go silent call s:SetIndentOptions({"spaces": 4, "expandtab": 0})
    autocmd FileType go nnoremap <c-f> :call <sid>GrepInPath(expand("<cword>"), ["go"], 1)<cr>
    autocmd FileType go nnoremap <leader>f :call <sid>FindInFiles(["go"])<cr>
    autocmd FileType go nnoremap <leader>F :call <sid>FindInFilesWholeWord(["go"])<cr>
    autocmd FileType go execute 'set path=.,~/projects/go/src'
    autocmd FileType go execute 'lcd ' . expand("%:h")
    """ }}}2

    """ dosbatch {{{2
    augroup batchgroup
        autocmd!
        autocmd BufNewFile *.bat normal! gg
        autocmd BufNewFile *.bat normal! O@echo off
        autocmd BufNewFile *.bat normal! osetlocal EnableDelayedExpansion
        autocmd BufNewFile *.bat normal! o
        autocmd BufNewFile *.bat normal! o
        autocmd BufNewFile *.bat normal! o
        autocmd BufNewFile *.bat normal! o@echo on
        autocmd BufNewFile *.bat normal! jdd
        autocmd BufNewFile *.bat normal! 4G
    augroup END
    """ }}}2

    """ javascript {{{2
    autocmd FileType javascript nnoremap <c-f> :call <sid>GrepInPath(expand("<cword>"), ["js", "html"], 1)<cr>
    autocmd FileType javascript nnoremap <leader>f :call <sid>FindInFiles(["js", "html"])<cr>
    autocmd FileType javascript nnoremap <leader>F :call <sid>FindInFilesWholeWord(["js", "html"])<cr>
    autocmd FileType javascript silent call s:SetIndentOptions({"spaces": 4, "expandtab": 1, "smarttab": 1})
    """}}}2

    """ C {{{2
    autocmd FileType c nnoremap <leader>f :call <sid>FindInFiles(["c", "h"])<cr>
    autocmd FileType c nnoremap <leader>F :call <sid>FindInFilesWholeWord(["c", "h"])<cr>
    autocmd FileType c silent call s:SetIndentOptions({"spaces": 2, "expandtab": 1, "smarttab": 1})
    """}}}2

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
                try
                    find %:t:r.c
                catch
                    let includeFile = expand("%:t")
                    new %:r.cpp
                    execute "normal! i#include \"" . includeFile . "\""
                endtry
            endtry
        endif
    endfunction

    function! s:CppCheck()
        call s:Make("cppcheck\ --enable=all\ -j\ 4\ .", "\[%f:%l\]:\ (%t%s)\ %m", "")
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
    autocmd FileType cpp nnoremap <c-f> :call <sid>GrepInPath(expand("<cword>"), ["cpp", "h"], 1)<cr>
    autocmd FileType cpp nnoremap <leader>f :call <sid>FindInFiles(["cpp", "h"])<cr>
    autocmd FileType cpp nnoremap <leader>F :call <sid>FindInFilesWholeWord(["cpp", "h"])<cr>

    autocmd FileType cpp set cinoptions=g0,N-s,i0,W4,m1,(s
    autocmd FileType cpp set foldmarker={,}

    autocmd FileType cpp noremap <silent> <leader>s <esc>:call <sid>SwitchSourceHeader()<cr>
    autocmd FileType cpp noremap <silent> <leader>S <esc>:vsplit<cr>:call <sid>SwitchSourceHeader()<cr>
    "     autocmd FileType cpp noremap <silent> <leader>ca <esc>:call <sid>CppApi()<cr><cr>
    autocmd FileType cpp noremap <c-f9> :call <sid>CppCheck()<cr>

    autocmd BufWinEnter *.h,*.hpp,*.h++ nnoremap <leader>+ :call <sid>WriteSafeGuard()<cr>
    """ }}}2

    """ Java {{{2
    function! s:CompileAndroid()
        lcd proj.android
        call s:Make("ant", "%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#", "")
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
        call s:SetIndentOptions({"spaces": 4, "expandtab": 1})
        set foldmethod=indent
        set foldlevel=99

        " show every character past column 80 as an error
        set textwidth=120
        try
            call s:ShowOverlength(120)
        catch
            echom "ShowOverLength error: " . v:exception
        endtry
    endfunction

    function! s:PythonRun()
        execute "!python ./" . expand("%")
    endfunction

    autocmd FileType python call <sid>SetPythonEnv()
    autocmd FileType python nnoremap <silent> <leader>r :call <sid>PythonRun()<cr>
    autocmd FileType python nnoremap <c-f> :call <sid>GrepInPath(expand("<cword>"), ["py", "pyw"], 1)<cr>
    autocmd FileType python nnoremap <leader>f :call <sid>FindInFiles(["py", "pyw"])<cr>
    autocmd FileType python nnoremap <leader>F :call <sid>FindInFilesWholeWord(["py", "pyw"])<cr>
    """ }}}2

    """ Markdown {{{2
    function! s:ViewMarkdown()
        silent execute "!pandoc -f markdown_github -t html5 '" . expand("%") . "' > md.html"
        call s:OpenUrl("md.html")
        silent execute "!rm md.html"
        redraw!
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

    """ ANTLR {{{2
    autocmd BufNewFile,BufRead *.g4 setf antlr
    autocmd BufNewFile,BufRead *.g4 set makeprg="antlr4"
    """ }}}2

    """ NEWLANG {{{2
    function! s:SetNewLangEnv()
        set list
        call s:SetIndentOptions({"spaces": 2, "expandtab": 1})
        set foldmethod=indent
        set foldlevel=99

        " show every character past column 80 as an error
        set textwidth=120
        "         call s:ShowOverlength(120)
    endfunction

    autocmd FileType newlang call <sid>SetNewLangEnv()
    """ }}}2

    """ HTML {{{2
    autocmd FileType html nnoremap <leader>r :call <sid>OpenUrl(expand("%:p"))<cr>
    autocmd FileType html silent call s:SetIndentOptions({"spaces": 4, "expandtab": 1, "smarttab": 1})
    """}}}2

    """ Ruby {{{2
    autocmd FileType ruby nnoremap <leader>r <esc>:!./%<cr>
    """ }}}2

    """ ActionScript 3 {{{2
    autocmd BufRead *.as setf javascript
    autocmd BufRead *.as nnoremap <c-f> :call <sid>GrepInPath(expand("<cword>"), ["as"], 1)<cr>
    autocmd BufRead *.as nnoremap <leader>f :call <sid>FindInFiles(["as"])<cr>
    autocmd BufRead *.as nnoremap <leader>F :call <sid>FindInFilesWholeWord(["as"])<cr>
    """ }}}2

    "" text {{{2
    autocmd FileType text set nolist
    "" }}}2

    "" vimrc {{{2
    function! s:SetVimrcEnv()
        setf vim
        call s:SetIndentOptions({"spaces": 4, "expandtab": 1, "smarttab": 1})
    endfunction

    autocmd BufRead .vimrc,vimrc call <sid>SetVimrcEnv()
    "" }}}2

    "" show cursor line in the current window only {{{2
    augroup CursorLine
        au!
        au VimEnter * setlocal cursorline
        au WinEnter * setlocal cursorline
        au BufWinEnter * setlocal cursorline
        au WinLeave * setlocal nocursorline
    augroup END
    "" }}}2

    "" save and load view of buffer {{{2
    " function s:LoadView(file)
        " try
            " if filereadable(a:file)
                " loadview
            " endif
        " catch
            " mkview
        " endtry
    " endfunction

    " autocmd BufWritePost * mkview
    " autocmd BufRead * silent call <sid>LoadView(expand("%"))
    "" }}}2

    "" go to the last visited line in a file when reopen it {{{2
    autocmd BufReadPost * silent if filereadable(expand("%")) && line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    "" }}}2
endif   "has(autocmd)
" }}}1

" unkiwii_project related stuff {{{1
if exists("g:unkiwii_project")
    if has_key(g:unkiwii_project, 'makepath')
        function! s:Compile()
            exec "lcd " . g:unkiwii_project.makepath
            if exists("g:unkiwii_project.cmake")
                execute "!" . g:unkiwii_project.cmake
            endif
            let savedMakePrg=&makeprg
            if exists("g:unkiwii_project.makeprg")
                let &makeprg=g:unkiwii_project.makeprg
            endif
            let savedErrorFormat=&errorformat
            if exists("g:unkiwii_project.makeerrorformat")
                let &errorformat=g:unkiwii_project.makeerrorformat
            endif
            make
            let &makeprg=savedMakePrg
            let &errorformat=savedErrorFormat
            cc
            lcd -
        endfunction

        function! s:CleanCompile()
            exec "lcd " . g:unkiwii_project.makepath
            if exists("g:unkiwii_project.cmake")
                execute "!" . g:unkiwii_project.cmake
            endif
            let savedMakePrg=&makeprg
            if exists("g:unkiwii_project.makeprg")
                let &makeprg=g:unkiwii_project.makeprg
            endif
            make clean
            make
            let &makeprg=savedMakePrg
            cc
            lcd -
        endfunction

        function! s:CleanDepsCompile()
            exec "lcd " . g:unkiwii_project.makepath
            if exists("g:unkiwii_project.cmake")
                execute "!" . g:unkiwii_project.cmake
            endif
            let savedMakePrg=&makeprg
            if exists("g:unkiwii_project.makeprg")
                let &makeprg=g:unkiwii_project.makeprg
            endif
            make cleandeps
            make
            let &makeprg=savedMakePrg
            cc
            lcd -
        endfunction

        noremap <leader>b <esc>:call <sid>Compile()<cr><cr>:cl<cr>
        noremap <leader>B <esc>:call <sid>CleanCompile()<cr>:cl<cr>
        noremap <leader>d <esc>:call <sid>CleanDepsCompile()<cr>:cl<cr>
    endif

    if has_key(g:unkiwii_project, 'executable')
        function! s:Run()
            exec "!" . g:unkiwii_project.executable
        endfunction

        function! s:RunGrepCWORD()
            exec "!" . g:unkiwii_project.executable . " | grep '<cword>'"
        endfunction

        noremap <leader>r <esc>:call <sid>Run()<cr>
        noremap <leader>R <esc>:call <sid>RunGrepCWORD()<cr>
    endif

    if has_key(g:unkiwii_project, 'ctagstype') && has_key(s:ctagsArgs, g:unkiwii_project.ctagstype)
        let s:ctagsArgs = {
                    \ "cpp" : '--recurse --extra=+fq --fields=+ianmzS --c++-kinds=+p',
                    \ "cs" : '--recurse --extra=+fq --fields=+ianmzS --c\#-kinds=cimnp',
                    \ "objc" : '--langmap=ObjectiveC:.m.h.mm --recurse --extra=+fq --fields=+ianmzS --c++-kinds=+p'
                    \ }

        " get library path
        function! s:GetTagsPath(libpath)
            return substitute(expand(a:libpath), "[\\/:]", "_", "g")
        endfunction

        let s:tagsdir = g:vimfilespath . "/tags/"

        " function to build all tags needed for the project (need exuberant-ctags installed) (works with C/C++)
        function! s:BuildTags()
            call s:MakeFolder(s:tagsdir)
            for library_path in g:unkiwii_project.libraries
                " create tags for libraries
                let tagfile = s:tagsdir . s:GetTagsPath(library_path)
                call s:nprint()
                call s:nprint(">> Building tags for", library_path)
                call s:nprint("     saving to ", l:tagfile)
                execute "!ctags " . s:ctagsArgs[g:unkiwii_project.ctagstype] . " -f " . l:tagfile . " " . library_path
            endfor
            " create tags for current project
            call s:nprint()
            call s:nprint(">> Building tags for project", g:unkiwii_project.name)
            call s:nprint("     saving to tags")
            execute "!ctags " . s:ctagsArgs[g:unkiwii_project.ctagstype] . " *"
            if has_key(g:unkiwii_project, 'iosproject') && isdirectory(expand(g:unkiwii_project.iosproject))
                let ios_tagfile = s:tagsdir . s:GetTagsPath(g:unkiwii_project.iosproject)
                call s:nprint()
                call s:nprint(">> Building tags for project (ios)", g:unkiwii_project.name)
                call s:nprint("     saving to " . l:ios_tagfile)
                execute "!ctags " . s:ctagsArgs["objc"] . " -f " . l:ios_tagfile . " " . g:unkiwii_project.iosproject
            endif
        endfunction

        " set tags variable
        for library_path in g:unkiwii_project.libraries
            let tagfile = s:tagsdir . s:GetTagsPath(library_path)
            execute "set tags+=" . tagfile
        endfor
        if has_key(g:unkiwii_project, 'iosproject') && isdirectory(expand(g:unkiwii_project.iosproject))
            let ios_tagfile = s:tagsdir . s:GetTagsPath(g:unkiwii_project.iosproject)
            execute "set tags+=" . ios_tagfile
        endif

        nnoremap <leader>T <esc>:call <sid>BuildTags()<cr>
    endif
endif
"" end "project" related stuff }}}1

" comment and uncomment lines {{{1
let s:commentPrefixes = {
            \ "c" : '// ',
            \ "cpp" : '// ',
            \ "cs" : '// ',
            \ "css" : '/* ',
            \ "dosbatch" : ':: ',
            \ "dosini" : '# ',
            \ "elixir" : '# ',
            \ "go" : '// ',
            \ "html" : '<!-- ',
            \ "java" : '// ',
            \ "javascript" : '// ',
            \ "make" : '# ',
            \ "markdown" : '<!-- ',
            \ "newlang" : '# ',
            \ "objc" : '// ',
            \ "objcpp" : '// ',
            \ "python" : '# ',
            \ "sh" : '# ',
            \ "vim" : '" ',
            \ "yaml" : '# '
            \ }

let s:commentSuffixes = {
            \ "css" : ' */',
            \ "html" : ' -->',
            \ "markdown" : ' -->'
            \ }

let s:escapeChars = '*/"[]'

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

        let l:line = getline('.')
        let l:prefixRegex = '^\(\s*\)\(' . escape(l:prefix, s:escapeChars) . '\)'
        let l:suffixRegex = '\(' . escape(l:suffix, s:escapeChars) . '\)\(\s*\)$'
        if match(l:line, l:prefixRegex) > -1
            silent execute 's/' . l:prefixRegex . '/\1/'
            if len(l:suffix) && match(l:line, l:suffixRegex) > -1
                silent execute 's/' . l:suffixRegex . '/\2/'
            endif
        else
            silent execute 'normal! I' . l:prefix
            if len(l:suffix)
                silent execute 'normal! A' . l:suffix
            endif
        endif
    catch
        echom "[ToggleLineComment] " . v:exception
    endtry
    let @/ = l:lastSearch
endfunction

vnoremap <silent> <leader>. <esc>:'<,'>call <sid>ToggleLineComment()<cr>gv
nnoremap <silent> <leader>. <esc>:call <sid>ToggleLineComment()<cr>
" }}}1

" folding {{{1
nnoremap <silent> <leader>f{ va{:fold<cr>
nnoremap <silent> <leader>f( va(:fold<cr>
nnoremap <silent> <leader>f[ va[:fold<cr>
nnoremap <silent> <leader>ft vat:fold<cr>
" }}}1

" show highlight group of word under cursor {{{1
nnoremap sh :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>
" }}}1

" plugins {{{1

runtime macros/matchit.vim

" hide files from netrw
let g:netrw_list_hide='.*\.swp$,.*\.meta$,.*\.pyc$'
" let g:netrw_preview=1
" let g:netrw_liststyle=3
" let g:netrw_winsize=30
" }}}1

" commands {{{1
"" bye bye :Q errors!
command! Q q
command! Qall qall

command! W w
command! Wall wall

command! Wtfpl call s:InsertWTFPL()
function! s:InsertWTFPL()
    execute "normal ggO"
    execute "normal ggO"
    execute "r " . g:vimfilespath . "/snippets/wtfpl"
    execute "normal ggdd"
endfunction

"" hello :Vtag (open a tag in vertical split)
command! -nargs=1 -complete=tag Vtag execute "vsp | tag <args>"

"" hello :Rsp and :Rtab (read a file in a new split or tab buffer)
command! -nargs=* -complete=shellcmd Rsp execute "new | r! <args>"
command! -nargs=* -complete=shellcmd Rtab execute "tabnew | r! <args>"
" }}}1

" set ff to unix {{{1
try
    set ff=unix
catch
    echom "Could not change the file format to unix"
endtry
" }}}1

" colorscheme (at the end for plugins to work) {{{1
if has("unix")
    colorscheme mlessnau
else
    colorscheme unkiwii
endif
" }}}1

" source project.vimrc.after (if there is one) {{{1
try
    exec "source " . getcwd() . "/.project.vimrc.after"
    nnoremap <leader>lva <esc>:tabedit .project.vimrc.after<cr>
catch
endtry
" }}}1
