#! /bin/bash

configure_zsh() {
    echo -e "${_green}configuring zsh${_nc}" 
    
    ls $HOME/.oh-my-zsh > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        echo "oh ny zsh is not installed"
    	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    	rm $HOME/.zshrc  # delete zshrc created by installation script
    else
        echo "oh my zsh has been alredy installed"
    fi
    
    # zshrc
    echo -e "=> ${_cyan}zshrc:${_nc}"
    _create_symlink "configs/zshrc" "${HOME}/.zshrc"

    # install zsh plugins
    local _plugins_path="${HOME}/.oh-my-zsh/custom/plugins"
    _install_zsh_plugin ${_plugins_path} "zsh-syntax-highlighting"
    _install_zsh_plugin ${_plugins_path} "zsh-autosuggestions"
    _install_zsh_plugin ${_plugins_path} "zsh-history-substring-search"

    # install zsh theme
    _install_custom_zsh_theme "simplified-agnoster.zsh-theme"

    echo -e "${_green}zsh has been configured${_nc}"
}

_install_zsh_plugin() {
    local dst=$1
    local plugin=$2
    
    echo -e "=> ${_cyan}installing zsh plugin:${_nc} ${plugin}"
    if [[ -d ${dst}/${plugin} ]]; then
        echo "${plugin} has been already installed"
    else
        git clone https://github.com/zsh-users/${plugin}.git ${dst}/${plugin}
    	echo "${plugin} installed"
    fi
}

_install_custom_zsh_theme() {
    local theme_name=$1
    
    local themes_path="${HOME}/.oh-my-zsh/custom/themes"
    echo -e "=> ${_cyan}installing custom theme:${_nc} ${theme_name}"
    _create_symlink "configs/${theme_name}" "${themes_path}/${theme_name}"
}

_create_symlink() {
    local src=$1
    local dst=$2
    
    cat ${dst} > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        echo "creating symlink"
    	local root_dir="$(git rev-parse --show-toplevel)"
        ln -s "${root_dir}/${src}" ${dst}
	echo "symlink created"
    else
        echo "symlink has been already created"
    fi
}