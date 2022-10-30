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

echo -e "${_bgreen}configuring macos${_nc}"
source scripts/system.sh
system_info

source scripts/brew.sh
brew_install
brew_configure

echo -e "${_green}installing packages from the brewfile${_nc}"
echo -e "=> ${_cyan}brewfile:${_nc} ${brewfile}"
brew bundle --file=${brewfile}

echo -e "${_green}installing applications from the caskfile${_nc}"
echo -e "=> ${_cyan}caskfile:${_nc} ${caskfile}"
brew bundle --file=${caskfile}

echo -e "${_green}installing applications from the masfile${_nc}"
echo -e "=> ${_cyan}masfile:${_nc} ${masfile}"
brew bundle --file=${masfile}

brew_cleanup

source scripts/configure.sh
configure_zsh
configure_vim
configure_vscode
