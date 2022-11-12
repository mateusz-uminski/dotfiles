#! /bin/bash

settings_system() {
    echo -e "=> ${_cyan}system${_nc}:"

    echo "turn off the creation of .DS_Store files"
    defaults write com.apple.desktopservices DSDontWriteNetworkStores true
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    local screenshot_dir="${HOME}/screenshots"
    echo "save screenshots to ${screenshot_dir}"
    if [[ ! -d "${screenshot_dir}" ]]; then
        mkdir "${screenshot_dir}"
    fi
    defaults write com.apple.screencapture location -string "${screenshot_dir}"

    echo "save screenshots in png format"
    # possible values: BMP, GIF, JPG, PDF, TIFF, PNG
    defaults write com.apple.screencapture type -string "png"

    echo "show scrollbars: automatic"
    # possible values: WhenScrolling, Automatic, Always
    defaults write NSGlobalDomain AppleShowScrollBars -string "Automatic"

    echo "disable user interface sound effect"
    defaults write com.apple.systemsound "com.apple.sound.uiaudio.enabled" -int 0

    echo "do not wrap previous command with square brackets"
    defaults write com.apple.Terminal AutoMarkPromptLine -int 0
}

settings_finder() {
    echo -e "=> ${_cyan}finder${_nc}:"

    echo "show all filename extensions"
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    echo "keep folders on top when sorting by name"
    defaults write com.apple.finder _FXSortFoldersFirst -bool true

    echo "show status bar"
    defaults write com.apple.finder ShowStatusBar -bool true

    echo "show path bar"
    defaults write com.apple.finder ShowPathbar -bool true

    echo "search the current directory by default"
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    echo "enable spring loading for directories"
    defaults write NSGlobalDomain com.apple.springing.enabled -bool true

    # echo "set the spring loading delay for directories to X"
    # defaults write NSGlobalDomain com.apple.springing.delay -float 0
}

settings_safari() {
    echo -e "=> ${_cyan}safari${_nc}:"

    echo "do not send search queries to Apple"
    defaults write com.apple.Safari UniversalSearchEnabled -bool false
    defaults write com.apple.Safari SuppressSearchSuggestions -bool true

    echo "set home page"
    defaults write com.apple.Safari HomePage -string "http://www.apple.com/pl/startpage/"

    echo "do not open safe files automatically after downloading"
    defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

    echo "enable do not track"
    defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
}
