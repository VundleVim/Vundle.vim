Pull Requests
=============

1. Please squash your commits to minimize the log pollution. This is more of a convenience for the maintainer who pulls. If you are unfamiliar, see [here](http://ariejan.net/2011/07/05/git-squash-your-latests-commits-into-one/).

2. Clearly describe what you aim to fix or add to Vundle.

3. Try to minimize code changes and use existing style/functions.

Issues
======

## Check For Answers

Before submitting an issue, be sure to check the following places for answers.

1. Vundle docs at [`:h vundle`](https://github.com/gmarik/Vundle.vim/blob/master/doc/vundle.txt).

2. The [FAQ](https://github.com/gmarik/Vundle.vim/search).

3. [Search](https://github.com/gmarik/Vundle.vim/search) the repository for related issues.

## Try To Eliminate Your Vimrc

In order to make sure it isn't just `.vimrc` replace your own config file with the [minimal vimrc](https://github.com/gmarik/Vundle.vim/blob/master/test/minirc.vim). Clear out bundles and then try to reproduce.

If the problem stops, likely there is an issue in your user configuration. You can incrementally add back your user changes to the minimal file testing the bug each time. This will allow you to slowly bisect the issue. You may want to test one plugin at a time.

If you can still reproduce the problem, try to find the smallest `.vimrc` config file that creates the problem to include later.

## Guidelines

To better respond to issues please follow these general guidelines when explaining the problem.

1. Clearly describe what the error is, if relevant attach output/screenshots.

2. Describe how developers can reproduce the bug, the steps should be from starting Vim.

3. Include your OS, version and architecture. For example, Windows 7 64, Kubuntu 13.04 32, etc...

4. If relevant to reproducing the bug, include the smallest subset of your `.vimrc` that causes the issue. Put this in code tags.

5. At the end of your issue, please put the output of `vim --version` in code tags.

## Example Post

I am using Vim on Kubuntu 13.04 64 bit and I get the following error... (add further explanation here)

To reproduce the bug, use the vimrc file below and run `:BundleInstall`... (continue with steps)

Vimrc:
```
set nocompatible
syntax on
filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()
Bundle 'gmarik/Vundle.vim'
Bundle 'relevant/plugin'
filetype plugin indent on

.... more user configs here...
```

Vim Version:
```
VIM - Vi IMproved 7.4 (2013 Aug 10, compiled Aug 15 2013 10:58:39)
Included patches: 1-5
Modified by pkg-vim-maintainers@lists.alioth.debian.org
Compiled by buildd@
Huge version with GTK2 GUI.  Features included (+) or not (-):
+arabic          +file_in_path    +mouse_sgr       +tag_binary
+autocmd         +find_in_path    -mouse_sysmouse  +tag_old_static
+balloon_eval    +float           +mouse_urxvt     -tag_any_white
+browse          +folding         +mouse_xterm     +tcl
++builtin_terms  -footer          +multi_byte      +terminfo
+byte_offset     +fork()          +multi_lang      +termresponse
+cindent         +gettext         -mzscheme        +textobjects
+clientserver    -hangul_input    +netbeans_intg   +title
+clipboard       +iconv           +path_extra      +toolbar
+cmdline_compl   +insert_expand   +perl            +user_commands
+cmdline_hist    +jumplist        +persistent_undo +vertsplit
+cmdline_info    +keymap          +postscript      +virtualedit
+comments        +langmap         +printer         +visual
+conceal         +libcall         +profile         +visualextra
+cryptv          +linebreak       +python          +viminfo
+cscope          +lispindent      -python3         +vreplace
+cursorbind      +listcmds        +quickfix        +wildignore
+cursorshape     +localmap        +reltime         +wildmenu
+dialog_con_gui  +lua             +rightleft       +windows
+diff            +menu            +ruby            +writebackup
+digraphs        +mksession       +scrollbind      +X11
+dnd             +modify_fname    +signs           -xfontset
-ebcdic          +mouse           +smartindent     +xim
+emacs_tags      +mouseshape      -sniff           +xsmp_interact
+eval            +mouse_dec       +startuptime     +xterm_clipboard
+ex_extra        +mouse_gpm       +statusline      -xterm_save
+extra_search    -mouse_jsbterm   -sun_workshop
+farsi           +mouse_netterm   +syntax
   system vimrc file: "$VIM/vimrc"
     user vimrc file: "$HOME/.vimrc"
 2nd user vimrc file: "~/.vim/vimrc"
      user exrc file: "$HOME/.exrc"
  system gvimrc file: "$VIM/gvimrc"
    user gvimrc file: "$HOME/.gvimrc"
2nd user gvimrc file: "~/.vim/gvimrc"
    system menu file: "$VIMRUNTIME/menu.vim"
  fall-back for $VIM: "/usr/share/vim"
Compilation: gcc -c -I. -Iproto -DHAVE_CONFIG_H -DFEAT_GUI_GTK  -pthread -I/usr/include/gtk-2.0 -I/usr/lib/x86_64-linux-gnu/gtk-2.0/include -I/usr/include/atk-1.0 -I/usr/include/cairo -I/usr/include/gdk-pixbuf-2.0 -I/usr/include/pango-1.0 -I/usr/include/gio-unix-2.0/ -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include -I/usr/include/pixman-1 -I/usr/include/freetype2 -I/usr/include/libpng12 -I/usr/include/harfbuzz     -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1     -I/usr/include/tcl8.5  -D_REENTRANT=1  -D_THREAD_SAFE=1  -D_LARGEFILE64_SOURCE=1
Linking: gcc   -L. -Wl,-Bsymbolic-functions -Wl,-z,relro -rdynamic -Wl,-export-dynamic -Wl,-E  -Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,--as-needed -o vim   -lgtk-x11-2.0 -lgdk-x11-2.0 -latk-1.0 -lgio-2.0 -lpangoft2-1.0 -lpangocairo-1.0 -lgdk_pixbuf-2.0 -lcairo -lpango-1.0 -lfreetype -lfontconfig -lgobject-2.0 -lglib-2.0   -lSM -lICE -lXpm -lXt -lX11 -lXdmcp -lSM -lICE  -lm -ltinfo -lnsl  -lselinux  -lacl -lattr -lgpm -ldl  -L/usr/lib -llua5.1 -Wl,-E  -fstack-protector -L/usr/local/lib  -L/usr/lib/perl/5.14/CORE -lperl -ldl -lm -lpthread -lcrypt -L/usr/lib/python2.7/config-x86_64-linux-gnu -lpython2.7 -lpthread -ldl -lutil -lm -Xlinker -export-dynamic -Wl,-O1 -Wl,-Bsymbolic-functions  -L/usr/lib/x86_64-linux-gnu -ltcl8.5 -ldl -lpthread -lieee -lm -lruby-1.9.1 -lpthread -lrt -ldl -lcrypt -lm  -L/usr/lib
```
