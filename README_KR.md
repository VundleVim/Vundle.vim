## [Vundle 유지보수 돕기](https://github.com/VundleVim/Vundle.vim/issues/383)

## 소개

[Vundle] 은 _Vim bundle_ 의 약자로 [Vim] 플러그인 매니저입니다.

[Vundle] 은 다음 기능들을 제공합니다.

* `.vimrc`에 직접 플러그인들의 기록을 남기고 [환경설정]하기
* 플러그인들을 [설치]하기 (scripts/bundle 와 같음)
* 플러그인들을 [업데이트]하기
* 사용 가능한 [Vim scripts]를 이름으로 [검색]하기
* 사용하지 않는 플러그인들을 [정리]하기
* [interactive 모드]에서 위 기능들을 *하나의 키* 로 실행하기

[Vundle]은 자동으로 다음을 수행합니다.

* 설치된 스크립트들의 [runtime 경로]를 관리합니다
* 설치 및 업데이트 후 [도움말 태그]를 재생성합니다

[Vundle]은 현재 [인터페이스 수정] 중 입니다. 최신 변경 사항을 적용하기위해 항상 최신 상태로 유지하십시오.

토론 및 지원 : [![Gitter-chat](https://badges.gitter.im/VundleVim/Vundle.vim.svg)](https://gitter.im/VundleVim/Vundle.vim)

![Vundle-installer](http://i.imgur.com/Rueh7Cc.png)

## 빠른 시작

1. 시작하기:

   Vundle을 설치하기 위해선 [Git]이 필요합니다.
   설치 과정에서 각각의 저장소를 `~/.vim/bundle/` 경로에 기본값으로 [`git clone`]합니다.
   검색 기능을 위해 Curl이 필요합니다.

   Windows 사용자라면, [윈도우에서 설치] 문서를 참조하십시오. 만약 어떤 문제라도 발생한다면, [자주 묻는 질문]에 도움을 요청하십시오.
   좀 더 나은 환경설정을 위해 [도움말]을 참조하십시오.

   Fish shell과 같은 non-POSIX shell을 사용한다면, 추가적인 설치가 필요합니다. [자주 묻는 질문]을 확인하십시오.

2. [Vundle] 설치하기:

   `$ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`

3. 플러그인 설정하기:

   Vundle을 사용하기 위해 다음을 `.vimrc` 파일의 첫 줄에 붙여넣으십시오. 필요 없는 플러그인들을 삭제하십시오. 다음은 예시입니다.

   ```vim
   set nocompatible              " Vi와 호환 불가 설정, 필수
   filetype off                  " 필수

   " Vundle을 포함시키기 위해 runtime 경로를 설정하고 초기화
   set rtp+=~/.vim/bundle/Vundle.vim
   call vundle#begin()
   " 기존 경로 대신 Vundle이 플러그인을 설치할 경로를 입력하십시오.
   "call vundle#begin('~/some/path/here')

   " Vundle이 스스로를 관리하도록 설정, 필수
   Plugin 'VundleVim/Vundle.vim'

   " 아래는 지원되는 여러 형식들의 예시입니다
   " 플러그인 명령어를 vundle#begin/end 사이에 추가하십시오
   " GitHub 저장소에 있는 플러그인
   Plugin 'tpope/vim-fugitive'
   " http://vim-scripts.org/vim/scripts.html 에 있는 플러그인
   " 'L9' 플러그인
   " GitHub에 호스트 되어있지 않는 Git 플러그인
   Plugin 'git://git.wincent.com/command-t.git'
   " 사용하는 기기의 git 저장소 ( 당신만의 플러그인을 사용할 때 )
   Plugin 'file:///home/gmarik/path/to/plugin'
   " sparkup vim script는 vim 이란 이름의 저장소 하위 디렉토리 내부에 있습니다.
   " 정확한 runtime 경로를 입력하십시오.
   Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
   " L9를 설치하고, 만약 당신이 다른 버전을 어딘가 설치했을 경우 발생하는 이름 충돌 문제를 방지합니다
   " Plugin 'ascenator/L9', {'name': 'newL9'}


   " 당신의 모든 플러그인은 다음 명령어 이전에 추가되어야 합니다
   call vundle#end()            " 필수
   filetype plugin indent on    " 필수
   " 플러그인의 들여쓰기 변화를 무시하려면, 대신 이 명령어를 사용하십시오:
   "filetype plugin on
   "
   " 간단한 도움말
   " :PluginList       - 설정된 플러그인의 리스트
   " :PluginInstall    - 플러그인 설치; 업데이트를 하려면 `!`를 덧붙이거나 :PluginUpdate 명령을 사용하십시오
   " :PluginSearch foo - foo에 대해 검색; `!`를 덧붙여 로컬 캐시를 새로고침하십시오
   " :PluginClean      - 사용하지 않는 플러그인의 삭제를 확인; `!`를 붙여 자동 삭제를 승인하십시오
   "
   " 더 자세한 내용은 :h vundle 문서나 wiki의 FAQ를 확인하십시오
   " 다음 줄부터 플러그인이 아닌 내용을 넣으십시오
   ```

4. 플러그인 설치:

   `vim`을 켠 후 `:PluginInstall`을 실행하십시오.

   명령줄에서 설치: `vim +PluginInstall +qall`

5. (선택) fish shell 사용시: `.vimrc`내에 `set shell=/bin/bash`을 추가하십시오.

## 문서

더 자세한 내용은 [`:h vundle`](https://github.com/VundleVim/Vundle.vim/blob/master/doc/vundle.txt) 문서를 참조하십시오.

## 변경 로그

[변경 로그](https://github.com/VundleVim/Vundle.vim/blob/master/changelog.md)을 확인하십시오.

## Vundle을 사용하는 사람들

[예시](https://github.com/VundleVim/Vundle.vim/wiki/Examples)를 확인하십시오.

## 기여자

[Vundle 기여자 명단](https://github.com/VundleVim/Vundle.vim/graphs/contributors)을 확인하십시오.

*감사합니다!*

## 아이디어 및 영감

* [pathogen.vim](http://github.com/tpope/vim-pathogen/)
* [Bundler](https://github.com/bundler/bundler)
* [Scott Bronson](http://github.com/bronson)

## 기타

* Vundle은 [Vim] 버젼 7.3으로 OS X, Linux 및 Windows에서 개발 및 테스트 되었습니다.
* Vundle은 최대한 [KISS](http://en.wikipedia.org/wiki/KISS_principle) 원칙을 준수합니다.

## 할일:
[Vundle]은 현재 개발이 진행 중 입니다. 그러니 어떤 아이디어이든 개선점이든 알려주시면 감사하겠습니다.

* [x] `:PluginInstall`을 실행하거나 재실행 하였을 때 새로 추가된 플러그인들을 `.vimrc`에 새롭게 추가하는 기능 활성화
* [x] 미리보기 창에 검색 결과 띄우기
* [x] Vim 문서 작성
* [x] `bundles/`에 Vundle넣기 (Vundle 도움말이 수정됨)
* [x] 테스트
* [x] 에러 관리 개선
* [ ] 각 수정 및 버전의 명시를 가능하게?
* [ ] 의존성 관리
* [ ] 검색 결과에 설명 보여주기
* [ ] 설명으로 검색하기
* [ ] 존나 쩔게 만들기!

[Vundle]:http://github.com/VundleVim/Vundle.vim
[윈도우에서 설치]:https://github.com/VundleVim/Vundle.vim/wiki/Vundle-for-Windows
[자주 묻는 질문]:https://github.com/VundleVim/Vundle.vim/wiki
[도움말]:https://github.com/VundleVim/Vundle.vim/wiki/Tips-and-Tricks
[Vim]:http://www.vim.org
[Git]:http://git-scm.com
[`git clone`]:http://gitref.org/creating/#clone

[Vim scripts]:http://vim-scripts.org/vim/scripts.html
[도움말 태그]:http://vimdoc.sourceforge.net/htmldoc/helphelp.html#:helptags
[runtime 경로]:http://vimdoc.sourceforge.net/htmldoc/options.html#%27runtimepath%27

[환경설정]:https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L126-L233
[설치]:https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L234-L254
[업데이트]:https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L255-L265
[검색]:https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L266-L295
[정리]:https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L303-L318
[interactive 모드]:https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L319-L360
[인터페이스 수정]:https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L372-L396
