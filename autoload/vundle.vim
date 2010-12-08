" vundle.vim  - is a shortcut for Vim Bundle and Is a simple plugin manager for Vim
" Maintainer:   http://github.com/gmarik
" Version:      0.4
" Readme:       http://github.com/gmarik/vundle/blob/master/README.md

com! -nargs=+       Bundle                call vundle#add_bundle(<args>)
com! -nargs=0       BundleInstall         call vundle#install_bundles()
com! -nargs=0       BundleDocs            call vundle#helptags()

com! -nargs=+ -bang BundleSearch  silent  call vundle#scripts#search("<bang>", <q-args>)

func! vundle#rc()
  let g:bundle_dir = expand('$HOME/.vim/bundle/')
  let g:bundles = []
endf

func! vundle#add_bundle(arg, ...)
  let bundle = s:parse_options(a:000)
  call add(g:bundles, bundle)
  call extend(bundle, s:parse_name(a:arg))  
  call extend(bundle, copy(s:bundle))
  call s:rtp_add(bundle.rtpath())
endf

func! vundle#install_bundles()
  silent source ~/.vimrc
  exec '!mkdir -p '.g:bundle_dir
  for bundle in g:bundles | call s:install(bundle) | endfor
  echo 'Done'
endf

func! vundle#helptags()
  let c = 0
  for bundle in g:bundles | let c += s:helptags(bundle.rtpath()) | endfor
  echo 'Done. '.c.' helptags generated'
endf

func! s:rtp_add(dir)
  exec 'set rtp^='.a:dir
  let after = expand(a:dir.'/after') | if isdirectory(after) 
    exec 'set rtp+='.after 
  endif
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

func! s:require(bundle)
  exec 'runtime '.bundle.rtpath().'/plugin/*.vim'
endf

func! s:sync(bundle) 
  let git_dir = a:bundle.path().'/.git'
  echo a:bundle.name
  if isdirectory(git_dir)
    silent exec '!cd '.a:bundle.path().'; git pull'
  else
    silent exec '!git clone '.a:bundle.uri.' '.a:bundle.path()
  endif
endf

func! s:install(bundle)
  call s:sync(a:bundle) 
  call s:helptags(a:bundle)
endf

let s:bundle = {}

func! s:bundle.path()
  return expand(g:bundle_dir.''.self.name)
endf

func! s:bundle.rtpath()
  return has_key(self, 'rtp') ? join([self.path(), self.rtp], '/') : self.path()
endf
