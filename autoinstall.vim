" This installation script is intended to be loaded from the internet and
" sourced from your vimrc file like this:
"
"   if !fileradable(expand('~/.vim/bundle/Vundle.vim/README.md'))
"     source https://raw.githubusercontent.com/gmarik/Vundle.vim/master/autoinstall.vim
"   endif
"
" This will load the script from github and source it.  If you put the above
" lines in your vimrc file before setting up Vundle.vim you will get an
" automated installation process for every new machine you use your vimrc on.

echomsg 'Starting automatic installation of Vundle.vim.'

" the url of the Vundle.vim repository to clone
let s:clone_uri = 'https://github.com/gmarik/Vundle.vim.git'

" the path to clone Vundle.vim to
if has('unix') " we seem to be on a UNIX compatible system
  let s:path = expand('~/.vim/bundle/Vundle.vim')
elseif has('win32') " we are on some variant of Windows
  let s:path = expand('~/vimfiles/bundle/Vundle.vim')
else
  echoerr 'Your system is not supported.  Sorry.'
  finish
endif

" only clone if the plugin does not yet exist on disk
if !filereadable(s:path.'/README.md')
  call mkdir(s:path, 'p')
  execute '!git clone' s:clone_uri s:path
  if v:shell_error != 0
    echoerr 'Automatic installation of Vundle.vim failed!  Please install manually.'
    finish
  endif
endif

" use an autocmd after startup to install all plugins for the user
augroup VundleAutoInstall
  autocmd!
  autocmd VimEnter * PluginUpdate
augroup END

echomsg 'Installation of Vundle.vim complete.  Plugins will automaticaly be installed after startup.'
