## About

[Vundle] is short for **V**imb**undle** and is a [Vim] plugin manager.

![Vundle-installer](https://lh3.googleusercontent.com/-4EnLqLpEZlk/TlqXWpgWxOI/AAAAAAAAHRw/oBAl6s1hj7U/vundle-install2.png)

## Quick start

1. Setup [Vundle]:

     ```
     $ git clone http://github.com/gmarik/vundle.git ~/.vim/vundle/vundle
     ```

2. Configure vundles:

     Sample `.vimrc`:

     ```vim
     set nocompatible               " be iMproved
     filetype off                   " required!

     set rtp+=~/.vim/vundle/vundle/
     call vundle#rc()

     " let Vundle manage Vundle
     " required!
     Vundle 'gmarik/vundle'

     " My Vundles here:
     "
     " original repos on github
     Vundle 'tpope/vim-fugitive'
     Vundle 'Lokaltog/vim-easymotion'
     Vundle 'rstacruz/sparkup', {'rtp': 'vim/'}
     " vim-scripts repos
     Vundle 'L9'
     Vundle 'FuzzyFinder'
     Vundle 'rails.vim'
     " non github repos
     Vundle 'git://git.wincent.com/command-t.git'
     " ...

     filetype plugin indent on     " required!
     "
     " Brief help
     " :VundleList          - list configured vundles
     " :VundleInstall(!)    - install(update) vundles
     " :VundleSearch(!) foo - search(or refresh cache first) for foo
     " :VundleClean(!)      - confirm(or auto-approve) removal of unused vundles
     "
     " see :h vundle for more details or wiki for FAQ
     " NOTE: comments after Vundle command are not allowed..

     ```

3. Install configured vundles:

     Launch `vim`, run `:VundleInstall`.

     *Windows users* see [Vundle for Windows](https://github.com/gmarik/vundle/wiki/Vundle-for-Windows)

     Installing requires [Git] and triggers [Git clone](http://gitref.org/creating/#clone) for each configured repo to `~/.vim/vundle/`.

## Why Vundle

[Vundle] allows to:

- keep track and configure your scripts right in `.vimrc`
- [install] configured scripts (aka bundle)
- [update] configured scripts
- [search] by name [all available vim scripts]
- [clean] unused scripts up
- run above actions in a *single keypress* with [interactive mode]

Also [Vundle]:

- manages runtime path of your installed scripts
- regenerates helptag atomatically

## Docs

see [`:h vundle`](vundle/blob/master/doc/vundle.txt#L1) vimdoc for more details.

## Examples

   See [gmarik's vimrc](https://github.com/gmarik/vimfiles/blob/1f4f26d42f54443f1158e0009746a56b9a28b053/vimrc#L136) for working example.

   If you have an interesting example, feel free to send a pull request with link to your config. Thx!

## FAQ

see [wiki](/gmarik/vundle/wiki)

## Contributors

* [redlinesoftware](http://redlinesoftware.com) - for lending me 24" monitor!
* [Marc Jeanson](https://github.com/marcjeanson) - vim dude I always bug for help...;)
* [Brad Anderson](http://github.com/eco) (windows support)
* [Ryan W](http://github.com/rygwdn)
* [termac](http://github.com/termac)
* and others

*Thank you!*

## Inspiration and ideas from

* [pathogen]
* [bundler]
* [Scott Bronson](http://github.com/bronson)

## Also

* Vundle was developed and tested with [Vim] 7.3 on `OSX`, `Linux` and `Windows`
* Vundle tries to be as [KISS](http://en.wikipedia.org/wiki/KISS_principle) as possible

## TODO:
[Vundle] is a work in progress so any ideas/patches appreciated

* √ activate newly added vundles on .vimrc reload or after :VundleInstall
* √ use preview window for search results
* √ vim documentation
* √ put vundle to vundles/ too(will fix vundle help)
* √ tests
* √ improve error handling
* allow specify revision/version?
* handle dependencies
* show description in search results
* search by description as well
* make it rock!

[Vundle]:http://github.com/gmarik/vundle
[Pathogen]:http://github.com/tpope/vim-pathogen/
[Bundler]:http://github.com/wycats/bundler/
[Vim]:http://vim.org
[Git]:http://git-scm.com
[all available vim scripts]:http://vim-scripts.org/vim/scripts.html

[install]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L110-124
[update]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L128-133
[search]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L135-157
[clean]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L167-179
[interactive mode]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L183-209
