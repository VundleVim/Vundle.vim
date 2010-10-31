" vundle.vim  - is a shortcut for Vim Bundle and Is a simple plugin manager for Vim
" Maintainer:   http://github.com/gmarik
" Version:      0.1
" Readme:       http://github.com/gmarik/vundle/blob/master/README.md

if exists("g:vundle_loaded") || &cp | finish | endif
let g:vundle_loaded = 1

au BufRead,BufNewFile {bundlerc} set ft=vim

com! -nargs=+ Bundle call vundle#add_and_require_bundle(<args>)
com! -nargs=0 BundleSync call vundle#sync_bundles()
com! -nargs=0 BundleInstall call vundle#install_bundles()

let g:bundle_dir = expand('~/.vim/bundle/')
let g:bundles = []

func! vundle#add_bundle(uri, opts)
  let bundle = a:opts 
  let bundle.uri = a:uri
  let bundle.name = split(a:uri,'\/')[-1] " potentially break on Windows
  let bundle.path = expand(g:bundle_dir.''.bundle.name)
  let bundle.rtpath = has_key(bundle, 'rtp') ? join([bundle.path, bundle.rtp], '/') : bundle.path
  call add(g:bundles, bundle)
  return bundle
endf

func! vundle#add_and_require_bundle(...)
  let [uri; rest] = a:000 | let opts = {}
  if len(rest) == 1 | let opts = rest[0] | endif
  let bundle = vundle#add_bundle(uri, opts)
  call vundle#require_bundle(bundle)
endf

func! vundle#rc()
  let &rtp = join(filter(split(&rtp, ','),'v:val !~# g:bundle_dir'), ',')
  let g:bundles = []
endf

func! vundle#require_bundle(bundle)
  let rtp = filter(split(&rtp, ','),'v:val !~# a:bundle.path')
  let after = [] | let before = []
  let path = s:RuntimePath(a:bundle)
  let before += path[0] | let after += path[1]
  let &rtp = join(before + rtp + after, ',')
endf

func! vundle#install_bundles()
  exec '!mkdir -p '.g:bundle_dir
  call vundle#sync_bundles()
  call vundle#helptagify_bundles()
endf

func! vundle#sync_bundles()
  for bundle in g:bundles
    let git_dir = bundle.path.'/.git'
    let cmd = isdirectory(git_dir) ?  
          \ '--git-dir='.git_dir.' pull' : 
          \ 'clone '.bundle.uri.' '.bundle.path
    exec '!echo -ne "* '.bundle.name.'"'
    exec '!git '.cmd
  endfor
endf

func! vundle#helptagify_bundles()
  for bundle in g:bundles
    let dir = bundle.path
    if isdirectory(dir.'/doc') && (!filereadable(dir.'/doc/tags') || filewritable(dir.'/doc/tags'))
      helptags `=dir.'/doc'`
    endif
  endfor
endf

func! s:RuntimePath(bundle) 
  let before = [a:bundle.rtpath] | let after  = []
  let after_dir = expand(a:bundle.rtpath.'/'.'after')
  if isdirectory(after_dir) | let after = [after_dir] | endif
  return [before, after]
endf 
