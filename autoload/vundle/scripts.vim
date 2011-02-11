func! vundle#scripts#search(bang,search_str)
  let matches = filter(s:load_scripts(a:bang), 'v:val =~? "'.escape(a:search_str,'"').'"')
  let results = map(matches, ' printf("Bundle ' ."'%s'".'", v:val) ') 
  call s:display(reverse(results), a:search_str)
endf

func! s:display(results,search_str)
  if !exists('s:buff') | let s:buff = tempname() | endif
  call writefile(['" Search results for: '.a:search_str] + a:results, s:buff)
  pedit `=s:buff`
  wincmd P
  let @/=a:search_str
  setlocal hls ignorecase ft=vim 
  redraw!
endf

func! s:fetch_scripts(to)
  let temp = tempname()
  exec '!curl http://vim-scripts.org/api/scripts.json > '.temp
  exec '!mkdir -p $(dirname  '.a:to.') && mv -f '.temp.' '.a:to
endf

func! s:load_scripts(bang)
  let f = expand('$HOME/.vim-vundle/vim-scripts.org.json')
  if '!' == a:bang || !filereadable(f)
    call s:fetch_scripts(f)
  endif
  return eval(readfile(f, 'b')[0])
endf
