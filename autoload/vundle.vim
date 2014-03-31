" Vundle        is a shortcut for Vim Bundle and Is a simple plugin manager for Vim
" Author:       gmarik
" HomePage:     http://github.com/gmarik/vundle
" Readme:       http://github.com/gmarik/vundle/blob/master/README.md
" Version:      0.9

" Plugin Commands
com! -nargs=+  -bar   Plugin
\ call vundle#config#bundle(<args>)

com! -nargs=? -bang -complete=custom,vundle#scripts#complete PluginInstall
\ call vundle#installer#new('!' == '<bang>', <q-args>)

com! -nargs=? -bang -complete=custom,vundle#scripts#complete PluginSearch
\ call vundle#scripts#all('!' == '<bang>', <q-args>)

com! -nargs=? -bang -complete=custom,vundle#scripts#complete Plugins
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

" deprecated
com! -nargs=+                                                Bundle        call vundle#config#bundle(<args>)
com! -nargs=? -bang -complete=custom,vundle#scripts#complete BundleInstall PluginInstall<bang> <args>
com! -nargs=? -bang -complete=custom,vundle#scripts#complete BundleSearch  PluginSearch<bang> <args>
com! -nargs=? -bang -complete=custom,vundle#scripts#complete Bundles       Plugins<bang> <args>
com! -nargs=0 -bang                                          BundleList    PluginList<bang>
com! -nargs=? -bang                                          BundleClean   PluginClean<bang>
com! -nargs=0                                                BundleDocs    PluginDocs
com!                                                         BundleUpdate  PluginInstall!

if (has('signs'))
sign define Vu_error    text=!  texthl=Error
sign define Vu_active   text=>  texthl=Comment
sign define Vu_todate   text=.  texthl=Comment
sign define Vu_new      text=+  texthl=Comment
sign define Vu_updated  text=*  texthl=Comment
sign define Vu_deleted  text=-  texthl=Comment
sign define Vu_helptags text=*  texthl=Comment
endif


func! vundle#rc(...) abort
  let g:bundle_dir = len(a:000) > 0 ? expand(a:1, 1) : expand('$HOME/.vim/bundle', 1)
  let g:updated_bundles = []
  let g:vundle_log = []
  let g:vundle_changelog = ['Updated Plugins:']
  call vundle#config#init()
endf
