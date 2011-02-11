## About

[Vundle] is a short cut for **V**imb**undle** and is a [Vim] plugin manager.

## Why
[Vundle] allows to:

- keep track and configure your scripts right in `.vimrc`
- install configured scripts (aka bundle) 
- search [all available vim scripts] by name
- clean unused scripts up

Also as a bonus [Vundle]:

- manages runtime path of your installed scripts
- regenerates helptag atomatically

[Vundle] takes advantage of [vim-scripts.org](http://vim-scripts.org) 
in order to install/search [all available vim scripts]

## How

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

## Script installation

  `BundleInstall` installs script only if it hasn't been already installed. 
  `BundleInstall` is faster than `BundleInstall!` (note bang at the end) because latter fetches scripts without any checks. 
  Use `BundleInstall` to install new scripts. Use `BundleInstall!` to update scripts.

## Searching

    :BundleSearch foo

lists search results in new split window, ie:

    Bundle "VimFootnotes"
    Bundle "foo.vim"

so you can just copy ones you need to `.vimrc`.

    :BundleSearch! foo

refreshes script list before performing actual search.

Searching requires [`curl`](http://curl.haxx.se/)

## Cleaning up

    :BundleClean

confirms removal of unused script dirs from your `.vim/bundle`. `BundleClean!` does that silently.

## Examples

   See [gmarik's vimrc](https://github.com/gmarik/vimfiles/blob/1f4f26d42f54443f1158e0009746a56b9a28b053/vimrc#L136) for working example.

## Inspiration and ideas from

* [pathogen]
* [bundler]
* [Scott Bronson](http://github.com/bronson)

## Also

* Vundle wasn't tested on windows(so if you care i'm waiting for your pull request)
* Vundle tries to be as [KISS](http://en.wikipedia.org/wiki/KISS_principle) as possible

## TODO:
[Vundle] is a work in progress so any ideas/patches appreciated

* √ activate newly added bundles on .vimrc reload or after :BundleInstall
* √ use preview window for search results
* Vim documentation
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
