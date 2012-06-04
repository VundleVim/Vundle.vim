" vim -u test/vimrc
set nocompatible

set nowrap
set et sw=4
set noruler
set laststatus=2
map <F1> :help <c-r><c-w> <CR>
map <F5> :so %<CR>
let mapleader=" "
set bs=start
nno < <<
nno > >>

let root = '~/.vim/bundle'

if !isdirectory(root)
    mkdir(root,'p')
endif

" NOTE: should change 'Rykka/vundle' to the offical repo
let src = 'http://github.com/Rykka/vundle.git' 

" let src = '~/.vim/bundle/vundle/.git' 

" Vundle Options
" let g:vundle_default_git_proto = 'git'

if !isdirectory(root.'\vundle')
  exec '!git clone '.src.' '.shellescape(root.'\vundle', 1)
endif

filetype off
syntax on

runtime macros/matchit.vim

" set it to 1 then vundle will only adding the localbundle dir to &rtp.
let g:vundle_local = 1
" set the default localbundle directory
let g:vundle_local_dir = '~/.vim/localbundle'
if filereadable(expand(g:vundle_local_dir)."/autoload/vundle.vim")
    exe 'set rtp^='.g:vundle_local_dir
    exe 'set rtp+='.g:vundle_local_dir.'/after'
else
    exec 'set rtp+='.root.'/vundle'
endif

call vundle#rc(root)

Bundle "Rykka/vundle"
Bundle 'Rykka/colorv.vim'
Bundle 'Rykka/galaxy.vim'

filetype plugin indent on      " Automatically detect file types.

set wildignore+=doc              " should not break helptags
set wildignore+=.git             " should not break clone
set wildignore+=.git/*             " should not break clone
set wildignore+=*/.git/*
" TODO: helptags fails with this
" set wildignore+=doc/*             " should not break clone
" set wildignore+=*/doc/*

"au VimEnter * BundleInstall

colorscheme galaxy
