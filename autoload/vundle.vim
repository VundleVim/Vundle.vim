" Vundle        is a shortcut for Vim Bundle and Is a simple plugin manager for Vim
" Author:       gmarik
" HomePage:     http://github.com/gmarik/vundle
" Readme:       http://github.com/gmarik/vundle/blob/master/README.md
" Version:      0.8

com! -nargs=+         Vundle
\ call vundle#config#vundle(<args>)

com! -nargs=? -bang -complete=custom,vundle#scripts#complete VundleInstall
\ call vundle#installer#new('!' == '<bang>', <q-args>)

com! -nargs=? -bang -complete=custom,vundle#scripts#complete VundleSearch
\ call vundle#scripts#all('!'=='<bang>', <q-args>)

com! -nargs=? -bang -complete=custom,vundle#scripts#complete Vundles
\ call vundle#scripts#all('!'=='<bang>', <q-args>)

com! -nargs=0 -bang VundleList
\ call vundle#installer#list('!'=='<bang>')

com! -nargs=? -bang   VundleClean
\ call vundle#installer#clean('!' == '<bang>')

com! -nargs=0         VundleDocs
\ call vundle#installer#helptags(g:vundles)


if (has('signs'))
sign define Vu_error    text=!  texthl=Error
sign define Vu_active   text=>  texthl=Comment
sign define Vu_todate   text=.  texthl=Comment
sign define Vu_updated  text=+  texthl=Comment
sign define Vu_deleted  text=-  texthl=Comment
endif


func! vundle#rc(...) abort
  let g:vundle_dir = len(a:000) > 0 ? expand(a:1) : expand('$HOME/.vim/vundle')
  let g:vundle_log = []
  call vundle#config#init()
endf
