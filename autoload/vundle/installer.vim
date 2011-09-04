func! vundle#installer#new(bang, ...) abort
  let vundles = (a:1 == '') ?
        \ g:vundles :
        \ map(copy(a:000), 'vundle#config#init_vundle(v:val, {})')

  let names = vundle#scripts#vundle_names(map(copy(vundles), 'v:val.name_spec'))
  call vundle#scripts#view('Installer',['" Installing vundles to '.expand(g:vundle_dir)], names +  ['Helptags'])

  call s:process(a:bang, (a:bang ? 'add!' : 'add'))

  call vundle#config#require(vundles)
endf


func! s:process(bang, cmd)
  let msg = ''

  redraw!
  sleep 1m

  let lines = (getline('.','$')[0:-2])

  for line in lines
    redraw!

    exec ':norm '.a:cmd

    if 'error' == g:vundle_last_status
      let msg = 'With errors; press l to view log'
    endif

    " goto next one
    exec ':+1'

    setl nomodified
  endfor

  redraw!
  echo 'Done! '.msg
endf

func! vundle#installer#run(func_name, name, ...) abort
  let n = a:name

  echo 'Processing '.n
  call s:sign('active')

  sleep 1m

  let status = call(a:func_name, a:1)

  call s:sign(status)

  redraw!

  if 'updated' == status
    echo n.' installed'
  elseif 'todate' == status
    echo n.' already installed'
  elseif 'deleted' == status
    echo n.' deleted'
  elseif 'error' == status
    echohl Error
    echo 'Error processing '.n
    echohl None
    sleep 1
  else
    throw 'whoops, unknown status:'.status
  endif

  let g:vundle_last_status = status

  return status
endf

func! s:sign(status)
  if (!has('signs'))
    return
  endif

  exe ":sign place ".line('.')." line=".line('.')." name=Vu_". a:status ." buffer=" . bufnr("%")
endf

func! vundle#installer#install_and_require(bang, name) abort
  let result = vundle#installer#install(a:bang, a:name)
  let b = vundle#config#init_vundle(a:name, {})
  call vundle#config#require([b])
  return result
endf

func! vundle#installer#install(bang, name) abort
  if !isdirectory(g:vundle_dir) | call mkdir(g:vundle_dir, 'p') | endif

  let b = vundle#config#init_vundle(a:name, {})

  return s:sync(a:bang, b)
endf

func! vundle#installer#docs() abort
  call vundle#installer#helptags(g:vundles)
  return 'updated'
endf

func! vundle#installer#helptags(vundles) abort
  let vundle_dirs = map(copy(a:vundles),'v:val.rtpath()')
  let help_dirs = filter(vundle_dirs, 's:has_doc(v:val)')

  call s:log('')
  call s:log('Helptags:')

  call map(copy(help_dirs), 's:helptags(v:val)')

  call s:log('Helptags: '.len(help_dirs).' vundles processed')

  return help_dirs
endf

func! vundle#installer#list(bang) abort
  let vundles = vundle#scripts#vundle_names(map(copy(g:vundles), 'v:val.name_spec'))
  call vundle#scripts#view('list', ['" My Vundles'], vundles)
  redraw!
  echo len(g:vundles).' vundles configured'
endf


func! vundle#installer#clean(bang) abort
  let vundle_dirs = map(copy(g:vundles), 'v:val.path()')
  let all_dirs = split(globpath(g:vundle_dir, '*'), "\n")
  let x_dirs = filter(all_dirs, '0 > index(vundle_dirs, v:val)')

  if empty(x_dirs)
    let headers = ['" All clean!']
    let names = []
  else
    let headers = ['" Removing vundles:']
    let names = vundle#scripts#vundle_names(map(copy(x_dirs), 'fnamemodify(v:val, ":t")'))
  end

  call vundle#scripts#view('clean', headers, names)
  redraw!

  if (a:bang || empty(names) || input('Continue ? [ y/n ]:') =~? 'y')
    call s:process(a:bang, 'D')
  endif
endf


func! vundle#installer#delete(bang, dir_name) abort

  let cmd = (has('win32') || has('win64')) ?
  \           'rmdir /S /Q' :
  \           'rm -rf'

  let vundle = vundle#config#init_vundle(a:dir_name, {})
  let cmd .= ' '.shellescape(vundle.path())

  let out = s:system(cmd)

  call s:log('')
  call s:log('Vundle '.a:dir_name)
  call s:log('$ '.cmd)
  call s:log('> '.out)

  if 0 != v:shell_error
    return 'error'
  else
    return 'deleted'
  endif
endf

func! s:has_doc(rtp) abort
  return isdirectory(a:rtp.'/doc')
  \   && (!filereadable(a:rtp.'/doc/tags') || filewritable(a:rtp.'/doc/tags'))
  \   && !(empty(glob(a:rtp.'/doc/*.txt')) && empty(glob(a:rtp.'/doc/*.??x')))
endf

func! s:helptags(rtp) abort
  let doc_path = a:rtp.'/doc/'
  call s:log(':helptags '.doc_path)
  try
    helptags `=doc_path`
  catch
    call s:log("> Error running :helptags ".doc_path)
  endtry
endf

func! s:sync(bang, vundle) abort
  let git_dir = expand(a:vundle.path().'/.git/')
  if isdirectory(git_dir)
    if !(a:bang) | return 'todate' | endif
    let cmd = 'cd '.shellescape(a:vundle.path()).' && git pull'

    if (has('win32') || has('win64'))
      let cmd = substitute(cmd, '^cd ','cd /d ','')  " add /d switch to change drives
      let cmd = '"'.cmd.'"'                          " enclose in quotes
    endif
  else
    let cmd = 'git clone '.a:vundle.uri.' '.shellescape(a:vundle.path())
  endif

  let out = s:system(cmd)
  call s:log('')
  call s:log('Vundle '.a:vundle.name_spec)
  call s:log('$ '.cmd)
  call s:log('> '.out)

  if 0 != v:shell_error
    return 'error'
  end

  if out =~# 'up-to-date'
    return 'todate'
  end

  return 'updated'
endf

func! s:system(cmd) abort
  return system(a:cmd)
endf

func! s:log(str) abort
  call add(g:vundle_log, '['.strftime("%y%m%d %T").'] '.a:str)
  return a:str
endf
