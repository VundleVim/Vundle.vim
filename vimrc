set nocompatible              
   filetype off               

   set rtp+=~/.vim/bundle/Vundle.vim
   call vundle#begin()

   Plugin 'VundleVim/Vundle.vim'  
   Plugin 'lrvick/Conque-Shell'
   Plugin 'scrooloose/nerdtree'
   Plugin 'maksimr/vim-jsbeautify'
   Plugin 'einars/js-beautify'
   Plugin 'altercation/vim-colors-solarized'
   Plugin '2072/PHP-Indenting-for-VIm'
   Plugin 'scrooloose/nerdcommenter'
   Plugin 'yegappan/greplace'
   Plugin 'yegappan/grep'
   Plugin 'joonty/vdebug' 
   Plugin 'kien/ctrlp.vim'
   Plugin 'kchmck/vim-coffee-script'   
   Plugin 'tpope/vim-fugitive'
   Plugin 'groenewege/vim-less'

   call vundle#end()     
   filetype plugin on

   
   syntax enable 
   set t_Co=256
   let g:solarized_termcolors=16
   set background=dark
   colorscheme solarized

function ClearReg()
  let regs='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"' 
  let i=0 
  while (i<strlen(regs)) 
    exec 'let @'.regs[i].'=""' 
    let i=i+1 
  endwhile 
  unlet regs 
endfunction
