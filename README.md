## About

[Vundle] is short for _Vim bundle_ and is a [Vim] plugin manager.

![Vundle-installer](http://25.media.tumblr.com/tumblr_m8m96w06G81r39828o1_1280.png)

## Quick start

1. Set up [Vundle]:

   ```
   $ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
   ```

2. Configure bundles:

   Sample `.vimrc`:

   ```vim
   set nocompatible              " be iMproved
   filetype off                  " required!
   
   set rtp+=~/.vim/bundle/vundle/
   call vundle#rc()
   
   " let Vundle manage Vundle
   " required! 
   Bundle 'gmarik/vundle'
   
   " My bundles here:
   "
   " original repos on GitHub
   Bundle 'tpope/vim-fugitive'
   Bundle 'Lokaltog/vim-easymotion'
   Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
   Bundle 'tpope/vim-rails.git'
   " vim-scripts repos
   Bundle 'L9'
   Bundle 'FuzzyFinder'
   " non-GitHub repos
   Bundle 'git://git.wincent.com/command-t.git'
   " Git repos on your local machine (i.e. when working on your own plugin)
   Bundle 'file:///Users/gmarik/path/to/plugin'
   " ...
   
   filetype plugin indent on     " required!
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

3. Install configured bundles:

   Launch `vim`, run `:BundleInstall` 
   (or `vim +BundleInstall +qall` for CLI lovers)

   *Windows users*: see [Vundle for Windows](https://github.com/gmarik/vundle/wiki/Vundle-for-Windows)

   Installation requires [Git] and triggers [`git clone`](http://gitref.org/creating/#clone) for each configured repo to `~/.vim/bundle/`.

4. Consider [donating](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=T44EJZX8RBUWY)

   [*Thank you*](http://j.mp/rSbm01) for supporting this project!


## Why Vundle

[Vundle] allows you to:

- keep track of and configure your scripts right in `.vimrc`
- [install] configured scripts (a.k.a. bundle) 
- [update] configured scripts
- [search] by name [all available Vim scripts]
- [clean] unused scripts up
- run the above actions in a *single keypress* with [interactive mode]

[Vundle] also:

- manages the [runtime path] of your installed scripts
- [regenerates help tags][helptags] automatically

## Docs

See the [`:h vundle`](https://github.com/gmarik/vundle/blob/master/doc/vundle.txt) Vimdoc for more details.

## People using Vundle

see [Examples](https://github.com/gmarik/vundle/wiki/Examples)

## FAQ

see [the wiki](https://github.com/gmarik/vundle/wiki#faq)

## Contributors

see [Vundle contributors](https://github.com/gmarik/vundle/graphs/contributors)

*Thank you!*

## Inspiration and ideas from

* [pathogen.vim]
* [Bundler]
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
[pathogen.vim]:http://github.com/tpope/vim-pathogen/
[Bundler]:https://github.com/bundler/bundler
[Vim]:http://www.vim.org
[Git]:http://git-scm.com
[all available Vim scripts]:http://vim-scripts.org/vim/scripts.html
[helptags]:http://vimdoc.sourceforge.net/htmldoc/helphelp.html#:helptags
[runtime path]:http://vimdoc.sourceforge.net/htmldoc/options.html#%27runtimepath%27

[install]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L115-129
[update]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L131-137
[search]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L139-161
[clean]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L171-L183
[interactive mode]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L186-213
