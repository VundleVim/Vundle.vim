## About

[Vundle] is short for **V**imb**undle** and is a [Vim] plugin manager.

![Vundle-installer](https://lh3.googleusercontent.com/-4EnLqLpEZlk/TlqXWpgWxOI/AAAAAAAAHRw/oBAl6s1hj7U/vundle-install2.png)

## Quick start

1. Setup [Vundle]:

     ```
     $ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
     ```

2. Configure bundles:

     Sample `.vimrc`:

     ```vim
     set nocompatible               " be iMproved
     filetype off                   " required!

     set rtp+=~/.vim/bundle/vundle/
     call vundle#rc()

     " let Vundle manage Vundle
     " required! 
     Bundle 'gmarik/vundle'

     " My Bundles here:
     "
     " original repos on github
     Bundle 'tpope/vim-fugitive'
     Bundle 'Lokaltog/vim-easymotion'
     Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
     Bundle 'tpope/vim-rails.git'
     " vim-scripts repos
     Bundle 'L9'
     Bundle 'FuzzyFinder'
     " non github repos
     Bundle 'git://git.wincent.com/command-t.git'
     " ...

     filetype plugin indent on     " required!
     "
     " Brief help
     " :BundleList          - list configured bundles
     " :BundleInstall(!)    - install(update) bundles
     " :BundleSearch(!) foo - search(or refresh cache first) for foo
     " :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
     "
     " see :h vundle for more details or wiki for FAQ
     " NOTE: comments after Bundle command are not allowed..

     ```

3. Install configured bundles:

     Launch `vim`, run `:BundleInstall` 
     (or `vim +BundleInstall +qall` for CLI lovers)

     *Windows users* see [Vundle for Windows](https://github.com/gmarik/vundle/wiki/Vundle-for-Windows)

     Installing requires [Git] and triggers [Git clone](http://gitref.org/creating/#clone) for each configured repo to `~/.vim/bundle/`.

4. Consider [donating](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=T44EJZX8RBUWY)

[*Thank you*](http://j.mp/rSbm01) for supporting this project! )


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
- regenerates helptag automatically

## Docs

see [`:h vundle`](vundle/blob/master/doc/vundle.txt#L1) vimdoc for more details.

## People Using Vundle

   * [gmarik's vimrc](https://github.com/gmarik/vimfiles/blob/1f4f26d42f54443f1158e0009746a56b9a28b053/vimrc#L136)
   * [mutewinter's Vim Config of Champions](https://github.com/mutewinter/dot_vim)
   * [vimified - Ultimate, kick-ass VIM configuration on top of Vundle](https://github.com/zaiste/vimified)

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

* √ activate newly added bundles on .vimrc reload or after :BundleInstall
* √ use preview window for search results
* √ vim documentation
* √ put vundle to bundles/ too(will fix vundle help)
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
[update]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L128-134
[search]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L136-158
[clean]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L168-180
[interactive mode]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L184-210
