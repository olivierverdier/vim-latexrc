" Note: this configuration file is meant to work with LaTeX Box:
" https://github.com/olivierverdier/vim-latex-box

" add underscore and backslash to keyword definition
set iskeyword=@,48-57,192-255,_,\

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
	!pydflatex -psw %
endfunction

command! Typeset call Typeset()
nmap <D-C-M> :Typeset<CR>

" replace the make command
set makeprg=pydflatex\ -ps\ %

nmap <D-B> :!bibtex %:r<CR>

" ------------------------------------------------------------------------------
" Navigation
" ------------------------------------------------------------------------------
" shortcut for LatexTOC
nmap <D-Bar> :LatexTOC<CR>


" section jumping
"noremap <buffer> <silent> ]] :<c-u>call TexJump2Section( v:count1, '' )<CR>
"noremap <buffer> <silent> [[ :<c-u>call TexJump2Section( v:count1, 'b' )<CR>
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
