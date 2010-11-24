func! vundle#scripts#search(...)
  let matches = filter(eval(vundle#scripts#read()), 'v:val =~ "'.escape(a:1,'"').'"')
  let results = map(matches, ' printf("Bundle \"%s\"", v:val) ') 
  let temp = tempname()
  call writefile(results, temp)
  exec 'sp '.temp
	let @/=a:1
  setlocal hls ft=vim
  redraw
endf

func! vundle#scripts#fetch(to)
  let temp = tempname()
  exec '!curl http://vim-scripts.org/api/scripts.json > '.temp
  exec '!mkdir -p $(dirname  '.a:to.') && mv -f '.temp.' '.a:to
endf

func! vundle#scripts#read()
  let scripts_file = expand('$HOME/.vim-vundle/vim-scripts.org.json')
  if !filereadable(scripts_file)
    call vundle#scripts#fetch(scripts_file)
  endif
  return readfile(scripts_file, 'b')[0]
endf
