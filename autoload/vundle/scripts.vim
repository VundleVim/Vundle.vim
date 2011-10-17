func! vundle#scripts#all(bang, ...)
  let b:match = ''
  let info = ['"Keymap: i - Install bundle; c - Cleanup; s - Search; R - Reload list']
  let matches = s:load_scripts(a:bang)
  if !empty(a:1)
    let matches = filter(matches, 'v:val =~? "'.escape(a:1,'"').'"')
    let info += ['"Search results for: '.a:1]
    " TODO: highlight matches
    let b:match = a:1
  endif
  call vundle#scripts#view('search',info, vundle#scripts#bundle_names(reverse(matches)))
  redraw
  echo len(matches).' bundles found'
endf

func! vundle#scripts#reload() abort
  silent exec ':BundleSearch! '.(exists('b:match') ? b:match : '')
  redraw
endf

func! vundle#scripts#complete(a,c,d)
  return join(s:load_scripts(0),"\n")
endf

func! s:view_log()
  if !exists('g:vundle_log_file')
    let g:vundle_log_file = tempname()
  endif

  call writefile(g:vundle_log, g:vundle_log_file)
  silent pedit `=g:vundle_log_file`

  wincmd P | wincmd H
endf

func! vundle#scripts#bundle_names(names)
  return map(copy(a:names), ' printf("Bundle ' ."'%s'".'", v:val) ')
endf

func! vundle#scripts#bundle_make_cmds(bundles)
  let bundles_with_make = filter(copy(a:bundles), 'has_key(v:val, "make_cmd")')
  return map(bundles_with_make, ' printf("Make ' ."'%s'".' '.'", v:val.name_spec) ')
endf

func! vundle#scripts#view(title, headers, results)
  if exists('g:vundle_view') && bufloaded(g:vundle_view)
    exec g:vundle_view.'bd!'
  endif

  exec 'silent pedit [Vundle] '.a:title

  wincmd P | wincmd H

  let g:vundle_view = bufnr('%')

  call append(0, a:headers + a:results)

  setl buftype=nofile
  setl noswapfile

  setl cursorline
  setl nonu ro noma ignorecase 
  if (exists('&relativenumber')) | setl norelativenumber | endif

  setl ft=vundle
  setl syntax=vim
  syn keyword vimCommand Bundle
  syn keyword vimCommand Helptags
  syn keyword vimCommand Make

  com! -buffer -bang -nargs=1 DeleteBundle
    \ call vundle#installer#run('vundle#installer#delete', split(<q-args>,',')[0], ['!' == '<bang>', <args>])

  com! -buffer -bang -nargs=? InstallAndRequireBundle   
    \ call vundle#installer#run('vundle#installer#install_and_require', split(<q-args>,',')[0], ['!' == '<bang>', <q-args>])

  com! -buffer -bang -nargs=? InstallBundle
    \ call vundle#installer#run('vundle#installer#install', split(<q-args>,',')[0], ['!' == '<bang>', <q-args>])

  com! -buffer -bar -bang -nargs=1 InstallMake 
    \ call vundle#installer#run('vundle#installer#make', split(<q-args>,',')[0], [split(<args>,',')[0]])

  com! -buffer -bang -nargs=0 InstallHelptags 
    \ call vundle#installer#run('vundle#installer#docs', 'helptags', [])

  com! -buffer -nargs=0 VundleLog call s:view_log()


  nnoremap <buffer> q :silent bd!<CR>
  nnoremap <buffer> D :exec 'Delete'.getline('.')<CR>

  nnoremap <buffer> add  :exec 'Install'.getline('.')<CR>
  nnoremap <buffer> add! :exec 'Install'.substitute(getline('.'), '^Bundle ', 'Bundle! ', '')<CR>

  nnoremap <buffer> i :exec 'InstallAndRequire'.getline('.')<CR>
  nnoremap <buffer> I :exec 'InstallAndRequire'.substitute(getline('.'), '^Bundle ', 'Bundle! ', '')<CR>

  nnoremap <buffer> l :VundleLog<CR>
  nnoremap <buffer> h :h vundle<CR>
  nnoremap <buffer> ? :norm h<CR>

  nnoremap <buffer> c :BundleClean<CR>
  nnoremap <buffer> C :BundleClean!<CR>

  nnoremap <buffer> s :BundleSearch
  nnoremap <buffer> R :call vundle#scripts#reload()<CR>

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
  let f = expand(g:bundle_dir.'/.vundle/script-names.vim-scripts.org.json')
  if a:bang || !filereadable(f)
    if 0 != s:fetch_scripts(f)
      return []
    end
  endif
  return eval(readfile(f, 'b')[0])
endf
