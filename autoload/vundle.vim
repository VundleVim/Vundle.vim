" Vundle        is a shortcut for Vim Bundle and Is a simple plugin manager for Vim
" Author:       gmarik
" HomePage:     http://github.com/gmarik/vundle
" Readme:       http://github.com/gmarik/vundle/blob/master/README.md
" Version:      0.8

com! -nargs=+ -bang   Bundle
\ call vundle#config#bundle('!' == '<bang>', <args>)

com! -nargs=? -bang -complete=custom,vundle#scripts#complete BundleInstall
\ call vundle#installer#install('!' == '<bang>', <q-args>)

com! -nargs=? -bang -complete=custom,vundle#scripts#complete Bundles
\ call vundle#scripts#all('!'=='<bang>', <q-args>)

com! -nargs=? -bang   BundleClean
\ call vundle#installer#clean('!' == '<bang>')

com! -nargs=0         BundleDocs 
\ call vundle#installer#helptags(g:vundle#bundles)

" deprecated in favor of Bundles
com! -nargs=? -bang   BundleSearch
\ call vundle#scripts#all('!' == '<bang>', <q-args>)


au Filetype  vundle    call vundle#scripts#setup_view()
au Syntax    vim       syn keyword vimCommand Bundle


func! vundle#rc(...) abort
  let g:vundle#bundle_dir = len(a:000) > 0 ? expand(a:1) : expand('$HOME/.vim/bundle')
  call vundle#config#init()
endf

augroup bundle#command-t
  au!
  au User BundleInstallPost echo 'Running command-t hooks'
  au User BundleInstallPost !cd ruby/command-t && ruby extconf.rb && make clean && make
  au User BundleInstallPost ![ -f doc/readme.txt -a -f doc/command-t.txt ] && rm doc/README.txt
  au User BundleInstallPost echohl WarningMsg | echo 'Please restart Vim for command-t to work' | echohl None
augroup end

augroup vundle#bundle
  au!
  au User BundleInstallPre    echo 'Installing '.g:bundle.name
  au User BundleInstall       call vundle#installer#sync(1, g:bundle)
  au User BundleInstall       call vundle#config#configure(g:bundle)
  au User BundleInstallPost   echo 'Installed '.g:bundle.name

  au User BundleInstalled     echo 'Already Installed '.g:bundle.name

  au User BundlesInstallPost  call vundle#config#source(g:bundles)
  au User BundlesInstallPost  call vundle#installer#helptags(g:bundles)
  au User BundlesInstallPost  echo len(g:bundles).' '. "bundles installed"
augroup end
