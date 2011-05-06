## About

[Vundle] is a short cut for **V**imb**undle** and is a [Vim] plugin manager.

## Quick start

1. Setup [Vundle]:

        git clone http://github.com/gmarik/vundle.git ~/.vim/vundle.git

2. Configure bundles:

      Sample `.vimrc`:

        set nocompatible               " be iMproved
        filetype off                   " required!

        set rtp+=~/.vim/vundle.git/ 
        call vundle#rc()

        " My Bundles here:
        "
        " original repos on github
        Bundle 'tpope/vim-fugitive'
        Bundle 'lokaltog/vim-easymotion'
        Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
        " vim-scripts repos
        Bundle 'L9'
        Bundle 'FuzzyFinder'
        Bundle 'rails.vim'
        " non github repos
        Bundle 'git://git.wincent.com/command-t.git'
        " ...

        filetype plugin indent on     " required!

3. Install configured bundles:

   Launch `vim`, run `:BundleInstall`. 

   *Windows users* see [Vundle for Windows](https://github.com/gmarik/vundle/wiki/Vundle-for-Windows)

   Installing requires [Git] and triggers [Git clone](http://gitref.org/creating/#clone) for each configured repo to `~/.vim/bundle/`.

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

run [`:helptags ~/.vim/vundle.git/doc`](https://github.com/gmarik/vundle/issues/17)

see [`:h vundle`](vundle/blob/master/doc/vundle.txt#L1) vimdoc for more details.

## Examples

   See [gmarik's vimrc](https://github.com/gmarik/vimfiles/blob/1f4f26d42f54443f1158e0009746a56b9a28b053/vimrc#L136) for working example.

## FAQ

- **Q** i'm aked for username/pass, why?
  **A** Correct invalid bundle name.
  this is the case of invalid name used with `Bundle`, which leads to attemt to clone nonexisting repo:

        git clone http://github.com/gmarik/non_existin_repo
        Cloning into non_existin_repo...
        Username: 
        Password: 
        fatal: Authentication failed

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
* tests
* improve error handling
* put vundle to bundles/ too(will fix vundle help)
* `:VundleUpdate` - self.update
* handle dependencies
* allow specify revision/version?
* search by description aswell
* show descrption in search results
* instead sourcing .vimrc before installation come up with another solution
* make it rock!

[Vundle]:http://github.com/gmarik/vundle
[Pathogen]:http://github.com/tpope/vim-pathogen/
[Bundler]:http://github.com/wycats/bundler/
[Vim]:http://vim.org
[Git]:http://git-scm.com
[all available vim scripts]:http://vim-scripts.org/vim/scripts.html

[install]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L98-112
[update]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L114-119
[search]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L121-143
[clean]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L145-157
[interactive mode]:https://github.com/gmarik/vundle/blob/master/doc/vundle.txt#L160-193
