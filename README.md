## About

** Warning: alpha quality **

[Vundle] is a short cut for [V](#)imb[undle](#) and is a 67 LOC plugin for managing [Vim] plugins.


## Installation

    mkdir -p ~/.vim/autoload/ && \
    curl http://github.com/gmarik/vundle/raw/master/autoload/vundle.vim > ~/.vim/autoload/vundle.vim

## Configuration

Configure required plugins in <code>~/.vim/bundlerc</code>, ie like this:

    cat > ~/.vim/bundlerc <<EOF 
    " Bundle "<git-repo-uri>"
    Bundle "http://github.com/vim-scripts/L9.git"
    Bundle "http://github.com/vim-scripts/FuzzyFinder.git"
    Bundle "git://git.wincent.com/command-t.git"
    Bundle "http://github.com/vim-scripts/rails.vim.git"
    Bundle "http://github.com/vim-scripts/ack.vim.git"
    " check http://vim-scripts.org for more
    EOF

BTW [Vim-Scripts.org](http://vim-scripts.org) is a git mirror of all vim scripts. Se [gmarik's bubdlerc](http://github.com/gmarik/vimfiles/raw/master/bundlerc) for working example.

Add to your <code>.vimrc</code>

    call vundle#rc()

## Installing plugins

    vim  -e -c 'BundleInstall' -c 'q'

triggers [Git clone](http://gitref.org/creating/#clone) for each configured repo to <code>~/.vim/bundle/</code>.

## Thanks

* [Pathogen]
* [Bundler]

## TODO:

* improve code (as this is my first [Vim] plugin
* support non [Git] resources aswell

[Vundle]:http://github.com/gmarik/vundle
[Pathogen]:http://github.com/tpope/vim-pathogen/
[Bundler]:http://github.com/wycats/bundler/
[Vim]:http://vim.org
[Git]:http://git-scm.com
