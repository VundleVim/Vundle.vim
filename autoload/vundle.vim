" vundle.vim  - is a shortcut for Vim Bundle and Is a simple plugin manager for Vim
" Maintainer:   http://github.com/gmarik
" Version:      0.3
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
  call bundle.require()
endf

func! vundle#install_bundles()
  silent source ~/.vimrc
  exec '!mkdir -p '.g:bundle_dir
  for bundle in g:bundles | call bundle.install() | endfor
endf

func! vundle#helptags()
  for bundle in g:bundles | call bundle.helptags() | endfor
endf

func s:parse_options(opts)
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

let s:bundle = {}

func s:bundle.path()
  return expand(g:bundle_dir.''.self.name)
endf

func s:bundle.rtpath()
  return has_key(self, 'rtp') ? join([self.path(), self.rtp], '/') : self.path()
endf

func s:bundle.require()
  let dir = self.rtpath()
  exec 'set rtp^='.dir
  let after = expand(dir.'/after') | if isdirectory(after) 
    exec 'set rtp+='.after 
  endif
endf

func! s:bundle.helptags()
  let dir = self.rtpath()
  if isdirectory(dir.'/doc') && (!filereadable(dir.'/doc/tags') || filewritable(dir.'/doc/tags'))
    helptags `=dir.'/doc'`
  endif
endf

func! s:bundle.sync() 
  let git_dir = self.path().'/.git'
  exec '!echo -ne "* '.self.name.'"'
  if isdirectory(git_dir)
    silent exec '!cd '.self.path().'; git pull'
  else
    silent exec '!git clone '.self.uri.' '.self.path()
  endif
endf

func! s:bundle.install()
  call self.sync() 
  call self.helptags()
endf
