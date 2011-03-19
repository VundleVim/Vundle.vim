func! vundle#scripts#all(bang, ...)
  if a:1== '' " whether refine search string given
    call s:display(['" Vim scripts: '], s:load_scripts(a:bang))
  else
    let matches = filter(s:load_scripts(a:bang), 'v:val =~? "'.escape(a:1,'"').'"')
    call s:display(['" Search results for: '.a:1], matches)
    let @/=a:1
    redraw
  endif
endf

func! vundle#scripts#install() abort
  let line = substitute(substitute(getline('.'), '\s*Bundle\s*','','g'), "'",'','g')
  call vundle#installer#install(0, line)
  redraw!
endf

func! s:display(headers, results)
  if !exists('s:browse') | let s:browse = tempname() | endif
  let results = reverse(map(a:results, ' printf("Bundle ' ."'%s'".'", v:val) '))
  call writefile(a:headers + results, s:browse)
  pedit `=s:browse`| wincmd P | wincmd H
  setl ft=vundle
endf

func! s:fetch_scripts(to)
  let temp = tempname()
  exec '!curl http://vim-scripts.org/api/scripts.json > '.temp.
    \  '&& mkdir -p $(dirname  '.a:to.') && mv -f '.temp.' '.a:to
endf

func! s:load_scripts(bang)
  let f = expand('$HOME/.vim-vundle/vim-scripts.org.json')
  if a:bang || !filereadable(f)
    call s:fetch_scripts(f)
  endif
  return eval(readfile(f, 'b')[0])
endf
