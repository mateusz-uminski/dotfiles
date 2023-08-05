#! /bin/bash

brew_install() {
    echo -e "=> ${_cyan}installing brew${_nc}:"

    brew help > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "${HOME}.zprofile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

brew_configure() {
    echo -e "=> ${_cyan}configuring brew${_nc}:"

    local output="$(brew analytics)"
    if [[ $output =~ "Analytics are disabled." ]]; then
        brew analytics off
        echo -e "${_red}brew analytics turned off${_nc}"
    fi
}

brew_uninstall() {
    echo -e "=> ${_cyan}uninstalling brew${_nc}:"

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
}

brew_cleanup() {
    echo -e "=> ${_red}cleaning brew${_nc}:"
    brew cleanup --dry-run

    printf "%s" "do you want to delete the above files [y/n]: "
    read answer
    if [ "$answer" != "${answer#[Yy]}" ]; then
    	echo -e "${_red}yes${_nc}"
	brew cleanup
    else
    	echo -e "${_red}no${_nc}"
    fi
}
