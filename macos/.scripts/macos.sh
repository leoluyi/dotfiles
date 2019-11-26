#!/usr/bin/env bash
# original by zzzeyez, @danteissaias's version
# https://github.com/mathiasbynens/dotfiles/blob/master/.macos

# ====== Mission Control ======

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Don't automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Group by app by default in Expose:
defaults write com.apple.dock expose-group-by-app -bool true

# show battery percentage in menu bar
# defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Automatically quit printer app once the print jobs complete
# defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Stop System Preferences from overriding stuff
# osascript -e 'tell application "System Preferences" to quit'

# Disable the "Are you sure you want to open this application?” dialog
# defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable Dashboard
# defaults write com.apple.dashboard mcx-disabled -bool true

# Don't show Dashboard as a Space
# defaults write com.apple.dock dashboard-in-overlay -bool true

# ====== Dock ======

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# ====== Finder ======

# Keep folders on top when sorting by name
defaults write com.apple.Finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Don't show internal hard drives on the desktop:
defaults write com.apple.Finder ShowHardDrivesOnDesktop -bool false

# Set default Finder path.
# For desktop, use `PfDe`.
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar on Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar on Finder
defaults write com.apple.finder ShowPathbar -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Display full POSIX path as Finder window title
# defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
# defaults write com.apple.finder QuitMenuItem -bool true

# Enable snap-to-grid for icons on the desktop and in other icon views
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Show the ~/Library folder
# chflags nohidden ~/Library

# ====== Security ======

# Disable guest users:
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false

# Require password immediately after sleep or screen saver begins
# defaults write com.apple.screensaver askForPassword -int 1
# defaults write com.apple.screensaver askForPasswordDelay -int 0

# ====== Trackpad ======

# Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Swipe down to switch any app to Expose
defaults write com.apple.dock showAppExposeGestureEnabled -bool true

# ====== Keyboard ======

# Disable automatic period insertion on double-space
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
# Set a shorter Delay until key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 18

echo "Done. Note that some of these changes require a logout/restart to take effect."
