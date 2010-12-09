" vundle.vim  - is a shortcut for Vim Bundle and Is a simple plugin manager for Vim
" Maintainer:   http://github.com/gmarik
" Version:      0.5
" Readme:       http://github.com/gmarik/vundle/blob/master/README.md

com! -nargs=+       Bundle                call vundle#config#bundle(<args>)
com! -nargs=? -bang BundleInstall         call vundle#installer#install("<bang>")
com! -nargs=0       BundleDocs            call vundle#installer#helptags()

com! -nargs=+ -bang BundleSearch  silent  call vundle#scripts#search("<bang>", <q-args>)

if !exists('g:bundles') | let g:bundles = [] | endif

func! vundle#rc()
  let g:bundle_dir = expand('$HOME/.vim/bundle')
  call vundle#config#init()
endf
