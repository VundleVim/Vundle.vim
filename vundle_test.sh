setup() {
  mkdir -p $HOME/.vim/autoload/ && 
  curl http://github.com/gmarik/vundle/raw/master/autoload/vundle.vim > $HOME/.vim/autoload/vundle.vim

  echo -en "Setup: " ; [ -s $HOME/.vim/autoload/vundle.vim ] && echo "ok" || echo "fail"
}

install() {
  vim -e -c "call vundle#rc()" -c "BundleInstall" -c "q"
  # echo -en "Setup: " ; [ -s $HOME/.vim/autoload/vundle.vim ] && echo "ok" || echo "fail"
  echo -en 'Install:'; [ -d $HOME/.vim/bundle ] && [ "$(ls -1 -d ~/.vim/bundle/*|wc -l)" = "$(grep ^Bundle ~/.vim/bundlerc|wc -l)" ] && echo 'ok' || echo 'fail'
}

test() {
  setup
  install
}

test
