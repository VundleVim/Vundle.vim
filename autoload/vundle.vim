" vundle.vim  - is a shortcut for Vim Bundle and Is a simple plugin manager for Vim
" Maintainer:   http://github.com/gmarik
" Version:      0.4
" Readme:       http://github.com/gmarik/vundle/blob/master/README.md

com! -nargs=+       Bundle                call vundle#add_bundle(<args>)
com! -nargs=? -bang BundleInstall         call vundle#install_bundles("<bang>")
com! -nargs=0       BundleDocs            call vundle#helptags()

com! -nargs=+ -bang BundleSearch  silent  call vundle#scripts#search("<bang>", <q-args>)

if !exists('g:bundles') | let g:bundles = [] | endif

func! vundle#rc()
  let g:bundle_dir = expand('$HOME/.vim/bundle')
  call filter(g:bundles, 's:rtp_rm(v:val.rtpath())')
  call s:rtp_rm(g:bundle_dir)
  let g:bundles = []
endf

func! vundle#add_bundle(arg, ...)
  let bundle = extend(s:parse_options(a:000), s:parse_name(a:arg))
  call extend(bundle, copy(s:bundle))
  call add(g:bundles, bundle)
  call s:rtp_add(bundle.rtpath())
  call s:rtp_add(g:bundle_dir)
  exec 'runtime! '.bundle.name.'/plugin/*.vim'
endf

func! vundle#install_bundles(bang)
  silent source ~/.vimrc
  if !isdirectory(g:bundle_dir) | call mkdir(g:bundle_dir, 'p') | endif
  for bundle in g:bundles | call s:install('!' == a:bang, bundle) | endfor
endf

func! vundle#helptags()
  let c = 0
  for bundle in g:bundles | let c += s:helptags(bundle.rtpath()) | endfor
  echo 'Done. '.c.' bundles processed'
endf

func! s:parse_options(opts)
  " TODO: improve this
  if len(a:opts) != 1 | return {} | endif
    
  if type(a:opts[0]) == type({})
    return a:opts[0]
  else
    return {'rev': a:opts[0]}
  endif
endf

func! s:parse_name(arg)
  let arg = a:arg
  if arg =~ '^\s*\(git@\|git://\)\S\+' || arg =~ 'https\?://' || arg =~ '\.git\*$'
    let uri = arg
    let name = substitute(split(uri,'\/')[-1], '\.git\s*$','','i')
  else
    let name = arg
    let uri  = 'http://github.com/vim-scripts/'.name.'.git'
  endif
  return {'name': name, 'uri': uri }
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
    silent exec '!cd '.a:bundle.path().'; git pull'
  else
    silent exec '!git clone '.a:bundle.uri.' '.a:bundle.path()
  endif
  return 1
endf

func! s:install(bang, bundle)
  let synced = s:sync(a:bang, a:bundle)
  echo a:bundle.name.' '.(synced ? ' ': ' already').' installed'
  call s:helptags(a:bundle.rtpath())
endf

func! s:rtp_rm(dir)
  exec 'set rtp-='.a:dir
  exec 'set rtp-='.expand(a:dir.'/after')
endf

func! s:rtp_add(dir)
  exec 'set rtp^='.a:dir
  exec 'set rtp+='.expand(a:dir.'/after')
endf

let s:bundle = {}

func! s:bundle.path()
  return join([g:bundle_dir, self.name], '/')
endf

func! s:bundle.rtpath()
  return has_key(self, 'rtp') ? join([self.path(), self.rtp], '/') : self.path()
endf
