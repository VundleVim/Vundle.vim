setup() {
  mkdir -p $HOME/.vim/autoload/ && 
  curl http://github.com/gmarik/vundle/raw/master/autoload/vundle.vim > $HOME/.vim/autoload/vundle.vim
  return$([ -s $HOME/.vim/autoload/vundle.vim ] && rm -f ~/.vim/autoload/vundle.vim ) 
}

install() {
  vim -e -c "BundleInstall" -c "q"
  return $([ -d $HOME/.vim/bundle ] && [ "$(ls -1 -d ~/.vim/bundle/*|wc -l)" = "$(grep ^Bundle ~/.vim/vimrc|wc -l)" ] )
}

docs() {
  _tags() { find ~/.vim/bundle/**/doc -name 'tags'; } 
  _tags | xargs rm
  vim -e -c 'BundleDocs' -c 'q'
  return $([ "0" != $(_tags | wc -l) ])
}

t() {
  printf "%-15s: " $1
  $1 1>> 'test.log' 2>&1 && echo 'ok' || echo 'fail'
}

# $ source vundle_test.sh; test_all
test_all() {
  : > 'test.log'
  t setup 
  t install
  t docs
} 

# $ source vundle_test.sh; doc
doc() {
  maruku --html README.md ; open README.html 
}
