" vundle.vim - path option manipulation
" Maintainer:   gmarik at gmail dot com
" Version:      0.1

" Install in ~/.vim/autoload (or ~\vimfiles\autoload).

if exists("g:vundle_loaded") || &cp | finish | endif
let g:vundle_loaded = 1

com! -nargs=+ Bundle call g:BundleAdd(<args>)
com! -nargs=0 BundleRequire call g:BundleRequire()
com! -nargs=0 BundleSync call g:BundleSync()
com! -nargs=0 BundleInstall call g:BundleInstall()

let g:bundle_dir = expand('~/.vim/bundle/')
let g:bundles = []
let g:bundle_uris = {}

function! g:BundleAdd(...)
  let bundle = split(a:1,'\/')[-1]
  call add(g:bundles, bundle)
  let g:bundle_uris[bundle] = a:1
endfunction

function! g:BundleRequire()
  let rtp = filter(split(&rtp, ','),'v:val !~# g:bundle_dir')
  let after = [] | let before = []
  for bundle in g:bundles
    let path = s:BundleRuntime(bundle)
    let before += path[0] | let after += path[1]
  endfor
  let &rtp = join(before + rtp + after, ',')
endfunction

function! g:BundleInstall()
  call g:BundleSync()
  call g:BundleHelptags()
endfunction

function! g:BundleSync()
  for bundle in g:bundles
    let bundle_path = s:BundlePath(bundle)
    let bundle_uri = g:bundle_uris[bundle]
    execute '!cd '.bundle_path.' 2>/dev/null && git pull || git clone '.bundle_uri.' '.bundle_path
  endfor
endfunction

function! g:BundleHelptags()
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
