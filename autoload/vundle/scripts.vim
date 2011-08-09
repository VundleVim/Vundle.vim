func! vundle#scripts#all(bang, ...)
  let b:match = ''
  let info = ['"Keymap: i - Install bundle; c - Cleanup; r - Refine list; R - Reload list']
  let matches = s:load_scripts(a:bang)
  if !empty(a:1)
    let matches = filter(matches, 'v:val =~? "'.escape(a:1,'"').'"')
    let info += ['"Search results for: '.a:1]
    " TODO: highlight matches
    let b:match = a:1
  endif
  call vundle#scripts#view('search',info, reverse(matches))
  redraw!
  echo len(matches).' bundles found'
endf

func! vundle#scripts#reload() abort
  silent exec ':BundleSearch! '.(exists('b:match') ? b:match : '')
  redraw!
endf

func! vundle#scripts#complete(a,c,d)
  return join(s:load_scripts(0),"\n")
endf

func! vundle#scripts#setup_view() abort
  setl cursorline nonu
  setl ro noma ignorecase syntax=vim
  if (exists('&relativenumber')) | setl norelativenumber | endif

  syn keyword vimCommand Bundle

  com! -buffer -bang -nargs=1 DeleteBundle call vundle#installer#delete('!' == '<bang>', <args>)
  com! -buffer -bang -nargs=? InstallBundle call vundle#installer#install('!' == '<bang>', <q-args>)
  com! -buffer -nargs=0 VundleLog call s:view_log()

  nnoremap <buffer> q :silent bd!<CR>
  nnoremap <buffer> d :exec 'Delete'.getline('.')<CR>

  nnoremap <buffer> i :exec 'Install'.getline('.')<CR>
  nnoremap <buffer> I :exec 'Install'.substitute(getline('.'), '^Bundle ', 'Bundle! ', '')<CR>

  nnoremap <buffer> l :VundleLog<CR>

  nnoremap <buffer> c :BundleClean<CR>
  nnoremap <buffer> C :BundleClean!<CR>
  nnoremap <buffer> r :BundleSearch
  nnoremap <buffer> R :call vundle#scripts#reload()<CR>
endf

func! s:view_log()
  if !exists('b:log_file') | let b:log_file = tempname() | endif
  call writefile(g:vundle_log, b:log_file)
  silent pedit `=b:log_file`

  wincmd P | wincmd H
endf

func! vundle#scripts#view(title, headers, results)
  if exists('g:vundle_view')
    exec g:vundle_view.'bd!'
  endif

  let results = map(a:results, ' printf("Bundle ' ."'%s'".'", v:val) ')
  exec 'silent pedit [Vundle] '.a:title

  wincmd P | wincmd H

  let g:vundle_view = bufnr('%')

  call append(0, a:headers + results)

  setl ft=vundle
  call vundle#scripts#setup_view()
  " goto first line after headers
  exec ':'.(len(a:headers) + 1)
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
    let temp = shellescape(tempname())
    let cmd = 'wget -q -O '.temp.' '.l:vim_scripts_json. ' && mv -f '.temp.' '.shellescape(a:to)
    if (has('win32') || has('win64')) 
      let cmd = substitute(cmd, 'mv -f ', 'mv /Y ') " change force flag
      let cmd = '"'.cmd.'"'                         " enclose in quotes so && joined cmds work
    end
    silent exec '!'.cmd
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
