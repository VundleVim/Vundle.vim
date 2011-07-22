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
  redraw!
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
  let l = getline('.')
  if l !~ '^Bundle '
    echohl Error | echo 'Select Bundle to install'| echohl None
    return 0
  end
  let line = substitute(substitute(l, '\s*Bundle\s*','','g'), "'",'','g')
  call vundle#installer#install(0, line)
endf

func! vundle#scripts#setup_view() abort
  setl hls ro noma ignorecase syntax=vim

  syn keyword vimCommand Bundle

  nnoremap <buffer> q :wincmd q<CR>
  nnoremap <buffer> i :call vundle#scripts#install()<CR>
  nnoremap <buffer> r :Bundles 
  nnoremap <buffer> c :BundleClean<CR>
  nnoremap <buffer> C :BundleClean!<CR>
  nnoremap <buffer> R :call vundle#scripts#reload()<CR>
endf

func! s:display(headers, results)
  if !exists('s:browse') | let s:browse = tempname() | endif
  let results = reverse(map(a:results, ' printf("Bundle ' ."'%s'".'", v:val) '))
  call writefile(a:headers + results, s:browse)
  silent pedit `=s:browse`

  wincmd P | wincmd H

  setl ft=vundle
  call vundle#scripts#setup_view()
endf

func! s:fetch_scripts(to)
  let scripts_dir = fnamemodify(expand(a:to), ":h")
  if !isdirectory(scripts_dir)
    call mkdir(scripts_dir, "p")
  endif

  let l:vim_scripts_json = 'http://vim-scripts.org/api/scripts.json'
  if executable("curl")
    silent exec '!curl --fail -s -o '.shellescape(a:to).' '.l:vim_scripts_json
  elseif executable("wget")
    silent exec '!wget -q -O '.shellescape(a:to).' '.l:vim_scripts_json
  else
    echoerr 'Error curl or wget is not available!'
    return 1
  endif

  if (0 != v:shell_error)
    echoerr 'Error fetching scripts!'
    return v:shell_error
  endif
  return 0
endf

func! s:load_scripts(bang)
  let f = expand('$HOME/.vim-vundle/vim-scripts.org.json')
  if a:bang || !filereadable(f)
    if 0 != s:fetch_scripts(f)
      return []
    end
  endif
  return eval(readfile(f, 'b')[0])
endf
