func! vundle#installer#new(bang, ...) abort
  let bundles = (a:1 == '') ?
        \ g:bundles :
        \ map(copy(a:000), 'vundle#config#bundle(v:val, {})')

  let names = vundle#scripts#bundle_names(map(copy(bundles),
        \ '{ "name": v:val.name_spec, '.
        \ '"rtp": has_key(v:val, "rtp") ? v:val.rtp : "" }'))
  call vundle#scripts#view('Installer',['" Installing bundles to '.expand(g:bundle_dir, 1)], names +  ['Helptags'])

  call s:process(a:bang, (a:bang ? 'add!' : 'add'))

  call vundle#config#require(bundles)
endf


func! s:process(bang, cmd)
  let msg = ''

  redraw
  sleep 1m

  let lines = (getline('.','$')[0:-2])

  for line in lines
    redraw

    exec ':norm '.a:cmd

    if 'error' == g:vundle_last_status
      let msg = 'With errors; press l to view log'
    endif

    if 'updated' == g:vundle_last_status && empty(msg)
      let msg = 'Bundles updated; press u to view changelog'
    endif

    " goto next one
    exec ':+1'

    setl nomodified
  endfor

  redraw
  echo 'Done! '.msg
endf

func! vundle#installer#run(func_name, name, ...) abort
  let n = a:name

  echo 'Processing '.n
  call s:sign('active')

  sleep 1m

  let status = call(a:func_name, a:1)

  call s:sign(status)

  redraw

  if 'new' == status
    echo n.' installed'
  elseif 'updated' == status
    echo n.' updated'
  elseif 'todate' == status
    echo n.' already installed'
  elseif 'deleted' == status
    echo n.' deleted'
  elseif 'helptags' == status
    echo n.' regenerated'
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
  let b = vundle#config#bundle(a:name, {})
  call vundle#installer#helptags([b])
  call vundle#config#require([b])
  return result
endf

func! vundle#installer#install(bang, name) abort
  if !isdirectory(g:bundle_dir) | call mkdir(g:bundle_dir, 'p') | endif

  let arg_list = split(a:name, ',\s*')
  let rtp = len(arg_list) > 1 ? arg_list[1] : ''
  let rtp = substitute(rtp, "['".'"]\+','','g')
  let name = arg_list[0]
  let b = vundle#config#init_bundle(name, {})

  return s:sync(a:bang, b, rtp)
endf

func! vundle#installer#docs() abort
  call vundle#installer#helptags(g:bundles)
  return 'helptags'
endf

func! vundle#installer#helptags(bundles) abort
  let bundle_dirs = map(copy(a:bundles),'v:val.rtpath')
  let help_dirs = filter(bundle_dirs, 's:has_doc(v:val)')

  call s:log('')
  call s:log('Helptags:')

  call map(copy(help_dirs), 's:helptags(v:val)')

  call s:log('Helptags: '.len(help_dirs).' bundles processed')

  return help_dirs
endf

func! vundle#installer#list(bang) abort
  let bundles = vundle#scripts#bundle_names(map(copy(g:bundles), 'v:val.name_spec'))
  call vundle#scripts#view('list', ['" My Bundles'], bundles)
  redraw
  echo len(g:bundles).' bundles configured'
endf


func! vundle#installer#clean(bang) abort
  let bundle_dirs = map(copy(g:bundles), 'v:val.path()') 
  let all_dirs = (v:version > 702 || (v:version == 702 && has("patch51")))
  \   ? split(globpath(g:bundle_dir, '*', 1), "\n")
  \   : split(globpath(g:bundle_dir, '*'), "\n")
  let x_dirs = filter(all_dirs, '0 > index(bundle_dirs, v:val)')

  if empty(x_dirs)
    let headers = ['" All clean!']
    let names = []
  else
    let headers = ['" Removing bundles:']
    let names = vundle#scripts#bundle_names(map(copy(x_dirs), 'fnamemodify(v:val, ":t")'))
  end

  call vundle#scripts#view('clean', headers, names)
  redraw

  if (a:bang || empty(names))
    call s:process(a:bang, 'D')
  else
    call inputsave()
    let response = input('Continue? [Y/n]: ')
    call inputrestore()
    if (response =~? 'y' || response == '')
      call s:process(a:bang, 'D')
    endif
  endif
