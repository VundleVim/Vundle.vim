## [Help Maintain Vundle](https://github.com/gmarik/Vundle.vim/issues/241)

## About

[Vundle] is short for _Vim bundle_ and is a [Vim] plugin manager.

[Vundle] allows you to...

* keep track of and configure your scripts right in the `.vimrc`
* [install] configured scripts (a.k.a. bundle)
* [update] configured scripts
* [search] by name all available [Vim scripts]
* [clean] unused scripts up
* run the above actions in a *single keypress* with [interactive mode]

[Vundle] automatically...

* manages the [runtime path] of your installed scripts
* regenerates [help tags] after installing and updating

![Vundle-installer](http://25.media.tumblr.com/tumblr_m8m96w06G81r39828o1_1280.png)

## Quick Start

1. Introduction:

   Installation requires [Git] and triggers [`git clone`] for each configured repository to `~/.vim/bundle/` by default.

   If you are using Windows, go directly to [Windows setup]. If you run into any issues, please consult the [FAQ].

2. Set up [Vundle]:

   `$ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle`

3. Configure Bundles:

   Put this at the top of your `.vimrc` to use Vundle. Remove bundles you don't need, they are for illustration purposes.

   ```vim
   set nocompatible              " be iMproved, required
   filetype off                  " required

   " set the runtime path to include Vundle and initialize
   set rtp+=~/.vim/bundle/vundle/
   call vundle#rc()
   " alternatively, pass a path where Vundle should install bundles
   "let path = '~/some/path/here'
   "call vundle#rc(path)

   " let Vundle manage Vundle, required
   Bundle 'gmarik/vundle'

   " The following are examples of different formats supported.
   " Keep bundle commands between here and filetype plugin indent on.
   " scripts on GitHub repos
   Bundle 'tpope/vim-fugitive'
   Bundle 'Lokaltog/vim-easymotion'
   Bundle 'tpope/vim-rails.git'
   " The sparkup vim script is in a subdirectory of this repo called vim.
   " Pass the path to set the runtimepath properly.
   Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
   " scripts from http://vim-scripts.org/vim/scripts.html
   Bundle 'L9'
   Bundle 'FuzzyFinder'
   " scripts not on GitHub
   Bundle 'git://git.wincent.com/command-t.git'
   " git repos on your local machine (i.e. when working on your own plugin)
   Bundle 'file:///home/gmarik/path/to/plugin'
   " ...

   filetype plugin indent on     " required
   "
   " Brief help
   " :BundleList          - list configured bundles
   " :BundleInstall(!)    - install (update) bundles
   " :BundleSearch(!) foo - search (or refresh cache first) for foo
   " :BundleClean(!)      - confirm (or auto-approve) removal of unused bundles
   "
   " see :h vundle for more details or wiki for FAQ
   " NOTE: comments after Bundle commands are not allowed.
   ```

4. Install Bundles:

   Launch `vim` and  run `:BundleInstall`

   To install from command line: `vim +BundleInstall +qall`

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

* ✓ activate newly added bundles on `.vimrc` reload or after `:BundleInstall`
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

[install]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L115-129
[update]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L131-137
[search]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L139-161
[clean]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L171-L183
[interactive mode]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L186-213
