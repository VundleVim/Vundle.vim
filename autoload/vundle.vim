" Vundle        is a shortcut for Vim Bundle and Is a simple plugin manager for Vim
" Author:       gmarik
" HomePage:     http://github.com/gmarik/Vundle.vim
" Readme:       http://github.com/gmarik/Vundle.vim/blob/master/README.md
" Version:      0.10.2

" Plugin Commands
com! -nargs=+  -bar   Plugin
\ call vundle#config#bundle(<args>)

com! -nargs=? -bang -complete=custom,vundle#scripts#complete PluginInstall
\ call vundle#installer#new('!' == '<bang>', <q-args>)

com! -nargs=? -bang -complete=custom,vundle#scripts#complete PluginSearch
\ call vundle#scripts#all('!' == '<bang>', <q-args>)

com! -nargs=0 -bang PluginList
\ call vundle#installer#list('!' == '<bang>')

com! -nargs=? -bang   PluginClean
\ call vundle#installer#clean('!' == '<bang>')

com! -nargs=0         PluginDocs
\ call vundle#installer#helptags(g:bundles)

" Aliases
com! PluginUpdate PluginInstall!

" Vundle Aliases
com! -nargs=? -bang -complete=custom,vundle#scripts#complete VundleInstall PluginInstall<bang> <args>
com! -nargs=? -bang -complete=custom,vundle#scripts#complete VundleSearch  PluginSearch<bang> <args>
com! -nargs=? -bang                                          VundleClean   PluginClean<bang>
com! -nargs=0                                                VundleDocs    PluginDocs
com!                                                         VundleUpdate  PluginInstall!

" Deprecated Commands
com! -nargs=+                                                Bundle        call vundle#config#bundle(<args>)
com! -nargs=? -bang -complete=custom,vundle#scripts#complete BundleInstall PluginInstall<bang> <args>
com! -nargs=? -bang -complete=custom,vundle#scripts#complete BundleSearch  PluginSearch<bang> <args>
com! -nargs=0 -bang                                          BundleList    PluginList<bang>
com! -nargs=? -bang                                          BundleClean   PluginClean<bang>
com! -nargs=0                                                BundleDocs    PluginDocs
com!                                                         BundleUpdate  PluginInstall!

" Set up the signs used in the installer window. (See :help signs)
if (has('signs'))
  sign define Vu_error    text=!  texthl=Error
  sign define Vu_active   text=>  texthl=Comment
  sign define Vu_todate   text=.  texthl=Comment
  sign define Vu_new      text=+  texthl=Comment
  sign define Vu_updated  text=*  texthl=Comment
  sign define Vu_deleted  text=-  texthl=Comment
  sign define Vu_helptags text=*  texthl=Comment
  sign define Vu_pinned   text==  texthl=Comment
endif

" Set up Vundle.  This function has to be called from the users vimrc file.
" This will force Vim to source this file as a side effect which wil define
" the :Plugin command.  After calling this function the user can use the
" :Plugin command in the vimrc.  It is not possible to do this automatically
" because when loading the vimrc file no plugins where loaded yet.
func! vundle#rc(...) abort
  let g:bundle_dir = len(a:000) > 0 ? expand(a:1, 1) : expand('$HOME/.vim/bundle', 1)
  let g:updated_bundles = []
  let g:vundle_log = []
  let g:vundle_changelog = ['Updated Plugins:']
  call vundle#config#init()
endf

" Alternative to vundle#rc, offers speed up by modifying rtp only when end()
" called later.
func! vundle#begin(...) abort
  let g:vundle_lazy_load = 1
  call call('vundle#rc', a:000)
endf

" Finishes putting plugins on the rtp.
func! vundle#end(...) abort
  unlet g:vundle_lazy_load
  call vundle#config#activate_bundles()
endf

" vim: set expandtab sts=2 ts=2 sw=2 tw=78 norl:
