## [Help Maintain Vundle](https://github.com/gmarik/Vundle.vim/issues/241)

## About

[Vundle] is short for _Vim bundle_ and is a [Vim] plugin manager.

[Vundle] allows you to...

* keep track of and [configure] your plugins right in the `.vimrc`
* [install] configured plugins (a.k.a. scripts/bundle)
* [update] configured plugins
* [search] by name all available [Vim scripts]
* [clean] unused plugins up
* run the above actions in a *single keypress* with [interactive mode]

[Vundle] automatically...

* manages the [runtime path] of your installed scripts
* regenerates [help tags] after installing and updating

[Vundle] is undergoing an [interface change], please stay up to date to get latest changes.

![Vundle-installer](http://25.media.tumblr.com/tumblr_m8m96w06G81r39828o1_1280.png)

## Quick Start

1. Introduction:

   Installation requires [Git] and triggers [`git clone`] for each configured repository to `~/.vim/bundle/` by default.
   Curl is required for search.

   If you are using Windows, go directly to [Windows setup]. If you run into any issues, please consult the [FAQ].

2. Set up [Vundle]:

   `$ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle`

3. Configure Plugins:

   Put this at the top of your `.vimrc` to use Vundle. Remove plugins you don't need, they are for illustration purposes.

   ```vim
   set nocompatible              " be iMproved, required
   filetype off                  " required

   " set the runtime path to include Vundle and initialize
   set rtp+=~/.vim/bundle/vundle/
   call vundle#rc()
   " alternatively, pass a path where Vundle should install plugins
   "let path = '~/some/path/here'
   "call vundle#rc(path)

   " let Vundle manage Vundle, required
   Plugin 'gmarik/vundle'

   " The following are examples of different formats supported.
   " Keep Plugin commands between here and filetype plugin indent on.
   " scripts on GitHub repos
   Plugin 'tpope/vim-fugitive'
   Plugin 'Lokaltog/vim-easymotion'
   Plugin 'tpope/vim-rails.git'
   " The sparkup vim script is in a subdirectory of this repo called vim.
   " Pass the path to set the runtimepath properly.
   Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
   " scripts from http://vim-scripts.org/vim/scripts.html
   Plugin 'L9'
   Plugin 'FuzzyFinder'
   " scripts not on GitHub
   Plugin 'git://git.wincent.com/command-t.git'
   " git repos on your local machine (i.e. when working on your own plugin)
   Plugin 'file:///home/gmarik/path/to/plugin'
   " ...

   filetype plugin indent on     " required
   " To ignore plugin indent changes, instead use:
   "filetype plugin on
   "
   " Brief help
   " :PluginList          - list configured plugins
   " :PluginInstall(!)    - install (update) plugins
   " :PluginSearch(!) foo - search (or refresh cache first) for foo
   " :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
   "
   " see :h vundle for more details or wiki for FAQ
   " NOTE: comments after Plugin commands are not allowed.
   " Put your stuff after this line
   ```

4. Install Plugins:

   Launch `vim` and  run `:PluginInstall`

   To install from command line: `vim +PluginInstall +qall`

## Docs

See the [`:h vundle`](https://github.com/gmarik/vundle/blob/master/doc/vundle.txt) Vimdoc for more details.

## People Using Vundle

see [Examples](https://github.com/gmarik/vundle/wiki/Examples)

## Contributors

see [Vundle contributors](https://github.com/gmarik/vundle/graphs/contributors)

*Thank you!*

## Inspiration & Ideas

* [pathogen.vim](http://github.com/tpope/vim-pathogen/)
* [Bundler](https://github.com/bundler/bundler)
* [Scott Bronson](http://github.com/bronson)

## Also

* Vundle was developed and tested with [Vim] 7.3 on OS X, Linux and Windows
* Vundle tries to be as [KISS](http://en.wikipedia.org/wiki/KISS_principle) as possible

## TODO:
[Vundle] is a work in progress, so any ideas and patches are appreciated.

* ✓ activate newly added bundles on `.vimrc` reload or after `:PluginInstall`
* ✓ use preview window for search results
* ✓ Vim documentation
* ✓ put Vundle in `bundles/` too (will fix Vundle help)
* ✓ tests
* ✓ improve error handling
* allow specifying revision/version?
* handle dependencies
* show description in search results
* search by description as well
* make it rock!

[Vundle]:http://github.com/gmarik/vundle
[Windows setup]:https://github.com/gmarik/vundle/wiki/Vundle-for-Windows
[FAQ]:https://github.com/gmarik/vundle/wiki
[Vim]:http://www.vim.org
[Git]:http://git-scm.com
[`git clone`]:http://gitref.org/creating/#clone

[Vim scripts]:http://vim-scripts.org/vim/scripts.html
[help tags]:http://vimdoc.sourceforge.net/htmldoc/helphelp.html#:helptags
[runtime path]:http://vimdoc.sourceforge.net/htmldoc/options.html#%27runtimepath%27

[configure]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L122-L205
[install]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L207-L226
[update]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L228-L237
[search]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L239-L267
[clean]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L276-L289
[interactive mode]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L292-L331
[interface change]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L345-L369
