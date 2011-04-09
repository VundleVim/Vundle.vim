func! vundle#installer#install(bang, ...) abort
  if !isdirectory(g:bundle_dir) | call mkdir(g:bundle_dir, 'p') | endif
  let bundles = (a:1 == '') ?
        \ s:reload_bundles() :
        \ map(copy(a:000), 'vundle#config#init_bundle(v:val, {})')

  let installed = s:install(a:bang, bundles)
  redraw!
  call vundle#config#require(bundles)

  call s:log("Installed bundles:\n".join((empty(installed) ?  ['no new bundless installed'] : map(installed, 'v:val.name')),"\n"))

  let help_dirs = vundle#installer#helptags(bundles)
endf

func! vundle#installer#helptags(bundles) abort
  let bundle_dirs = map(copy(a:bundles),'v:val.rtpath()')
  let help_dirs = filter(bundle_dirs, 's:has_doc(v:val)')
  call map(copy(help_dirs), 's:helptags(v:val)')
  if !empty(help_dirs)
    call s:log('Helptags: done. '.len(help_dirs).' bundles processed')
  endif
  return help_dirs
endf

func! vundle#installer#clean(bang) abort
  let bundle_dirs = map(copy(g:bundles), 'v:val.path()') 
  let all_dirs = split(globpath(g:bundle_dir, '*'), "\n")
  let x_dirs = filter(all_dirs, '0 > index(bundle_dirs, v:val)')
  if (!empty(x_dirs))
    " TODO: improve message
    if (a:bang || input('Are you sure you want to remove '.len(x_dirs).' bundles?') =~? 'y')
      if has('win32') || has('win64')
        exec '!rmdir /S /Q '.join(map(x_dirs, 'shellescape(v:val)'), ' ')
      else
        exec '!rm -rf '.join(map(x_dirs, 'shellescape(v:val)'), ' ')
      endif
    endif
  end
endf

func! s:reload_bundles()
  " TODO: obtain Bundles without sourcing .vimrc
  silent source $MYVIMRC
  if filereadable($MYGVIMRC)| silent source $MYGVIMRC | endif
  return g:bundles
endf

func! s:has_doc(rtp) abort
  return isdirectory(a:rtp.'/doc')
    \ && (!filereadable(a:rtp.'/doc/tags') || filewritable(a:rtp.'/doc/tags'))
    \ && !(empty(glob(a:rtp.'/doc/*.txt')) && empty(glob(a:rtp.'/doc/*.??x')))
endf

func! s:helptags(rtp) abort
  helptags `=a:rtp.'/doc'`
endf

func! s:sync(bang, bundle) abort
  let git_dir = shellescape(expand(a:bundle.path().'/.git'))
  if isdirectory(git_dir)
    if !(a:bang) | return 0 | endif
    let cmd = 'cd '.shellescape(a:bundle.path()).' && git pull'
  else
    let cmd = 'git clone '.a:bundle.uri.' '.shellescape(a:bundle.path())
  endif
  silent exec '!'.cmd
  return 1
endf

func! s:install(bang, bundles) abort
  return filter(copy(a:bundles), 's:sync(a:bang, v:val)')
endf

" TODO: make it pause after output in console mode
func! s:log(msg)
  echo a:msg
endf
