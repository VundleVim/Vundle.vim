func! vundle#scripts#search(...)
  let matches = map(vundle#scripts#lookup(a:1), ' printf("Bundle \"%-5s\"", v:val[1]) ') | let temp = tempname()
  call writefile(matches, temp)
  exec 'sp '.temp
	let @/=a:1
endf

func! vundle#scripts#lookup(term)
  return filter(items(vundle#scripts#load()), 'v:val[1] =~ "'.escape(a:term,'"').'"')
endf

func! vundle#scripts#fetch()
  let to = g:vundle_scripts_file
  let temp = tempname()
  silent exec '!curl http://vim-scripts.org/scripts.json > '.temp
  silent exec '!mkdir -p $(dirname  '.to.') && mv -f '.temp.' '.to
  return to
endf

func! vundle#scripts#read()
  if !filereadable(g:vundle_scripts_file)
    call vundle#scripts#fetch()
  endif
  return readfile(g:vundle_scripts_file, 'b')[0]
endf

func! vundle#scripts#load()
  if !exists('g:vundle_scripts') || empty(g:vundle_scripts)
		let g:vundle_scripts_file = expand('$HOME/.vim-vundle/vim-scripts.org.json')
    let g:vundle_scripts = eval(vundle#scripts#read())
  endif

  return g:vundle_scripts
endf

func! vundle#scripts#find(id)
  let scripts = vundle#scripts#load()
  return scripts[a:id]
endf
