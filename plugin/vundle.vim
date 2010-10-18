" vundle.vim  - is a shortcut for Vim Bundle and Is a simple plugin manager for Vim
" Maintainer:   http://github.com/gmarik
" Version:      0.1
" Readme:       http://github.com/gmarik/vundle/blob/master/README.md

if exists("g:vundle_loaded") || &cp | finish | endif
let g:vundle_loaded = 1

com! -nargs=+ Bundle call vundle#add_bundle(<args>)
com! -nargs=0 BundleRequire call vundle#require_bundles()
com! -nargs=0 BundleSync call vundle#sync_bundles()
com! -nargs=0 BundleInstall call vundle#install_bundles()

let g:bundle_dir = expand('~/.vim/bundle/')
let g:bundles = []
let g:bundle_uris = {}

function! vundle#add_bundle(...)
  let bundle = split(a:1,'\/')[-1]
  call add(g:bundles, bundle)
  let g:bundle_uris[bundle] = a:1
endfunction

function! vundle#require_bundles()
  let rtp = filter(split(&rtp, ','),'v:val !~# g:bundle_dir')
  let after = [] | let before = []
  for bundle in g:bundles
    let path = s:BundleRuntime(bundle)
    let before += path[0] | let after += path[1]
  endfor
  let &rtp = join(before + rtp + after, ',')
endfunction

function! vundle#install_bundles()
  call vundle#sync_bundles()
  call vundle#helptagify_bundles()
endfunction

function! vundle#sync_bundles()
  execute '!mkdir -p '.g:bundle_dir
  for bundle in g:bundles
    let bundle_path = s:BundlePath(bundle)
    let bundle_uri = g:bundle_uris[bundle]
    execute '!echo "* '.bundle.'";cd '.bundle_path.' && git pull || git clone '.bundle_uri.' '.bundle_path
  endfor
endfunction

function! vundle#helptagify_bundles()
  for bundle in g:bundles
    let dir = s:BundlePath(bundle)
    if isdirectory(dir.'/doc') && (!filereadable(dir.'/doc/tags') || filewritable(dir.'/doc/tags'))
      helptags `=dir.'/doc'`
    endif
  endfor
endfunction

function! s:BundlePath(bundle_name)
  return expand(g:bundle_dir.a:bundle_name)
endfunction

function! s:BundleRuntime(bundle_name) " {{{1
  let bundle_path = s:BundlePath(a:bundle_name)
  let before = [bundle_path] | let after  = []
  let after_dir = expand(bundle_path.'/'.'after')
  if isdirectory(after_dir) | let after = [after_dir] | endif
  return [before, after]
endfunction " }}}
