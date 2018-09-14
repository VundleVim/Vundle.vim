## [帮助维护Vundle](https://github.com/VundleVim/Vundle.vim/issues/383)

## 关于

[Vundle] 是 _Vim bundle_ 的简称,是一个 [Vim] 插件管理器：

[Vundle] 允许你做...

* 同时在`.vimrc`中跟踪和[管理](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L126-L233)插件
* [安装](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L234-L254)特定格式的插件(a.k.a. scripts/bundle)
* [更新](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L255-L265)特定格式插件
* 通过插件名称[搜索](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L266-L295)[Vim scripts](http://vim-scripts.org/vim/scripts.html)中的插件
* [清理](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L303-L318)未使用的插件
* 可以通过*单一按键*完成以上操作,详见[interactive mode](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L319-L360)

[Vundle] 自动完成...

* 管理已安装插件的[runtime path](http://vimdoc.sourceforge.net/htmldoc/options.html#%27runtimepath%27)
* 安装和更新后,重新生成[帮助标签](http://vimdoc.sourceforge.net/htmldoc/helphelp.html#:helptags)

[Vundle] 正在经历一个 [interface change], 请通过以下方式获取最新信息。

讨论和技术支持：[![Gitter-chat](https://badges.gitter.im/VundleVim/Vundle.vim.svg)](https://gitter.im/VundleVim/Vundle.vim)

![Vundle-installer](http://i.imgur.com/Rueh7Cc.png)

## 快速开始

1. 介绍:

   安装需要[Git](http://git-scm.com/)，触发[`git clone`](http://gitref.org/creating/#clone),默认将每一个指定特定格式插件的仓库复制到`~/.vim/bundle/`.
   搜索需要Curl支持。

   Windows用户请直接访问[Windows setup]. 如果有任何问题, 请参考 [FAQ].
   查看 [Tips] 获取相关高级配置。

   使用 non-POSIX shells, 比如比较流行对 Fish shell, 需要额外对步骤。 请查看 [FAQ].

2. 初始安装 [Vundle]：

   `$ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`

3. 配置插件 :

   请将以下加在 `.vimrc` 方可使用Vundle. 删掉你不需要的插件, 这些只是用做示例.

   ```vim
   set nocompatible              " 去除VI一致性,必须
   filetype off                  " 必须

   " 设置包括vundle和初始化相关的runtime path
   set rtp+=~/.vim/bundle/Vundle.vim
   call vundle#begin()
   " 另一种选择, 指定一个vundle安装插件的路径
   "call vundle#begin('~/some/path/here')

   " 让vundle管理插件版本,必须
   Plugin 'VundleVim/Vundle.vim'

   " 以下范例用来支持不同格式的插件安装.
   " 请将安装插件的命令放在vundle#begin和vundle#end之间.
   " Github上的插件
   " 格式为 Plugin '用户名/插件仓库名'
   Plugin 'tpope/vim-fugitive'
   " 来自 http://vim-scripts.org/vim/scripts.html 的插件
   " Plugin '插件名称' 实际上是 Plugin 'vim-scripts/插件仓库名' 只是此处的用户名可以省略
   Plugin 'L9'
   " 由Git支持但不再github上的插件仓库 Plugin 'git clone 后面的地址'
   Plugin 'git://git.wincent.com/command-t.git'
   " 本地的Git仓库(例如自己的插件) Plugin 'file:///+本地插件仓库绝对路径'
   Plugin 'file:///home/gmarik/path/to/plugin'
   " 插件在仓库的子目录中.
   " 正确指定路径用以设置runtimepath. 以下范例插件在sparkup/vim目录下
   Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
   " 安装L9，如果已经安装过这个插件，可利用以下格式避免命名冲突
   Plugin 'ascenator/L9', {'name': 'newL9'}

   " 你的所有插件需要在下面这行之前
   call vundle#end()            " 必须
   filetype plugin indent on    " 必须 加载vim自带和插件相应的语法和文件类型相关脚本
   " 忽视插件改变缩进,可以使用以下替代:
   "filetype plugin on
   "
   " 简要帮助文档
   " :PluginList       - 列出所有已配置的插件
   " :PluginInstall    - 安装插件,追加 `!` 用以更新或使用 :PluginUpdate
   " :PluginSearch foo - 搜索 foo ; 追加 `!` 清除本地缓存
   " :PluginClean      - 清除未使用插件,需要确认; 追加 `!` 自动批准移除未使用插件
   "
   " 查阅 :h vundle 获取更多细节和wiki以及FAQ
   " 将你自己对非插件片段放在这行之后
   ```

4. 安装插件:

   运行 `vim` 再运行 `:PluginInstall`

   通过命令行直接安装 `vim +PluginInstall +qall`

## 文档

查阅 [`:h vundle`](https://github.com/VundleVim/Vundle.vim/blob/master/doc/vundle.txt) Vimdoc 以获取更多细节。

## 更新日志

查阅 [changelog](https://github.com/VundleVim/Vundle.vim/blob/master/changelog.md).

## 在使用此插件的用户的VIMRC

查阅 [Examples](https://github.com/VundleVim/Vundle.vim/wiki/Examples)

## 维护者

查阅 [Vundle contributors](https://github.com/VundleVim/Vundle.vim/graphs/contributors)

*感谢!*

## 灵感 & 思路

* [pathogen.vim](http://github.com/tpope/vim-pathogen/)
* [Bundler](https://github.com/bundler/bundler)
* [Scott Bronson](http://github.com/bronson)

## 另外

* Vundle 已测试环境为: [Vim] 7.3 on OS X, Linux and Windows
* Vundle 尝试尽可能保持至简模式 [KISS](http://en.wikipedia.org/wiki/KISS_principle) 

## TODO:
[Vundle] 是一个正在进步的项目, 所以很多设计思路和补丁是需要借鉴的.

* ✓ 在重新载入或者执行`:PluginInstall`之后激活`.vimrc`中新添加的插件
* ✓ 使用预览窗口显示搜索结果
* ✓ Vim documentation
* ✓ 同时将Vundle 放置在 `bundles/` 中 (将修复 Vundle 帮助)
* ✓ 测试
* ✓ 提升错误处理能力
* 支持手动指定版本(待考虑)
* 版本依赖
* 搜索结果中显示描述
* 同时支持通过描述搜索
* 使其更加稳定!

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
