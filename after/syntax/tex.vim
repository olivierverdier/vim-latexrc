" Note: this configuration file is meant to work with LaTeX Box:
" https://github.com/olivierverdier/vim-latex-box

" add underscore and backslash to keyword definition
set iskeyword=@,48-57,192-255,_,:

" ------------------------------------------------------------------------------
" Environments
" ------------------------------------------------------------------------------
" the following are better covered by snipMate
"imap <buffer> [[ 		\begin{
"imap <buffer> ]]		<Plug>LatexCloseLastEnv

nmap <buffer> <C-E>		<Plug>LatexChangeEnv
vmap <buffer> <C-W>		<Plug>LatexWrapSelection
vmap <buffer> <C-E>		<Plug>LatexEnvWrapSelection

" ------------------------------------------------------------------------------
" Typesetting
" ------------------------------------------------------------------------------
function! Typeset()
	w
	AsyncMake
	call setqflist([])
	copen
endfunction

command! Typeset call Typeset()
nmap <D-C-M> :Typeset<CR>

" replace the make command
set makeprg=scons\ -Q

nmap <D-B> :!bibtex %:r<CR>

" ------------------------------------------------------------------------------
" Navigation
" ------------------------------------------------------------------------------
" shortcut for LatexTOC
nmap <D-Bar> :LatexTOC<CR>


" section jumping
noremap <buffer> <silent> <leader>s :<c-u>call TexJump2Section( v:count1, '' )<CR>
" noremap <buffer> <silent> [[ :<c-u>call TexJump2Section( v:count1, 'b' )<CR>
function! TexJump2Section( cnt, dir )
  let i = 0
  let pat = '^\\\(part\|chapter\|\(sub\)*section\|paragraph\)\>\|\%$\|\%^'
  let flags = 'W' . a:dir
  while i < a:cnt && search( pat, flags ) > 0
    let i = i+1
  endwhile
  let @/ = pat
endfunction

" ------------------------------------------------------------------------------
" Syntax
" ------------------------------------------------------------------------------
" do not consider that caret and underscore outside math environment are errors
syn clear texOnlyMath

" ------------------------------------------------------------------------------
" Python Syntax Highlighting
" ------------------------------------------------------------------------------
let s:current_syntax=b:current_syntax
unlet b:current_syntax 
syn include @Python syntax/python.vim
let b:current_syntax=s:current_syntax

syn region texPython	matchgroup=texPythonDelimiter	start="\\begin{python}"		end="\\end{python}\|%stopzone\>"	contains=@NoSpell,@Python
syn match texRefZone		'\\\(page\|auto\|eq\)ref\>'	skipwhite	nextgroup=texRefLabel
syn region texCode		start="\\pyth{"		end="}\|%stopzone\>" contains=@NoSpell,@Python
syn region texCode		start="\\pyth!"		end="!\|%stopzone\>" contains=@NoSpell,@Python
syn region texCode		start="\\code{"		end="}\|%stopzone\>" contains=@NoSpell,@Python
let g:tex_comment_nospell=1
syn region texCiteOption	contained matchgroup=Delimiter start='\['	end=']'	contains=@NoSpell,@texRefGroup,@texMathZones,texRefZone	nextgroup=texCiteOption,texCite
