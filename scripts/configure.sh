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

configure_vim() {
    echo -e "${_green}configuring vim${_nc}"

    echo -e "=> ${_cyan}vim:${_nc}"
    local vimdir="${HOME}/.vim"
    if [[ ! -d "${vimdir}" ]]; then
        mkdir "${vimdir}"
    fi
    _create_symlink "configs/vimrc" "${HOME}/.vim/vimrc"

    echo -e "=> ${_cyan}installing vundle:${_nc}"
    ls "${vimdir}/bundle/Vundle.vim" > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        echo "vundle is not installed"
        git clone https://github.com/VundleVim/Vundle.vim.git
    else
        echo "vundle has been alredy installed"
    fi

    echo -e "=> ${_cyan}installing vim plugins:${_nc}"
    vim +PluginInstall +qall

    echo -e "${_green}vim has been configured${_nc}"
}

configure_vscode() {
    local user_settings_path=$1

    echo -e "${_green}configuring vscode${_nc}"

    local vscdir="${HOME}/.vscode"
    if [[ ! -d "${vscdir}" ]]; then
        mkdir "${vscdir}"
    fi

    # settings.json
    echo -e "=> ${_cyan}vscode:${_nc}"
    rm "${user_settings_path}/settings.json"  # delete existing settings
    _create_symlink "configs/vscode.json" "${user_settings_path}/settings.json"

    # install vsc extensions
    _install_vsc_extension "ms-python.python"
    _install_vsc_extension "ms-python.isort"
    _install_vsc_extension "jdinhlife.gruvbox"
    _install_vsc_extension "hashicorp.terraform"

    echo -e "${_green}vscode has been configured${_nc}"
}

configure_git() {
    echo -e "${_green}configuring git${_nc}"

    echo -e "=> ${_cyan}global gitignore:${_nc}"
    _create_symlink "configs/gitignore-global" "${HOME}/.gitignore"
    git config --global core.excludesfile "${HOME}/.gitignore"
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

    cat "${dst}" > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        echo "creating symlink"
    	local root_dir="$(git rev-parse --show-toplevel)"
        ln -s "${root_dir}/${src}" "${dst}"
	    echo "symlink created"
    else
        echo "symlink has been already created"
    fi
}

_install_vsc_extension() {
    local extension=$1
    echo -e "=> ${_cyan}installing vscode extension:${_nc} ${extension}"
    code --install-extension "${extension}" --force
}
