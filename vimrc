if exists("g:loaded_unkiwiivimrc")
	finish
endif
let g:loaded_unkiwiivimrc = 1

try
	execute pathogen#infect()
catch
	echom "ERROR: Can't find pathogen"
endtry

let mapleader=","

"" vimrc edit
nnoremap <leader>v <esc>:tabedit $MYVIMRC<cr><esc>:colors unkiwii<cr>

"" Source project.vimrc (if there is one)
try
	exec "source " . getcwd() . "/.project.vimrc"
	nnoremap <leader>lv <ESC>:tabedit .project.vimrc<ESC>:colors unkiwii<CR>
catch
endtry

if !has('gui_running')
	set t_Co=256
else
	set encoding=utf-8
endif

syntax on
filetype indent on

" config
set ff=unix
set modeline
set ruler
set number
set autoindent
set smartindent
set showmatch
set guioptions=ai
set smarttab
set tabstop=4
set shiftwidth=4
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
set path+=.,**
set laststatus=2 "show status bar always
set splitbelow
set backspace=indent,eol,start

set rulerformat=%=%y\ %l,%c\ %P
if has('statusline')
	set statusline=%<%f\ \%=%{&ff}\ %y\ %l,%c\ %P
endif

if has("win16") || has("win32") || has("win64")
	set guifont=Consolas:h10
	let g:vimfilespath=system("echo %userprofile%/vimfiles")
	let g:openurlcommand="start"
	let g:echonewline='echo|set /p='
else
	set guifont=Inconsolata\ 10
	let g:vimfilespath='~/.vim'
	let g:openurlcommand="xdg-open"
	let g:echonewline='echo -e -n "\n'
endif

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

" maps
"" remove Ex mode map
nnoremap Q <nop>

"" bye bye :Q errors!
command! Q q
command! Qall qall

"" write. always.
cmap w!! w !sudo tee % >/dev/null

"" move lines up or down
vnoremap <silent> <c-j> :m '>+1<CR>gv=gv
vnoremap <silent> <c-k> :m '<-2<CR>gv=gv
nnoremap <silent> <c-j> :m .+1<CR>==
nnoremap <silent> <c-k> :m .-2<CR>==
inoremap <silent> <c-j> <ESC>:m .+1<CR>==gi
inoremap <silent> <c-k> <ESC>:m .-2<CR>==gi

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

"" split lines (inverse of J)
nnoremap <silent> <c-s> ylpr<Enter>

"" remove highlight with <ESC>
nnoremap <silent> <ESC> :nohlsearch<CR>

"" find a file, quickly
nnoremap <leader>f :find<space>

"" fix indentation
function! s:FixIndentation()
	call s:SaveCursorPosition()
	normal! gg=G
	call s:RestoreCursorPosition()
endfunction
noremap <silent> <leader>i <esc>:call <sid>FixIndentation()<cr>

"" tagbar
nnoremap <silent> <leader>t <ESC>:TagbarToggle<CR>

"" navigate through tabs
nnoremap <c-l> :tabnext<CR>
nnoremap <c-h> :tabprev<CR>

"" hasher
function! s:HashWord()
	call s:SaveCursorPosition()
	normal! viwy
	normal! A //
	execute ":read !hasher -u " . getreg('"')
	normal! kJ
	call s:RestoreCursorPosition()
endfunction
nnoremap <silent> <leader>h <ESC>:call <sid>HashWord()<CR>

function! s:OpenUrl(url)
	execute "!" . g:openurlcommand . " " . a:url
endfunction

