" vundle.vim  - is a shortcut for Vim Bundle and Is a simple plugin manager for Vim
" Maintainer:   http://github.com/gmarik
" Version:      0.2
" Readme:       http://github.com/gmarik/vundle/blob/master/README.md

com! -nargs=+ Bundle        call vundle#add_bundle(<args>)
com! -nargs=0 BundleInstall call vundle#install_bundles()
com! -nargs=0 BundleDocs    call vundle#helptagify_bundles()

com! -nargs=* BundleSearch  silent call vundle#scripts#search(<q-args>)

func! vundle#rc()
  let g:bundle_dir = expand('$HOME/.vim/bundle/')
  let g:bundles = []
endf

func! vundle#add_bundle(...)
  let [arg; rest] = a:000 | let opts = {}
  if len(rest) == 1 | let opts = rest[0] | endif
  " try 
    let bundle = vundle#new_bundle(arg, opts)
    call vundle#require_bundle(bundle)
  " catch | echo 'Error: loadin '.arg | endtry
endf

func! vundle#init_bundle(arg, opts)
  let bundle = a:opts | let arg = a:arg
  if arg =~ '^\s*\(git@\|git://\)\S\+' || arg =~ 'https\?://' || arg =~ '\.git\*$'
    let bundle.uri = arg
    let bundle.name = substitute(split(bundle.uri,'\/')[-1], '\.git\s*$','','i')
  else
    let bundle.name = arg
    let bundle.uri  = vundle#script_uri(bundle.name)
  endif
  return bundle
endf

func! vundle#script_uri(name) 
  return 'http://github.com/vim-scripts/'.a:name.'.git'
endf

func! vundle#new_bundle(arg, opts)
  let bundle = vundle#init_bundle(a:arg, a:opts)
  let bundle.path = expand(g:bundle_dir.''.bundle.name)
  let bundle.rtpath = has_key(bundle, 'rtp') ? join([bundle.path, bundle.rtp], '/') : bundle.path
  call add(g:bundles, bundle)
  return bundle
endf

func! vundle#require_bundle(bundle)
  let dir = a:bundle.rtpath
  exec 'set rtp^='.dir
  let after = expand(dir.'/after') | if isdirectory(after) 
    exec 'set rtp+='.after 
  endif
endf

func! vundle#install_bundles()
  silent source ~/.vimrc
  exec '!mkdir -p '.g:bundle_dir
  call vundle#sync_bundles()
  call vundle#helptagify_bundles()
endf

func! vundle#sync_bundles()
  for bundle in g:bundles
    let git_dir = bundle.path.'/.git'
    let cmd = isdirectory(git_dir) ?  
          \ '--git-dir='.git_dir.' pull' : 
          \ 'clone '.bundle.uri.' '.bundle.path
    exec '!echo -ne "* '.bundle.name.'"'
    exec '!git '.cmd
  endfor
endf

func! vundle#helptagify_bundles()
  for bundle in g:bundles
    let dir = bundle.rtpath
    if isdirectory(dir.'/doc') && (!filereadable(dir.'/doc/tags') || filewritable(dir.'/doc/tags'))
      helptags `=dir.'/doc'`
    endif
  endfor
endf

