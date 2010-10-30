" vundle.vim  - is a shortcut for Vim Bundle and Is a simple plugin manager for Vim
" Maintainer:   http://github.com/gmarik
" Version:      0.1
" Readme:       http://github.com/gmarik/vundle/blob/master/README.md

if exists("g:vundle_loaded") || &cp | finish | endif
let g:vundle_loaded = 1

au BufRead,BufNewFile {bundlerc} set ft=vim

com! -nargs=+ Bundle call vundle#add_bundle(<args>)
com! -nargs=0 BundleRequire call vundle#require_bundles()
com! -nargs=0 BundleSync call vundle#sync_bundles()
com! -nargs=0 BundleInstall call vundle#install_bundles()

let g:bundle_dir = expand('~/.vim/bundle/')
let g:bundles = []

func! vundle#add_bundle(...)
  let bundle = { 'uri': a:1 }
  let bundle.name = split(a:1,'\/')[-1] " potentially break on Windows
  let bundle.path = s:BundlePath(bundle.name)
  if len(a:000) == 2 
    if type(a:2) == type({}) | call extend(bundle, a:2) | endif
  endif
  let bundle.rtpath = has_key(bundle, 'rtp') ? join([bundle.path, bundle.rtp], '/') : bundle.path
  call add(g:bundles, bundle)
endf

func! vundle#rc(...)
  exec 'silent! so '.expand('~/.vim/bundlerc')
  call vundle#require_bundles()
endf

func! vundle#require_bundles()
  let rtp = filter(split(&rtp, ','),'v:val !~# g:bundle_dir')
  let after = [] | let before = []
  for bundle in g:bundles
    let path = s:BundleRuntime(bundle)
    let before += path[0] | let after += path[1]
  endfor
  let &rtp = join(before + rtp + after, ',')
endf

func! vundle#install_bundles()
  call vundle#sync_bundles()
  call vundle#helptagify_bundles()
endf

func! vundle#sync_bundles()
  exec '!mkdir -p '.g:bundle_dir
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

func! s:BundlePath(bundle_name)
  return expand(g:bundle_dir.a:bundle_name)
endf

func! s:BundleRuntime(bundle) 
  let before = [a:bundle.rtpath] | let after  = []
  let after_dir = expand(a:bundle.rtpath.'/'.'after')
  if isdirectory(after_dir) | let after = [after_dir] | endif
  return [before, after]
endf 
