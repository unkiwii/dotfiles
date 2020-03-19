set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "mlessnau"

let s:blue    = "117"
let s:blue2   = "26"
let s:green1  = "64"
let s:green2  = "120"
let s:black   = "0"
let s:grey2   = "232"
let s:grey3   = "235"
let s:grey4   = "238"
let s:grey5   = "241"
let s:grey6   = "244"
let s:grey7   = "247"
let s:orange1 = "208"
let s:orange2 = "220"
let s:pink1   = "201"
let s:pink2   = "207"
let s:purple  = "147"
let s:red1    = "88"
let s:red2    = "9"
let s:red3    = "173"
let s:white   = "15"
let s:yellow  = "11"

function! s:HiColor(grp, fg, bg, style) "{{{1
  let hiCommand = "hi " . a:grp
  if a:fg != ""
    let hiCommand = hiCommand . " ctermfg=" . a:fg
  endif
  if a:bg != ""
    let hiCommand = hiCommand . " ctermbg=" . a:bg
  endif
  if a:style != ""
    let hiCommand = hiCommand . " cterm=" . a:style
  endif
  exec hiCommand
endfunction
"}}}

" ### Global ################################ fg ####### bg ####### style #####
call s:HiColor("Normal",                     s:white,   s:black,   "")
call s:HiColor("NonText",                    s:grey4,   "",        "")
call s:HiColor("Error",                      s:white,   s:red2,    "bold")

" ### Status Line & Wildmenu ################ fg ####### bg ####### style #####
call s:HiColor("StatusLine",                 s:black,   s:white,   "bold")
call s:HiColor("StatusLineNC",               s:black,   s:grey5,   "none")
call s:HiColor("ModeMsg",                    s:black,   s:white,   "bold")
call s:HiColor("MoreMsg",                    s:black,   s:white,   "bold")
call s:HiColor("Question",                   s:black,   s:white,   "bold")
call s:HiColor("WildMenu",                   s:white,   s:pink1,   "bold")
call s:HiColor("Folded",                     s:blue,    s:black,   "bold")
call s:HiColor("FoldColumn",                 s:red2,    s:black,   "")

" ### Search & Selection #################### fg ####### bg ####### style #####
call s:HiColor("IncSearch",                  s:orange1, s:black,   "")
call s:HiColor("Search",                     s:black,   s:orange2, "")
call s:HiColor("Visual",                     s:white,   s:blue2,   "")

" ### Cursor ################################ fg ####### bg ####### style #####
call s:HiColor("lCursor",                    s:white,   s:grey2,   "")
call s:HiColor("Cursor",                     s:white,   "",        "")
call s:HiColor("CursorColumn",               "",        s:grey3,   "")
call s:HiColor("CursorIM",                   s:white,   "",        "")
call s:HiColor("CursorLine",                 "",        s:grey3,   "none")

" ### Line/Column Helpers & Panes ########### fg ####### bg ####### style #####
call s:HiColor("ColorColumn",                "",        s:black,   "")
call s:HiColor("CursorLineNr",               s:white,   s:black,   "")
call s:HiColor("LineNr",                     s:grey5,   s:black,   "")
call s:HiColor("VertSplit",                  s:black,   s:black,   "")

" ### Directory Listing ##################### fg ####### bg ####### style #####
call s:HiColor("Directory",                  s:blue,    "",        "")

" ### Specials ############################## fg ####### bg ####### style #####
call s:HiColor("Todo",                       s:white,   s:pink1,   "")
call s:HiColor("Title",                      s:white,   "",        "")
call s:HiColor("Special",                    s:red3,    "",        "bold")
call s:HiColor("Operator",                   s:white,   "",        "")
call s:HiColor("Delimiter",                  s:white,   "",        "")
call s:HiColor("SpecialKey",                 s:grey4,   "",        "")

" ### Syntax Elements ####################### fg ####### bg ####### style #####
call s:HiColor("String",                     s:green2,  "",       "")
call s:HiColor("Constant",                   s:blue,    "",       "")
call s:HiColor("Number",                     s:blue,    "",       "")
call s:HiColor("Statement",                  s:orange1, "",       "bold")
call s:HiColor("Function",                   s:orange2, "",       "")
call s:HiColor("PreProc",                    s:pink2,   "",       "bold")
call s:HiColor("Comment",                    s:grey6,   "",       "none")
call s:HiColor("SpecialComment",             s:grey6,   "",       "")
call s:HiColor("Type",                       s:orange1, "",       "bold")
call s:HiColor("Error",                      s:white,   s:red2,   "")
call s:HiColor("Identifier",                 s:white,   "",       "bold")
call s:HiColor("Keyword",                    s:orange1, "",       "")
call s:HiColor("Overlength",                 s:white,   s:red2,   "bold")
"Label

" ### Messages ############################## fg ####### bg ####### style #####
call s:HiColor("ErrorMsg",                   s:white,   s:red2,   "bold")
call s:HiColor("WarningMsg",                 s:red2,    "",       "")

" ### Doxygen Related (C, C++, Java) ######## fg ####### bg ####### style #####
call s:HiColor("doxygenSpecial",             s:grey7,   s:black,  "bold")
hi link doxygenBrief                Comment
hi link doxygenParam                doxygenSpecial
hi link doxygenParamName            Comment
hi link doxygenSpecialMultilineDesc Comment

" ### Erlang Related ##########################################
hi link erlangLocalFuncRef          Function
hi link erlangLocalFuncCall         Statement
hi link erlangGlobalFuncCall        PreProc

" ### Python Related ##########################################################
"pythonCoding
"pythonRun
"pythonBuiltinObj
"pythonBuiltinFunc
"pythonException
"pythonExClass
"pythonSpaceError
"pythonDocTest
"pythonDocTest2
"pythonFunction
"pythonClass

