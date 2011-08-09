func! vundle#installer#new(bang, ...) abort
  let bundles = (a:1 == '') ?
        \ s:reload_bundles() :
        \ map(copy(a:000), 'vundle#config#init_bundle(v:val, {})')

  let names = map(copy(bundles), 'v:val.name_spec')
  call vundle#scripts#view('Installer',['" Installing'], copy(names))

  redraw!
  sleep 1m

  for n in names
    redraw!

    echo 'Processing '.n
    call s:sign('active')

    sleep 1m

    let status = call('vundle#installer#install', [a:bang, n])

    call s:sign(status)

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

    " goto next one
    exec ':+1'

    setl nomodified
  endfor

  redraw!

  call vundle#config#require(bundles)

  let helptags = vundle#installer#helptags(bundles)
  echo 'Done! Helptags: '.len(helptags).' bundles processed'
endf

func! s:sign(status) 
  if (!has('signs'))
    return
  endif

  exe ":sign place ".line('.')." line=".line('.')." name=Vu_". a:status ." buffer=" . bufnr("%")
endf

func! vundle#installer#install(bang, name) abort
  if !isdirectory(g:bundle_dir) | call mkdir(g:bundle_dir, 'p') | endif

  let b = vundle#config#init_bundle(a:name, {})

  return s:sync(a:bang, b)
endf

func! vundle#installer#helptags(bundles) abort
  let bundle_dirs = map(copy(a:bundles),'v:val.rtpath()')
  let help_dirs = filter(bundle_dirs, 's:has_doc(v:val)')
  call map(copy(help_dirs), 's:helptags(v:val)')
  return help_dirs
endf

func! vundle#installer#list(bang) abort
  let bundles = (a:bang) ? s:reload_bundles() : g:bundles
  call vundle#scripts#view('list', ['" My Bundles'], map(copy(g:bundles), 'v:val.name_spec'))
  redraw!
  echo len(g:bundles).' bundles configured'
endf


func! vundle#installer#clean(bang) abort
  let bundle_dirs = map(copy(g:bundles), 'v:val.path()') 
  let all_dirs = split(globpath(g:bundle_dir, '*'), "\n")
  let x_dirs = filter(all_dirs, '0 > index(bundle_dirs, v:val)')

  if empty(x_dirs)
    echo "All clean!"
    return
  end

  call vundle#scripts#view('clean', ['"Remove those bundles?'], map(copy(x_dirs), 'fnamemodify(v:val, ":t")'))
  redraw!

  if (a:bang || input('Are you sure you want to remove '.len(x_dirs).' bundles? [ y/n ]:') =~? 'y')

    for l in range(1,len(x_dirs))
      redraw!
      exec ':norm d'
      sleep 1m
      " goto next one
      exec ':+1'
    endfor

    redraw!

    echo 'Done!'
  endif
endf


func! vundle#installer#delete(bang, dir_name) abort

  let cmd = (has('win32') || has('win64')) ?
  \           'rmdir /S /Q' :
  \           'rm -rf'

  let path = shellescape(expand(g:bundle_dir.'/'.a:dir_name))
  let cmd .= ' '.path

  let out = s:system(cmd)

  call s:log('')
  call s:log('Bundle '.a:dir_name)
  call s:log('$ '.cmd)
  call s:log('> '.out)

  if 0 != v:shell_error
    return 'error'
  else
    return 'deleted'
  endif
endf

func! s:reload_bundles()
  " TODO: obtain Bundles without sourcing .vimrc
  if filereadable($MYVIMRC)| silent source $MYVIMRC | endif
  if filereadable($MYGVIMRC)| silent source $MYGVIMRC | endif
  return g:bundles
endf

func! s:has_doc(rtp) abort
  return isdirectory(a:rtp.'/doc')
  \   && (!filereadable(a:rtp.'/doc/tags') || filewritable(a:rtp.'/doc/tags'))
  \   && !(empty(glob(a:rtp.'/doc/*.txt')) && empty(glob(a:rtp.'/doc/*.??x')))
endf

func! s:helptags(rtp) abort
  try
    helptags `=a:rtp.'/doc/'`
  catch
    echohl Error | echo "Error generating helptags in ".a:rtp | echohl None
  endtry
endf

func! s:sync(bang, bundle) abort
  let git_dir = expand(a:bundle.path().'/.git/')
  if isdirectory(git_dir)
    if !(a:bang) | return 'todate' | endif
    let cmd = 'cd '.shellescape(a:bundle.path()).' && git pull'

    if (has('win32') || has('win64'))
      let cmd = substitute(cmd, '^cd ','cd /d ','')  " add /d switch to change drives
      let cmd = '"'.cmd.'"'                          " enclose in quotes
    endif
  else
    let cmd = 'git clone '.a:bundle.uri.' '.shellescape(a:bundle.path())
  endif

  let out = s:system(cmd)
  call s:log('')
  call s:log('Bundle '.a:bundle.name_spec)
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
  if !exists('g:vundle_log') | let g:vundle_log = [] | endif
  call add(g:vundle_log, a:str)
  return a:str
endf
