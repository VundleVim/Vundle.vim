func! vundle#installer#install(bang)
  call s:reload_bundles()
  if !isdirectory(g:bundle_dir) | call mkdir(g:bundle_dir, 'p') | endif
  for bundle in g:bundles | call s:install('!' == a:bang, bundle) | endfor
endf

func! vundle#installer#helptags()
  let c = 0
  for bundle in g:bundles | let c += s:helptags(bundle.rtpath()) | endfor
  call s:log('Done. '.c.' bundles processed')
endf

func! s:reload_bundles()
  " TODO: obtain Bundles without sourcing .vimrc
  silent source $MYVIMRC
  if !filereadable($MYGVIMRC)| silent source $MYGVIMRC | endif
endf

func! s:helptags(rtp)
  if !(isdirectory(a:rtp.'/doc') && (!filereadable(a:rtp.'/doc/tags') || filewritable(a:rtp.'/doc/tags')))
    return 0
  endif
  helptags `=a:rtp.'/doc'`
  return 1
endf

func! s:sync(bang, bundle) 
  let git_dir = a:bundle.path().'/.git'
  if isdirectory(git_dir)
    if !(a:bang) | return 0 | endif
    silent exec '!cd '.a:bundle.path().'; git pull >/dev/null 2>&1'
  else
    silent exec '!git clone '.a:bundle.uri.' '.a:bundle.path().' >/dev/null 2>&1'
  endif
  return 1
endf

func! s:install(bang, bundle)
  let synced = s:sync(a:bang, a:bundle)
  call s:helptags(a:bundle.rtpath())
  call s:log(a:bundle.name.' '.(synced ? '': ' already').' installed')
  if synced | call vundle#config#require(a:bundle) | endif
endf

" TODO: make it pause after output in console mode
func! s:log(msg)
  if has('gui_running')
    echo a:msg
  else
    " console vim requires to hit ENTER after each !cmd with stdout output
    " workaround
    silent exec '! echo '.a:msg.' >&2| cat >/dev/null' 
  endif
endf
