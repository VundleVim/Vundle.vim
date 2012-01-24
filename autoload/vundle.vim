" Vundle        is a shortcut for Vim Bundle and Is a simple plugin manager for Vim
" Author:       gmarik
" HomePage:     http://github.com/gmarik/vundle
" Readme:       http://github.com/gmarik/vundle/blob/master/README.md
" Version:      0.9

com! -nargs=+         Bundle
\ call vundle#config#bundle(<args>)

com! -nargs=+         BundleLoad
\ call vundle#installer#load(<args>)

com! -nargs=? -bang -complete=custom,vundle#scripts#complete BundleInstall
\ call vundle#installer#new('!' == '<bang>', <q-args>)

com! -nargs=? -bang -complete=custom,vundle#scripts#complete BundleSearch
\ call vundle#scripts#all('!'=='<bang>', <q-args>)

com! -nargs=? -bang -complete=custom,vundle#scripts#complete Bundles
\ call vundle#scripts#all('!'=='<bang>', <q-args>)

com! -nargs=0 -bang BundleList
\ call vundle#installer#list('!'=='<bang>')

com! -nargs=? -bang   BundleClean
\ call vundle#installer#clean('!' == '<bang>')

com! -nargs=0         BundleDocs 
\ call vundle#installer#helptags(g:bundles)


if (has('signs'))
sign define Vu_error    text=!  texthl=Error
sign define Vu_active   text=>  texthl=Comment
sign define Vu_todate   text=.  texthl=Comment
sign define Vu_updated  text=+  texthl=Comment
sign define Vu_deleted  text=-  texthl=Comment
endif


func! vundle#rc(...) abort
  let g:bundle_dir = len(a:000) > 0 ? expand(a:1, 1) : expand('$HOME/.vim/bundle', 1)
  let g:vundle_log = []
  call vundle#config#init()
endf