" ### HTML Related ########################## fg ####### bg ####### style #####
call s:HiColor("htmlArg",                    s:orange2, "",       "bold")
call s:HiColor("htmlTag",                    s:orange1, "",       "")
call s:HiColor("htmlTagName",                s:orange1, "",       "bold")
call s:HiColor("htmlSpecialTag",             s:orange1, "",       "")
call s:HiColor("htmlSpecialTagName",         s:orange1, "",       "bold")
call s:HiColor("htmlEndTag",                 s:orange1, "",       "")
call s:HiColor("htmlBold",                   "",        "",       "bold")
call s:HiColor("htmlBoldItalic",             "",        "",       "bold,italic")
call s:HiColor("htmlBoldUnderline",          "",        "",       "underline")
call s:HiColor("htmlBoldUnderlineItalic",    "",        "",       "bold,underline,italic")
call s:HiColor("htmlItalic",                 "",        "",       "italic")
call s:HiColor("htmlLink",                   s:white,   "",       "")
call s:HiColor("htmlUnderline",              "",        "",       "underline")
call s:HiColor("htmlUnderlineItalic",        "",        "",       "underline,italic")

" ### XML Related ############################ fg ####### bg ####### style #####
call s:HiColor("xmlTagName",                  s:orange2, "",        "")
call s:HiColor("xmlEndTag",                   s:orange2, "",        "")

" ### Ruby Related ############################################################
call s:HiColor("rubyAccess",                 s:red2,    "",       "bold")
call s:HiColor("rubyBeginEnd",               s:orange1, "",       "bold")
call s:HiColor("rubyBlockParameter",         s:blue,    "",       "")
call s:HiColor("rubyClass",                  s:orange1, "",       "bold")
call s:HiColor("rubyConditional",            s:orange1, "",       "bold")
call s:HiColor("rubyConstant",               s:white,   "",       "bold")
call s:HiColor("rubyControl",                s:orange1, "",       "bold")
call s:HiColor("rubyDefine",                 s:orange1, "",       "bold")
call s:HiColor("rubyGlobalVariable",         s:yellow,  "",       "bold")
call s:HiColor("rubyInstanceVariable",       s:yellow,  "",       "")
call s:HiColor("rubyInterpolationDelimiter", s:pink2,   "",       "")
call s:HiColor("rubyKeyword",                s:orange1, "",       "bold")
call s:HiColor("rubyString",                 s:green2,  "",       "")
call s:HiColor("rubyStringDelimiter",        s:green2,  "",       "")
call s:HiColor("rubySymbol",                 s:blue,    "",       "")
call s:HiColor("rubyRegexp",                 s:pink2,   "",       "")
call s:HiColor("rubyRegexpDelimiter",        s:pink2,   "",       "")
call s:HiColor("rubyRegexpSpecial",          s:pink2,   "",       "")
call s:HiColor("rubyInclude",                s:orange1, "",       "bold")

" ### Vim Related #############################################################
call s:HiColor("vimCommand",                 s:orange1, "",       "bold")

" ### C/C++ Related ###########################################################
call s:HiColor("cConditional",               s:orange1, "",       "bold")
call s:HiColor("cppAccess",                  s:red2,    "",       "bold")

" ### PHP related #############################################################
call s:HiColor("phpClasses",                 s:white,   "",       "bold")
call s:HiColor("phpDefine",                  s:orange1, "",       "bold")
call s:HiColor("phpFunctions",               s:orange2, "",       "")
call s:HiColor("phpVarSelector",             s:purple,  "",       "")
call s:HiColor("phpIdentifier",              s:purple,  "",       "")
call s:HiColor("phpSpecialFunction",         s:orange2, "",       "")
call s:HiColor("phpAssignByRef",             s:white,   "",       "")
call s:HiColor("phpMemberSelector",          s:white,   "",       "")
call s:HiColor("phpComparison",              s:white,   "",       "")
call s:HiColor("phpSCKeyword",               s:red2,    "",       "bold")
call s:HiColor("phpDocTags",                 s:grey7,   "",       "bold")
call s:HiColor("phpDocParam",                s:grey7,   "",       "bold")

" ### JavaScript Related ######################################################
call s:HiColor("javaScript",                 s:white,   "",       "")
call s:HiColor("javaScriptFunction",         s:orange1, "",       "bold")
call s:HiColor("javaScriptLabel",            s:blue,    "",       "none")
call s:HiColor("javaScriptGlobalObjects",    s:white,   "",       "bold")
call s:HiColor("javaScriptDocTags",          s:grey7,   "",       "bold")
call s:HiColor("javaScriptOperator",         s:orange1, "",       "bold")
call s:HiColor("javaScriptRegexpString",     s:pink2,   "",       "")

" ### Pmenu ###################################################################
call s:HiColor("Pmenu",                      s:pink1,   s:black,  "bold")
call s:HiColor("PmenuSel",                   s:white,   s:pink1,  "bold")

" ### NERDTree ################################################################
call s:HiColor("NERDTreeCWD",                s:orange2, "",       "none")
call s:HiColor("NERDTreeRO",                 s:red2,    "",       "")
call s:HiColor("NERDTreeFlag",               s:white,   "",       "")

" ### CtrlP ####################################################################
call s:HiColor("CtrlPMatch",                 s:grey2,  s:orange2, "bold")

" ### Diff ####################################################################
call s:HiColor("DiffAdd",                    s:green1,  s:green2, "")
call s:HiColor("DiffDelete",                 s:red1,    s:red3,   "")
call s:HiColor("DiffChange",                 "",        s:grey2,  "")
