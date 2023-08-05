#! /bin/bash

system_info() {
    local os=$1
    echo -e "=> ${_cyan}${os}${_nc}: $(uname -rmpo)"
    echo -e "=> ${_cyan}home dir${_nc}: ${HOME}"
}
