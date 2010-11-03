## About

[Vundle] is a short cut for **V**imb**undle** and is a small plugin for managing [Vim] plugins.

## Why
[Vundle] can:

- automatically install vim script (aka bundle) 
- manage runtime path of your installed scripts so you don't have to
- disable/enable bundles by commenting/uncommenting configured Bundle(requires reload)
- NEW: search [all available vim scripts] by name

[Vundle] takes advantage of [vim-scripts.org](http://vim-scripts.org) 
in order to install/search [all available vim scripts]

## How

1. Setup [Vundle]:

        git clone http://github.com/gmarik/vundle.git ~/.vim/vundle.git

2. Configure bundles:

   Add to your <code>~/.vimrc</code>:

        set rtp+=~/.vim/vundle.git/ 
        call vundle#rc()

        " My bundles
        Bundle "L9"
        Bundle "FuzzyFinder"
        Bundle "rails.vim"
        Bundle "ack.vim"
        Bundle "git://git.wincent.com/command-t.git"
        " check http://vim-scripts.org for more

3. Install configured bundles:

   Launch <code>vim</code> and run <code>:BundleInstall</code>.

   Or from command line:

        $ vim  -e -c 'BundleInstall' -c 'q'

   triggers [Git clone](http://gitref.org/creating/#clone) for each configured repo to <code>~/.vim/bundle/</code>.

   See [gmarik's vimrc](https://github.com/gmarik/vimfiles/blob/1f4f26d42f54443f1158e0009746a56b9a28b053/vimrc#L136) for working example.

## Searching

    :BundleSearch foo

Will split new window with results:

    Bundle "VimFootnotes"
    Bundle "foo.vim"

So you can just copy one you need to you <code>.vimrc</code>

## Inspiration and ideas from

* [pathogen]
* [bundler]
* [Scott Bronson](http://github.com/bronson)

## TODO:
[Vundle] is a work in progress so any ideas/patches appreciated

* tests
* allow specify revision/version?
* activate newly added bundles on .vimrc reload
* search by description aswell
* show descrption in search results
* use location list/quick fix list for search results
* make it rock!

[Vundle]:http://github.com/gmarik/vundle
[Pathogen]:http://github.com/tpope/vim-pathogen/
[Bundler]:http://github.com/wycats/bundler/
[Vim]:http://vim.org
[Git]:http://git-scm.com
[all available vim scripts]:http://vim-scripts.org/scripts.html
