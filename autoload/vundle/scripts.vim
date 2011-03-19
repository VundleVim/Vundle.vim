func! vundle#scripts#all(bang, ...)
  let b:match = ''
  let info = ['"Keymap: i - Install bundle; c - Cleanup; r - Refine list; R - Reload list']
  if a:1== '' " whether refine search string given
    let matches = s:load_scripts(a:bang)
    call s:display(info, matches)
  else
    let matches = filter(s:load_scripts(a:bang), 'v:val =~? "'.escape(a:1,'"').'"')
    call s:display(info + ['"Search results for: '.a:1], matches)
    let @/=a:1
    " TODO: highlight doesn't work
    setl hls
    let b:match = a:1
  endif
  echo len(matches).' bundles found'
endf

func! vundle#scripts#reload() abort
  silent exec ':Bundles! '.(exists('b:match') ? b:match : '')
  redraw!
endf

func! vundle#scripts#complete(a,c,d)
  return join(s:load_scripts(0),"\n")
endf

func! vundle#scripts#install() abort
  let line = substitute(substitute(getline('.'), '\s*Bundle\s*','','g'), "'",'','g')
  call vundle#installer#install(0, line)
endf

func! s:display(headers, results)
  if !exists('s:browse') | let s:browse = tempname() | endif
  let results = reverse(map(a:results, ' printf("Bundle ' ."'%s'".'", v:val) '))
  call writefile(a:headers + results, s:browse)
  silent pedit `=s:browse`
  wincmd P | wincmd H
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
