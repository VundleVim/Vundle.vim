func! vundle#installer#install(bang, ...) abort
  if !isdirectory(g:bundle_dir) | call mkdir(g:bundle_dir, 'p') | endif
  let bundles = (a:1 == '') ?
        \ s:reload_bundles() :
        \ map(copy(a:000), 'vundle#config#init_bundle(v:val, {})')

  let [installed, errors] = s:install(a:bang, bundles)
  if empty(errors) | redraw! | end
  " TODO: handle error: let user know hen they need to restart Vim
  call vundle#config#require(bundles)

  let msg = 'No new bundles were installed'
  if (!empty(installed))
    let msg = "Installed bundles:\n".join(map(installed, 'v:val.name'),"\n")
  endif
  call s:log(msg)

  call vundle#installer#helptags(bundles)
endf

func! vundle#installer#helptags(bundles) abort
  let bundle_dirs = map(copy(a:bundles),'v:val.rtpath()')
  let help_dirs = filter(bundle_dirs, 's:has_doc(v:val)')
  call map(copy(help_dirs), 's:helptags(v:val)')
  if !empty(help_dirs)
    call s:log('Helptags: '.len(help_dirs).' bundles processed')
  endif
  return help_dirs
endf

func! vundle#installer#clean(bang) abort
  let bundle_dirs = map(copy(g:bundles), 'v:val.path()') 
  let all_dirs = split(globpath(g:bundle_dir, '*'), "\n")
  let x_dirs = filter(all_dirs, '0 > index(bundle_dirs, v:val)')

  if empty(x_dirs)
    call s:log("All clean!")
    return
  end

  if (a:bang || input('Are you sure you want to remove '.len(x_dirs).' bundles? [ y/n ]:') =~? 'y')
    let cmd = (has('win32') || has('win64')) ?
    \           'rmdir /S /Q' :
    \           'rm -rf'
    exec '!'.cmd.' '.join(map(x_dirs, 'shellescape(v:val)'), ' ')
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
    if !(a:bang) | return [0, 'skip'] | endif
    let cmd = 'cd '.shellescape(a:bundle.path()).' && git pull'

    if (has('win32') || has('win64'))
      let cmd = substitute(cmd, '^cd ','cd /d ','')  " add /d switch to change drives
      let cmd = '"'.cmd.'"'                          " enclose in quotes
    endif
  else
    let cmd = 'git clone '.a:bundle.uri.' '.shellescape(a:bundle.path())
  endif

  silent exec '!'.cmd

  if 0 != v:shell_error
    echohl Error | echo 'Error installing "'.a:bundle.name.'". Failed cmd: '.cmd | echohl None
    return [v:shell_error, 'error']
  end
  return [0, 'ok']
endf

func! s:install(bang, bundles) abort
  let [installed, errors] = [[],[]]

  for b in a:bundles 
    let [err_code, status] = s:sync(a:bang, b)
    if 0 == err_code
      if 'ok' == status | call add(installed, b) | endif
    else
      call add(errors, b)
    endif
  endfor
  return [installed, errors]
endf

" TODO: make it pause after output in console mode
func! s:log(msg)
  echo a:msg
endf
