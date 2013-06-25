function MyCalc(str)
  if exists("g:MyCalcRounding")
    return system("echo 'x=" . a:str . ";d=.5/10^" . g:MyCalcPresition
          \. ";if (x<0) d=-d; x+=d; scale=" . g:MyCalcPresition . ";print x/1' | bc -l")
  else
    return system("echo 'scale=" . g:MyCalcPresition . " ; print " . a:str . "' | bc -l")
  endif
endfunction

" Control the precision with this variable
let g:MyCalcPresition = 2
" Comment this if you don't want rounding
let g:MyCalcRounding = 1
" Use \C to replace the current line of math expression(s) by the value of the computation:
map <silent> <Leader>c :s/.*/\=MyCalc(submatch(0))/<CR>:noh<CR>
" Same for a visual selection block
vmap <silent> <Leader>c :B s/.*/\=MyCalc(submatch(0))/<CR>:noh<CR>
" With \C= don't replace, but add the result at the end of the current line
map <silent> <Leader>c= :s/.*/\=submatch(0) . " = " . MyCalc(submatch(0))/<CR>:noh<CR>
" Same for a visual selection block
vmap <silent> <Leader>c= :B s/.*/\=submatch(0) . " = " . MyCalc(submatch(0))/<CR>:noh<CR>
" Try: :B s/.*/\=MyCalc("1000 - " . submatch(0))/
" The concatenation is important, since otherwise it will try
" to evaluate things like in ":echo 1000 - ' 1748.24'"
vmap <Leader>c+ :B s/.*/\=MyCalc(' +' . submatch(0))/<C-Left><C-Left><C-Left><Left>
vmap <Leader>c- :B s/.*/\=MyCalc(' -' . submatch(0))/<C-Left><C-Left><C-Left><Left>
" With \Cs you add a block of expressions, whose result appears in the command line
vmap <silent> <Leader>ct y:echo MyCalc(substitute(@0," *\n","+","g"))<CR>:silent :noh<CR>
" Try: :MyCalc 12.7 + sqrt(98)
command! -nargs=+ MyCalc :echo MyCalc("<args>")
