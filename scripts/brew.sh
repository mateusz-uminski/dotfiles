#! /bin/sh

function brew_install {
    echo "${_green}installing brew${_nc}"
    
    brew help > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/manfred/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

function brew_configure {
    output="$(brew analytics)"
    if [[ $output =~ "Analytics are disabled." ]]; then
        brew analytics off
        echo "${_red}brew analytics turned off${_nc}"
    fi
}

function brew_uninstall {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
}

function brew_cleanup {
    echo "${_red}cleaning brew${_nc}" 
    brew cleanup --dry-run
    
    printf "%s" "do you want to delete the above files [y/n]: "
    read answer
    if [ "$answer" != "${answer#[Yy]}" ]; then 
    	echo "${_red}yes${_nc}"
	brew cleanup
    else
    	echo "${_red}no${_nc}"
    fi
}