endf


func! vundle#installer#delete(bang, dir_name) abort

  let cmd = (has('win32') || has('win64')) ?
  \           'rmdir /S /Q' :
  \           'rm -rf'

  let bundle = vundle#config#init_bundle(a:dir_name, {})
  let cmd .= ' '.shellescape(bundle.path())

  call s:system(dir_name, cmd)

  if 0 != v:shell_error
    return 'error'
  else
    return 'deleted'
  endif
endf

func! s:has_doc(rtp) abort
  return isdirectory(a:rtp.'/doc')
  \   && (!filereadable(a:rtp.'/doc/tags') || filewritable(a:rtp.'/doc/tags'))
  \   && (v:version > 702 || (v:version == 702 && has("patch51")))
  \     ? !(empty(glob(a:rtp.'/doc/*.txt', 1)) && empty(glob(a:rtp.'/doc/*.??x', 1)))
  \     : !(empty(glob(a:rtp.'/doc/*.txt')) && empty(glob(a:rtp.'/doc/*.??x')))
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

func! s:sync(bang, bundle, rtp) abort
  let git_dir = expand(a:bundle.path().'/.git/', 1)
  let bundle_path = shellescape(a:bundle.path())
  let cmd = g:shellesc_cd('cd '.bundle_path)
  if isdirectory(git_dir) || filereadable(expand(a:bundle.path().'/.git', 1))
    if !(a:bang) | return 'todate' | endif
    let get_current_sha  = g:shellesc_cd('cd '.bundle_path)
    let get_current_sha .= ' && git rev-parse HEAD'
    let initial_sha = system(get_current_sha)[0:15]
  else
    call mkdir(a:bundle.path(), 'p')
    let cmd .= ' && git init'
    let cmd .= ' && git remote add origin '.shellescape(a:bundle.uri)
    if !empty(a:rtp)
      " TODO: This requires a feature introduced by git 1.7.0,
      " so it might be better to check the version before using it
      let cmd .= ' && git config core.sparseCheckout true'
      let cmd .= ' && echo '.shellescape(a:rtp).' >> .git/info/sparse-checkout'
    endif
    let initial_sha = ''
  endif

  let cmd .= ' && git pull --depth=1 origin master'
  if empty(a:rtp)
    " TODO: It causes error when using rtp because no .gitmodule
    " is checked out
    let cmd .= ' && git submodule update --init --recursive'
  endif
  call s:system(a:bundle.name_spec, cmd)

  if 0 != v:shell_error
    return 'error'
  end

  if empty(initial_sha)
    return 'new'
  endif

  let updated_sha = system(get_current_sha)[0:15]

  if initial_sha == updated_sha
    return 'todate'
  endif

  call add(g:updated_bundles, [initial_sha, updated_sha, a:bundle])
  return 'updated'
endf

func! g:shellesc(cmd) abort
  if (has('win32') || has('win64'))
    if &shellxquote != '('                           " workaround for patch #445
      return '"'.a:cmd.'"'                          " enclose in quotes so && joined cmds work
    endif
  endif
  return a:cmd
endf

func! g:shellesc_cd(cmd) abort
  if (has('win32') || has('win64'))
    let cmd = substitute(a:cmd, '^cd ','cd /d ','')  " add /d switch to change drives
    let cmd = g:shellesc(cmd)
    return cmd
  else
    return a:cmd
  endif
endf

func! s:system(dir_name, cmd) abort
  let out = system(a:cmd)
  call s:log('')
  call s:log('Bundle '.a:dir_name)
  call s:log('$ '.a:cmd)
  call s:log('> '.out)
  return out
endf

func! s:log(str) abort
  let fmt = '%y%m%d %H:%M:%S'
  call add(g:vundle_log, '['.strftime(fmt).'] '.a:str)
  return a:str
endf
