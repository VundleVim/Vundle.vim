## [幫助維護Vundle](https://github.com/VundleVim/Vundle.vim/issues/383)

## 關於

[Vundle] 是 _Vim bundle_ 的簡稱,是一個 [Vim] 插件管理器.

[Vundle] 允許你做...

* 同時在`.vimrc`中跟蹤和[管理](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L126-L233)插件
* [安裝](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L234-L254)特定格式的插件(a.k.a. scripts/bundle)
* [更新](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L255-L265)特定格式插件
* 通過插件名稱[搜索](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L266-L295)[Vim scripts](http://vim-scripts.org/vim/scripts.html)中的插件
* [清理](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L303-L318)未使用的插件
* 可以通過*單一按鍵*完成以上操作,詳見[interactive mode](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L319-L360)

[Vundle] 自動完成...

* 管理已安裝插件的[runtime path](http://vimdoc.sourceforge.net/htmldoc/options.html#%27runtimepath%27)
* 安裝和更新後,重新生成[幫助標簽](http://vimdoc.sourceforge.net/htmldoc/helphelp.html#:helptags)

[Vundle] 正在經歷一個 [interface change], 請通過以下方式獲取最新信息.

討論和技術支持:[![Gitter-chat](https://badges.gitter.im/VundleVim/Vundle.vim.svg)](https://gitter.im/VundleVim/Vundle.vim)

![Vundle-installer](http://i.imgur.com/Rueh7Cc.png)

## 快速開始

1. 介紹:

   安裝需要[Git](http://git-scm.com/),觸發[`git clone`](http://gitref.org/creating/#clone),默認將每一個指定特定格式插件的倉庫復制到`~/.vim/bundle/`.
   搜索需要Curl支持.

   Windows用戶請直接訪問[Windows setup]. 如果有任何問題, 請參考 [FAQ].
   查看 [Tips] 獲取相關高級配置.

   使用 non-POSIX shells, 比如比較流行對 Fish shell, 需要額外對步驟. 請查看 [FAQ].

2. 初始安裝 [Vundle]:

   `$ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`

3. 配置插件 :

   請將以下加在 `.vimrc` 方可使用Vundle. 刪掉你不需要的插件, 這些只是用做示例.

   ```vim
   set nocompatible              " 去除VI一致性,必須
   filetype off                  " 必須

   " 設置包括vundle和初始化相關的runtime path
   set rtp+=~/.vim/bundle/Vundle.vim
   call vundle#begin()
   " 另一種選擇, 指定一個vundle安裝插件的路徑
   "call vundle#begin('~/some/path/here')

   " 讓vundle管理插件版本,必須
   Plugin 'VundleVim/Vundle.vim'

   " 以下範例用來支持不同格式的插件安裝.
   " 請將安裝插件的命令放在vundle#begin和vundle#end之間.
   " Github上的插件
   " 格式為 Plugin '用戶名/插件倉庫名'
   Plugin 'tpope/vim-fugitive'
   " 來自 http://vim-scripts.org/vim/scripts.html 的插件
   " Plugin '插件名稱' 實際上是 Plugin 'vim-scripts/插件倉庫名' 只是此處的用戶名可以省略
   Plugin 'L9'
   " 由Git支持但不再github上的插件倉庫 Plugin 'git clone 後面的地址'
   Plugin 'git://git.wincent.com/command-t.git'
   " 本地的Git倉庫(例如自己的插件) Plugin 'file:///+本地插件倉庫絕對路徑'
   Plugin 'file:///home/gmarik/path/to/plugin'
   " 插件在倉庫的子目錄中.
   " 正確指定路徑用以設置runtimepath. 以下範例插件在sparkup/vim目錄下
   Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
   " 安裝L9，如果已經安裝過這個插件，可利用以下格式避免命名衝突
   Plugin 'ascenator/L9', {'name': 'newL9'}

   " 你的所有插件需要在下面這行之前
   call vundle#end()            " 必須
   filetype plugin indent on    " 必須 加載vim自帶和插件相應的語法和文件類型相關腳本
   " 忽視插件改變縮進,可以使用以下替代:
   "filetype plugin on
   "
   " 簡要幫助文檔
   " :PluginList       - 列出所有已配置的插件
   " :PluginInstall    - 安裝插件,追加 `!` 用以更新或使用 :PluginUpdate
   " :PluginSearch foo - 搜索 foo ; 追加 `!` 清除本地緩存
   " :PluginClean      - 清除未使用插件,需要確認; 追加 `!` 自動批准移除未使用插件
   "
   " 查閱 :h vundle 獲取更多細節和wiki以及FAQ
   " 將你自己對非插件片段放在這行之後
   ```

4. 安裝插件:

   運行 `vim` 再運行 `:PluginInstall`

   通過命令行直接安裝 `vim +PluginInstall +qall`

## Docs

查閱 [`:h vundle`](https://github.com/VundleVim/Vundle.vim/blob/master/doc/vundle.txt) Vimdoc 以獲取更多細節.

## 更新日誌

查閱 [changelog](https://github.com/VundleVim/Vundle.vim/blob/master/changelog.md).

## 在使用此插件的用戶的VIMRC

查閱 [Examples](https://github.com/VundleVim/Vundle.vim/wiki/Examples)

## 維護者

查閱 [Vundle contributors](https://github.com/VundleVim/Vundle.vim/graphs/contributors)

*感謝!*

## 靈感 & 思路

* [pathogen.vim](http://github.com/tpope/vim-pathogen/)
* [Bundler](https://github.com/bundler/bundler)
* [Scott Bronson](http://github.com/bronson)

## 另外

* Vundle 已測試環境為: [Vim] 7.3 on OS X, Linux and Windows
* Vundle 嘗試盡可能保持至簡模式 [KISS](http://en.wikipedia.org/wiki/KISS_principle) 

## TODO:
[Vundle] 是一個正在進步對項目, 所以很多設計思路和補丁是需要借鑒的.

* ✓ 在重新載入或者執行`:PluginInstall`之後激活`.vimrc`中新添加的插件
* ✓ 使用預覽窗口顯示搜索結果
* ✓ Vim documentation
* ✓ 同時將Vundle 放置在 `bundles/` 中 (將修復 Vundle 幫助)
* ✓ 測試
* ✓ 提升錯誤處理能力
* 支持手動指定版本(待考慮)
* 版本依賴
* 搜索結果中顯示描述
* 同時支持通過描述搜索
* 使其更加穩定!

[Vundle]:http://github.com/VundleVim/Vundle.vim
[Windows setup]:https://github.com/VundleVim/Vundle.vim/wiki/Vundle-for-Windows
[FAQ]:https://github.com/VundleVim/Vundle.vim/wiki
[Tips]:https://github.com/VundleVim/Vundle.vim/wiki/Tips-and-Tricks
[Vim]:http://www.vim.org
[Git]:http://git-scm.com
[`git clone`]:http://gitref.org/creating/#clone

[Vim scripts]:http://vim-scripts.org/vim/scripts.html
[help tags]:http://vimdoc.sourceforge.net/htmldoc/helphelp.html#:helptags
[runtime path]:http://vimdoc.sourceforge.net/htmldoc/options.html#%27runtimepath%27

[configure]:https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L126-L233
[install]:https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L234-L254
[update]:https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L255-L265
[search]:https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L266-L295
[clean]:https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L303-L318
[interactive mode]:https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L319-L360
[interface change]:https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L372-L396
