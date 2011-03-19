" Vundle        is a shortcut for Vim Bundle and Is a simple plugin manager for Vim
" Author:       gmarik
" HomePage:     http://github.com/gmarik/vundle
" Readme:       http://github.com/gmarik/vundle/blob/master/README.md
" Version:      0.6

com! -nargs=+         Bundle
   \ call vundle#config#bundle(<args>)

com! -nargs=? -bang   BundleClean
   \ call vundle#installer#clean('!' == '<bang>')

com! -nargs=0         BundleDocs 
   \ call vundle#installer#helptags(g:bundles)

com! -nargs=? -bang   Bundles
   \ call vundle#scripts#all('!'=='<bang>', <q-args>)

" deprecated in favor of Bundles
com! -nargs=? -bang   BundleSearch
   \ call vundle#scripts#all('!' == '<bang>', <q-args>)

com! -nargs=0         VundleLog
   \ silent pedit `=g:vundle_log`

func! vundle#rc()
  let g:bundle_dir = expand('$HOME/.vim/bundle')
  call vundle#config#init()
endf
