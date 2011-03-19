" Vundle        is a shortcut for Vim Bundle and Is a simple plugin manager for Vim
" Author:       gmarik
" HomePage:     http://github.com/gmarik/vundle
" Readme:       http://github.com/gmarik/vundle/blob/master/README.md
" Version:      0.7

com! -nargs=+         Bundle
   \ call vundle#config#bundle(<args>)

com! -nargs=? -bang -complete=custom,vundle#scripts#complete BundleInstall
   \ call vundle#installer#install('!' == '<bang>', <q-args>)

com! -nargs=? -bang -complete=custom,vundle#scripts#complete Bundles
   \ call vundle#scripts#all('!'=='<bang>', <q-args>)

com! -nargs=? -bang   BundleClean
   \ call vundle#installer#clean('!' == '<bang>')

com! -nargs=0         BundleDocs 
   \ call vundle#installer#helptags(g:bundles)

" deprecated in favor of Bundles
com! -nargs=? -bang   BundleSearch
   \ call vundle#scripts#all('!' == '<bang>', <q-args>)

func! vundle#rc()
  let g:bundle_dir = expand('$HOME/.vim/bundle')
  call vundle#config#init()
endf
