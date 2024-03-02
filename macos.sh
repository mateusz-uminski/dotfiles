#! /bin/bash

# colors
_red='\033[0;31m'
_green='\033[0;32m'
_blue='\033[0;34m'
_cyan='\033[0;36m'

# bold colors
_bred='\033[1;31m'
_bgreen='\033[1;32m'
_bblue='\033[1;34m'
_bcyan='\033[1;36m'

_nc='\033[0m'  # no color -> resets color

brewfile="./os/macos/main.Brewfile"
caskfile="./os/macos/cask.Brewfile"
masfile="./os/macos/mas.Brewfile"

source scripts/system.sh
system_info "macos"

source os/macos/settings.sh
settings_system
settings_finder
settings_safari
settings_xcode

source scripts/brew.sh
brew_install
brew_configure
echo -e "=> ${_cyan}installing packages from the brewfile${_nc}: ${brewfile}"
brew bundle --file=${brewfile}
echo -e "=> ${_cyan}installing applications from the caskfile${_nc}: ${caskfile}"
brew bundle --file=${caskfile}
echo -e "=> ${_cyan}installing applications from the masfile${_nc}: ${masfile}"
brew bundle --file=${masfile}
brew_cleanup

source scripts/configure.sh
configure_zsh
configure_vim
configure_go
configure_git
configure_vscode "${HOME}/Library/Application Support/Code/User"
configure_install_additional_software()
