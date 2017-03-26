#!/bin/bash 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${SCRIPT_DIR}/testUtils.sh"
cd $SCRIPT_DIR

# SOME CONSTANTS TO CONSTANTLY BE UPDATED
VIM_FUGITIVE_CURRENT_VERSION="v2.2-71-gaac85a2"
VIM_SURROUND_CURRENT_VERSION="v2.1-9-ge49d6c2"

# 0. CLEAN
clean

# 1. INSTALL VUNDLE LOCALLY
deployThisVundle

# 2.1 INSTALL BUNDLES FROM FIRST LOCAL vimrc
bundlesInstallUsing ${SCRIPT_DIR}/vimrc1

# 2.2 CHECK PLUGINS
checkPluginPresenceAndVersion "vim-surround" "v2.1"       # custom specified tag
checkPluginPresenceAndVersion "vim-fugitive" $VIM_FUGITIVE_CURRENT_VERSION # actual master version
checkPluginPresenceAndVersion "customFolderName" "1.79"   # custom name and specified tag
checkPluginPresenceAndVersion "vim-javascript" "v0.9.0"   # another custom specified tag

# 3.1. INSTALL BUNDLES FROM SECOND LOCAL vimrc
bundlesInstallUsing ${SCRIPT_DIR}/vimrc2

# 3.2 CHECK PLUGINS
checkPluginPresenceAndVersion "vim-surround" $VIM_SURROUND_CURRENT_VERSION # removed specified version
checkPluginPresenceAndVersion "vim-fugitive" "v1.2"             # added custom specified version
checkPluginPresenceAndVersion "ctrlp.vim" "1.78"                # removed custom name and changed tag version
checkPluginPresenceAndVersion "vim-javascript" "v0.9.0"         # nothing changed here

# 4 GREEN BAR AND CLEAN
successPrintAndClean
