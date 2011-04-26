" Vundle        is a shortcut for Vim Bundle and Is a simple plugin manager for Vim
" Author:       gmarik
" HomePage:     http://github.com/gmarik/vundle
" Readme:       http://github.com/gmarik/vundle/blob/master/README.md
" Version:      0.8

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


au Filetype  vundle    call vundle#scripts#setup_view()
au Syntax    vim       syn keyword vimCommand Bundle


func! vundle#rc(...) abort
  let g:bundle_dir = len(a:000) > 0 ? expand(a:1) : expand('$HOME/.vim/bundle')
  call vundle#config#init()
endf
