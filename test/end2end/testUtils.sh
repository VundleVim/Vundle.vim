NC='\033[0m' # No Color
BUNDLES_FOLDER="${SCRIPT_DIR}/.vim/bundle/"

function successPrintAndClean {
  GREEN='\033[42m'
  printf "${GREEN}    Green bar!! :-)    ${NC}\n"
  clean
}

function errorPrintAndClean {
  RED='\033[41m'
  printf "${RED}    $1 :-(    ${NC}\n"
  clean
}

function clean {
  rm -rf ${SCRIPT_DIR}/.vim
}

function deployThisVundle {
  mkdir -p ${SCRIPT_DIR}/.vim/bundle/vundle
  cp -r ${SCRIPT_DIR}/../../* ./.vim/bundle/vundle/ 2> /dev/null
}

function bundlesInstallUsing {
  vim -u $1 +BundleInstall! +qall
}

function checkPluginPresenceAndVersion {
  name=$1
  expectedVersion=$2
  pluginFolder=${BUNDLES_FOLDER}${name}

  if [ ! -d  $pluginFolder ]; then
    errorPrintAndClean "No plugin folder for ${name}!!"
    exit 
  fi

  cd $pluginFolder
  gitDescribe=$(git describe --tags)

  if [ "$gitDescribe" != "$expectedVersion" ]; then
    errorPrintAndClean "Wrong plugin version for ${name} (${gitDescribe})!"
    exit 
  fi
  
  cd $SCRIPT_DIR
}
