" Vundle        is a shortcut for Vim Bundle and Is a simple plugin manager for Vim
" Author:       gmarik
" HomePage:     http://github.com/gmarik/vundle
" Readme:       http://github.com/gmarik/vundle/blob/master/README.md
" Version:      0.5

com! -nargs=+       Bundle                call vundle#config#bundle(<args>)
com! -nargs=? -bang BundleInstall         call vundle#installer#install('<bang>')
com! -nargs=? -bang BundleClean           call vundle#installer#clean('<bang>')
com! -nargs=0       BundleDocs            call vundle#installer#helptags()

com! -nargs=+ -bang BundleSearch  silent  call vundle#scripts#search('<bang>', <q-args>)

com! -nargs=0       VundleLog     silent  pedit `=g:vundle_log`

func! vundle#rc()
  let g:bundle_dir = expand('$HOME/.vim/bundle')
  call vundle#config#init()
endf
