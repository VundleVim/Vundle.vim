func! vundle#scripts#search(bang,search_str)
  let matches = filter(eval(vundle#scripts#read(a:bang)), 'v:val =~ "'.escape(a:search_str,'"').'"')
  let results = map(matches, ' printf("Bundle \"%s\"", v:val) ') 
  call s:display(results, a:search_str)
endf

func! s:display(results,search_str)
  if !exists('s:buff') 
    let s:buff = tempname()
    split
  endif
  call writefile(['" Search results for: '.a:search_str] + a:results, s:buff)
  exec 'e '.s:buff
	let @/=a:search_str
  setlocal hls ft=vim
  redraw
endf

func! vundle#scripts#fetch(to)
  let temp = tempname()
  exec '!curl http://vim-scripts.org/api/scripts.json > '.temp
  exec '!mkdir -p $(dirname  '.a:to.') && mv -f '.temp.' '.a:to
endf

func! vundle#scripts#read(bang)
  let scripts_file = expand('$HOME/.vim-vundle/vim-scripts.org.json')
  if '!' == a:bang || !filereadable(scripts_file)
    call vundle#scripts#fetch(scripts_file)
  endif
  return readfile(scripts_file, 'b')[0]
endf
