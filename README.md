## About

[Vundle] is a short cut for **V**imb**undle** and is a [Vim] plugin manager.

## Quick start

1. Setup [Vundle]:

        git clone http://github.com/gmarik/vundle.git ~/.vim/vundle.git

2. Configure bundles:

   Append to your `~/.vimrc`:

        set rtp+=~/.vim/vundle.git/ 
        call vundle#rc()

        " Bundles:
        Bundle "L9"
        Bundle "FuzzyFinder"
        Bundle "rails.vim"
        Bundle "ack.vim"
        Bundle "git://git.wincent.com/command-t.git"
        " ...

3. Install configured bundles:

   Launch `vim`, run `:BundleInstall` (**no `Vim` restart required** since v0.5)

   Installing requires [Git] and triggers [Git clone](http://gitref.org/creating/#clone) for each configured repo to `~/.vim/bundle/`.

## Why Vundle

[Vundle] allows to:

- keep track and configure your scripts right in `.vimrc`
- install configured scripts (aka bundle) 
- update configured scripts
- search [all available vim scripts] by name
- clean unused scripts up

Also as a bonus [Vundle]:

- manages runtime path of your installed scripts
- regenerates helptag atomatically


## Docs

see [`:h vundle`](vundle/blob/master/doc/vundle.txt) vimdoc for more details.

## Examples

   See [gmarik's vimrc](https://github.com/gmarik/vimfiles/blob/1f4f26d42f54443f1158e0009746a56b9a28b053/vimrc#L136) for working example.

## Inspiration and ideas from

* [pathogen]
* [bundler]
* [Scott Bronson](http://github.com/bronson)

## Also

* Vundle was developed and tested in [Vim] 7.3 on `OSX` and `Linux`
* Vundle wasn't tested on windows(so if you care i'm waiting for your pull request)
* Vundle tries to be as [KISS](http://en.wikipedia.org/wiki/KISS_principle) as possible

## TODO:
[Vundle] is a work in progress so any ideas/patches appreciated

* √ activate newly added bundles on .vimrc reload or after :BundleInstall
* √ use preview window for search results
* √ vim documentation
* improve error handling
* allow specify revision/version?
* search by description aswell
* show descrption in search results
* instead sourcing .vimrc before installation come up with another solution
* tests
* make it rock!

[Vundle]:http://github.com/gmarik/vundle
[Pathogen]:http://github.com/tpope/vim-pathogen/
[Bundler]:http://github.com/wycats/bundler/
[Vim]:http://vim.org
[Git]:http://git-scm.com
[all available vim scripts]:http://vim-scripts.org/vim/scripts.html
