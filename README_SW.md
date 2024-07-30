## [Saidia Kurekebisha Vundle](https://github.com/VundleVim/Vundle.vim/issues/383)

## Yaliyomo

- [Kuhusu](#kuhusu)
- [Kuanza](#kuanza)
- [Nyaraka](#nyaraka)
- [Mabadiliko](#mabadiliko)
- [Watu Wanao Tumia Vundle](#watu-wanao-tumia-vundle)
- [Wachangiaji](#wachangiaji)
- [Uvuvio & Mawazo](#uvuvio--mawazo)
- [Pia](#pia)
- [Chakufanya](#chakufanya)

## Kuhusu

<hr />

[Vundle](https://github.com/VundleVim/Vundle.vim) ni kifupisho cha Vim bundle na pia ni plugin ya kumanage [Vim.](https://www.vim.org/)

[Vundle](https://github.com/VundleVim/Vundle.vim) inakuruhusu wewe kufanya yafuatayo...

- kuweza kujua na kufanya [configuration](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L126-L233) za plugins zako ndani ya `.vimrc`

- [kusakinisha](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L234-L254) plugins ambazo ziko configured(kwa jina la maandiko/bundle)

- [kuongeza](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L255-L265) plugins ambazo ziko configured

- [kutafuta](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L266-L295) kwa jina maandiko yote ambayo yapo ndani ya [Vim maandiko/Scripts(Hati)](http://vim-scripts.org/vim/scripts.html)

- [kutoa](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L303-L318) plugins ambazo hazitumiki

- kutekeleza(run) vitendo hapo juu kwa kubonyeza moja pamoja na [modi ya interactive](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L319-L360)

[Vundle](https://github.com/VundleVim/Vundle.vim) inafanya automatiki kuratibu Vitu Vifuatavyo...

- [kuratibu](http://vimdoc.sourceforge.net/htmldoc/options.html#%27runtimepath%27) njia ya runtime ya maandiko ambazo zimesakinishwa

- inatengeneza [tag za msaada](http://vimdoc.sourceforge.net/htmldoc/helphelp.html#:helptags) baada ya kusakinisha na kupandisha

[Vundle](https://github.com/VundleVim/Vundle.vim) inapitia [mabadaliko ya mwonekano](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L372-L396),tafadhali kuwa tayari kuweza kupata mabadiliko ya sasa

chat katika gitter kwa ajili ya majadiliano na support

![Vundle-installer](http://i.imgur.com/Rueh7Cc.png)

## Kuanza

<hr />

1. Kuanza:

kusakinisha kunahitaji uwe na [Git](http://git-scm.com/) pamoja na kutekeleza(run) [git clone](http://gitref.org/creating/#clone) kwa kila repositori ambayo ipo configured kwa `~/ .vim/bundle/` kwa default.Curl inahitajika kwa ajili ya kutafuta.

Kama unatumia Windows, nenda moja kwa moja katika [setup ya Windows](https://github.com/VundleVim/Vundle.vim/wiki/Vundle-for-Windows).Kama utapata tatizo
, hakikisha unaenda sehemu ya [FAQ](https://github.com/VundleVim/Vundle.vim/wiki).Angalia [Mbinu](https://github.com/VundleVim/Vundle.vim/wiki/Tips-and-Tricks) kwa ajili ya configurations za level kubwa.

Kwa kutumia non-POSIX shels, kama shell za popular fish, zinahitaji setup za nyongeza. Tafadhali angalia [Mswali Kuhusu Hili](https://github.com/VundleVim/Vundle.vim/wiki).

2. Kutengeneza(Kuset) [Vundle](https://github.com/VundleVim/Vundle.vim):

```sh
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

3. Configure Plugins:

Weka hii juu ya `.vimrc` ili kutumia Vundle.Toa plugins ambazo huhitaji, zipo kwa ajili ya lengo la illustration.

```sh
set nocompatible              " inapaswa kuboreshwa, inahitajika
filetype off                  " inahitajika

" weka njia ya runtime kujumuisha Vundle na anzisha
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" badala yake, weka njia ambapo Vundle inapaswa kusakinisha nyongeza
"call vundle#begin('~/some/path/here')

" ruhusu Vundle kusimamia Vundle, inahitajika
Plugin 'VundleVim/Vundle.vim'

" Zifuatazo ni mifano ya miundo tofauti inayoungwa mkono.
" Weka amri za Plugin kati ya vundle#begin/end.
" nyongeza kwenye GitHub repo
Plugin 'tpope/vim-fugitive'
" nyongeza kutoka http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin ambayo haijawekwa kwenye GitHub
Plugin 'git://git.wincent.com/command-t.git'
" hifadhi za git kwenye mashine yako ya ndani (yaani wakati unafanya kazi kwenye nyongeza yako mwenyewe)
Plugin 'file:///home/gmarik/path/to/plugin'
" Hati ya vim ya sparkup iko kwenye jalada dogo la repo hii inayoitwa vim.
" Pitia njia ili kuweka runtimepath vizuri.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Sakinisha L9 na epuka mgongano wa majina ikiwa tayari umesakinisha
" toleo tofauti mahali pengine.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" Nyongeza zote lazima ziwekwe kabla ya mstari ufuatao
call vundle#end()            " inahitajika
filetype plugin indent on    " inahitajika
" Ili kupuuza mabadiliko ya indent ya nyongeza, badala yake tumia:
"filetype plugin on
"
" Msaada mfupi
" :PluginList       - orodhesha nyongeza zilizosanidiwa
" :PluginInstall    - sakinisha nyongeza; ongeza `!` kusasisha au tu: PluginUpdate
" :PluginSearch foo - tafuta foo; ongeza `!` kusasisha cache ya ndani
" :PluginClean      - thibitisha kuondolewa kwa nyongeza ambazo hazitumiki; ongeza `!` kuidhinisha kuondolewa moja kwa moja
"
" tazama :h vundle kwa maelezo zaidi au wiki kwa Maswali Yanayoulizwa Mara kwa Mara
" Weka vitu vyako visivyo vya Plugin baada ya mstari huu

```

4. Sakinisha Plugins

Anzisha `vim` na tekeleza `:PluginInstall`

Kusakinisha kutoka kwenye command line: `vim +PluginInstall +qall`

5. (sio lazima) Kwa wale ambao wanatumia shell: ongeza(add) `set shell=/bin/bash` kwenye `.vimrc`

## Nyaraka

<hr />

Angalia [:h vundle](https://github.com/VundleVim/Vundle.vim/blob/master/doc/vundle.txt) Vimdoc kwa maelekezo zaidi.

## Mabadiliko

<hr />

Angalia [changelog](https://github.com/VundleVim/Vundle.vim/blob/master/changelog.md)

## Watu Wanao Tumia Vundle

<hr />

angalia ,[mifano](https://github.com/VundleVim/Vundle.vim/wiki/Examples)

## Wachangiaji

<hr />

angalia [Wachangiaji wa Vundle](https://github.com/VundleVim/Vundle.vim/graphs/contributors)

Ahsanteni

## Uvuvio & Mawazo

<hr />

- [pathogen.vim](http://github.com/tpope/vim-pathogen/)
- [Bundler](https://github.com/bundler/bundler)
- [Scott Bronson](http://github.com/bronson)

## Pia

<hr />

- Vundle imetengenezwa na kufanyiwa majaribio na [Vim](http://www.vim.org/) 7.3 katika OS X, Linux na Windows

- Vundle inajaribu kuwa [KISS](http://en.wikipedia.org/wiki/KISS_principle) kwa namna yoyote

## Chakufanya

[Vundle](http://github.com/VundleVim/Vundle.vim) ni kazi ambazo ipo kwenye mwendelezo, hivyo wazo lolote na patch tutashukuru

- [x] kuwasha bundle mpya ambazo zimewekwa katika `.vimrc` reload au baada `:PluginInstall`

- [x] Tumia hakikisha(preview) window kwa ajili ya matokeo ya kutafuta

- [x] Maelekezo ya Vim

- [x] weka Vundle katika `bundles/` pia(tutasuruhisha msaada ya Vundle)

- [x] majaribio

- [x] kubadili kuweza kupambana na matatizo

kuruhusu kuspecify version/revision(toleo/marekebisho)

kuhandle utegemezi(dependencies)

kuonesha maelekezo katika matokeo ya kutafuta

kutafuta maelekezo pia

kufanya iwe safi!
