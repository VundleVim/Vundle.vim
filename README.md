## About

[Vundle] is a short cut for **V**imb**undle** and is a ~80 LOC plugin for managing [Vim] plugins.


## Installation

    mkdir -p ~/.vim/autoload/ && \
    curl http://github.com/gmarik/vundle/raw/master/autoload/vundle.vim > ~/.vim/autoload/vundle.vim

## Configuration

Add to your <code>~/.vimrc</code>

    call vundle#rc()
    " My bundles
    " Bundle "<git-repo-uri>"
    Bundle "http://github.com/vim-scripts/L9.git"
    Bundle "http://github.com/vim-scripts/FuzzyFinder.git"
    Bundle "git://git.wincent.com/command-t.git"
    Bundle "http://github.com/vim-scripts/rails.vim.git"
    Bundle "http://github.com/vim-scripts/ack.vim.git"
    " check http://vim-scripts.org for more

BTW [Vim-Scripts.org](http://vim-scripts.org) is a git mirror of all vim scripts. See [gmarik's vimrc](http://github.com/gmarik/vimfiles/blob/6926a7e2ba176a292a8e71b6e4c17f15b8eebe04/vimrc#L134) for working example.

## Installing plugins

Launch <code>vim</code> and run <code>:BundleInstall</code>.

Or from command line:

   $ vim  -e -c 'BundleInstall' -c 'q'

triggers [Git clone](http://gitref.org/creating/#clone) for each configured repo to <code>~/.vim/bundle/</code>.

## Inspiration and ideas from

* [pathogen]
* [bundler]
* [Scott Bronson](http://github.com/bronson)

## TODO:

* improve code 
* support non [Git] resources aswell

[Vundle]:http://github.com/gmarik/vundle
[Pathogen]:http://github.com/tpope/vim-pathogen/
[Bundler]:http://github.com/wycats/bundler/
[Vim]:http://vim.org
[Git]:http://git-scm.com