"" autocmd maps
if has("autocmd")
	""" C++ {{{1
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
		try
			let save_makeprg=&makeprg
			set makeprg=cppcheck\ --enable=all\ -j\ 4\ .
			let save_errorformat=&errorformat
			set errorformat=\[%f:%l\]:\ (%t%s)\ %m
			:make
		finally
			let &makeprg=save_makeprg
			let &errorformat=save_errorformat
		endtry
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
	autocmd FileType cpp nnoremap <c-f> :execute "vimgrep /" . expand("<cword>") . "/j **/*.cpp **/*.h **/*.plist **/*.ini" <Bar> cw<CR>

	"""" set options for c indentation
	autocmd FileType cpp set cinoptions=g0,N-s,i0,W4,m1,(s

	autocmd FileType cpp noremap <silent> <leader>s <esc>:call <sid>SwitchSourceHeader()<cr>
	autocmd FileType cpp noremap <silent> <leader>S <esc>:split<cr>:call <sid>SwitchSourceHeader()<cr>
	autocmd FileType cpp noremap <silent> <leader>ca <esc>:call <sid>CppApi()<cr><cr>
	autocmd FileType cpp noremap <c-f9> :call <sid>CppCheck()<cr>

	autocmd BufWinEnter *.h,*.hpp,*.h++ nnoremap <leader>. :call <sid>WriteSafeGuard()<cr>
	""" }}}1

	autocmd BufRead .vimrc,vimrc setf vim

	autocmd BufRead *.as setf javascript
	autocmd BufRead *.as noremap <c-f> :execute "vimgrep /" . expand("<cword>") . "/j **/*.as" <Bar> cw<CR>

	augroup CursorLine
		au!
		au VimEnter * setlocal cursorline
		au WinEnter * setlocal cursorline
		au BufWinEnter * setlocal cursorline
		au WinLeave * setlocal nocursorline
	augroup END

	""" Unity3d {{{1
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

	autocmd FileType cs nnoremap <silent> <leader>ua :call <sid>UnityApi()<cr>
	autocmd FileType cs nnoremap <silent> <leader>uc :call <sid>CSharpMethodDoc()<cr>
	autocmd FileType cs nnoremap <silent> <leader>unb :call <sid>NewMonobehavior()<cr>
	""" }}}1

	""" go to the last visited line in a file when reopen it
	autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif	"has(autocmd)

"" "project" related stuff {{{1
if exists("g:unkiwii_project")
	function! s:Compile()
		:wall
		exec "lcd " . g:unkiwii_project.makepath
		make
		lcd -
	endfunction

	function! s:CleanCompile()
		:wall
		exec "lcd " . g:unkiwii_project.makepath
		make clean
		make
		cc
		lcd -
	endfunction

	function! s:CleanDepsCompile()
		:wall
		exec "lcd " . g:unkiwii_project.makepath
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
		exec "!" . g:unkiwii_project.path . "/android_build_install.sh"
	endfunction

	noremap <silent> ,b <esc>:call <sid>Compile()<cr><cr>:cl<cr>
	noremap <silent> ,B <esc>:call <sid>CleanCompile()<cr>:cl<cr>
	noremap <silent> ,d <esc>:call <sid>CleanDepsCompile()<cr>:cl<cr>
	noremap <silent> ,r <esc>:call <sid>Run()<cr>
	noremap <silent> ,R <esc>:call <sid>RunGrepCWORD()<cr>
	noremap <silent> ,a <esc>:call <sid>AndroidRun()<cr>

	let s:ctagsArgs = {
				\ "cpp" : '--recurse --extra=+fq --fields=+ianmzS --c++-kinds=+p',
				\ "cs" : '--recurse --extra=+fq --fields=+ianmzS --c\#-kinds=cimnp'
				\ }

	if has_key(s:ctagsArgs, g:unkiwii_project.ctagstype)
		" set tags variable
		for library_path in g:unkiwii_project.libraries
			let tagfile = g:vimfilespath . "/tags/" . substitute(library_path, "[\\/]", "_", "g")
			execute "set tags+=" . tagfile
		endfor

		" function to build all tags needed for the project (need exuberant-ctags installed) (works with C/C++)
		function! s:BuildTags()
			for library_path in g:unkiwii_project.libraries
				" create tags for libraries
				let tagfile = g:vimfilespath . "/tags/" . substitute(library_path, "[\\/]", "_", "g")
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

""" comment and uncomment lines
let s:commentSymbols = {
			\ "cpp" : '//',
			\ "cs" : '//',
			\ "css" : '//',
			\ "java" : '//',
			\ "javascript" : '//',
			\ "sh" : '#',
			\ "python" : '#',
			\ "dosbatch" : '@REM ',
			\ "vim" : '"'
			\ }
function! s:ToggleLineComment()
	try
		let l:commentSymbol = s:commentSymbols[&ft]
		let l:isCommented = strpart(getline("."), 0, strlen(l:commentSymbol))
		set nohlsearch
		if l:isCommented == l:commentSymbol
			execute ":silent s/" . escape(escape(l:commentSymbol, '/'), '"') . "//"
		else
			silent execute "normal! 0i" . l:commentSymbol
		endif
		set hlsearch
	catch
	endtry
endfunction
vnoremap <silent> <leader>+ <ESC>:'<,'>call <sid>ToggleLineComment()<CR>gv
nnoremap <silent> <leader>+ <ESC>:call <sid>ToggleLineComment()<CR>

" colorscheme (at the end for plugins to work)
colorscheme unkiwii
