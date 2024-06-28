#!/usr/bin/env bash
# original by zzzeyez, @danteissaias's version
# < https://github.com/mathiasbynens/dotfiles/blob/master/.macos >
# < https://github.com/pawelgrzybek/dotfiles/blob/master/setup-macos.sh >
# < https://gist.github.com/DAddYE/2108403 >
# < https://macos-defaults.com >
#
# Use defaults delete <options> to restore default settings.

# Get options values:
# defaults read <options>
# Reset options to default values:
# defaults delete <options>

# ====== Hostname ======

read -rp $'Enter new hostname (e.g., macbook-air-m2. Empty to keep unchanged):\n=> ' hostname
if [ -z "$hostname" ]; then
  echo "Hostname unchanged."
else
  # Change primary hostname:
  sudo scutil --set HostName "$hostname"

  # Change Bonjour hostname:
  sudo scutil --set LocalHostName "$hostname"

  # Change computer name (Finder):
  sudo scutil --set ComputerName "$hostname"
fi

# Restart your Mac.

# ====== General ======
# Use only a dark menu bar and dock
defaults write -g NSRequiresAquaSystemAppearance -bool Yes

# Change the Number of Recent Items (default: 20)
defaults write NSGlobalDomain NSRecentDocumentsLimit 0

################################################################################
# System Preferences > Accessibility
################################################################################

# Pointer Control >  Trackpad Options > Dragging Style: Three Finger Drag
defaults write com.apple.AppleMultitouchTrackpad Dragging -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

################################################################################
# System Preferences > Desktop & Dock
################################################################################

# ====== Dock ======

# Dock > Size:
defaults write com.apple.dock tilesize -int 48

# Dock > Magnification
defaults write com.apple.dock largesize -int 68

# Dock > Minimize windows into application icon
defaults write com.apple.dock minimize-to-application -bool false

# Dock > Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool false

# Show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# ====== Mission Control ======

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Mission Controll > Automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Group by app by default in Expose:
defaults write com.apple.dock expose-group-by-app -bool true

killall Dock

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

################################################################################
# System Preferences > Siri & Spotlight
################################################################################

# Ask Siri
defaults write com.apple.Siri SiriPrefStashedStatusMenuVisible -bool false
defaults write com.apple.Siri VoiceTriggerUserEnabled -bool false

################################################################################
# System Preferences > Control Center
################################################################################

defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true
defaults write com.apple.controlcenter "NSStatusItem Visible WiFi" -bool true
defaults write com.apple.controlcenter "NSStatusItem Visible com.apple.menuextra.dnd" -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -bool false

# show battery percentage in menu bar
# defaults write com.apple.menuextra.battery ShowPercent -string "YES"


################################################################################
# System Preferences > Lock Screen
################################################################################

# Start Screen Saver when inactive: 5 min
defaults -currentHost write com.apple.screensaver idleTime -int 300

# Require password immediately after sleep or screen saver begins.
# defaults write com.apple.screensaver askForPassword -int 1
# defaults write com.apple.screensaver askForPasswordDelay -int 0

################################################################################
# Finder > Preferences
################################################################################

# Keep folders on top when sorting by name:
defaults write com.apple.Finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default:
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Don't show internal hard drives on the desktop:
defaults write com.apple.Finder ShowHardDrivesOnDesktop -bool false

# Set default Finder path.
# For desktop, use `PfDe`. For home, use `PfHm`.
# For other paths, use `PfLo` and `file:///full/path/here/`

# defaults write com.apple.finder NewWindowTarget -string "PfHm"

defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Downloads/"

# Show status bar on Finder.
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar on Finder.
defaults write com.apple.finder ShowPathbar -bool true

# Use list view in all Finder windows by default.
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Hide everything on the desktop:
defaults write com.apple.finder ShowMountedServerOnDesktop -boolean false
defaults write com.apple.finder ShowHardDrivesOnDesktop -boolean false
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -boolean false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -boolean false

# Hide desktop icons.
# defaults write com.apple.finder CreateDesktop -bool false

# Show all filename extensions.
defaults write NSGlobalDomain AppleShowAllExtensions -boolean true

# Kill affected apps
for app in "Dock" "Finder"; do
  killall "${app}" > /dev/null 2>&1
done

# --------------------------------------------------------

# Avoid creating .DS_Store files on network or USB volumes:
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Enable snap-to-grid for icons on the desktop and in other icon views.
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Display full POSIX path as Finder window title.
# defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons.
# defaults write com.apple.finder QuitMenuItem -bool true

# Show the ~/Library folder:
# chflags nohidden ~/Library

# ====== Security ======

read -rp $'Edit security configs? (y/N)' IS_EDIT_SECURITY
if [ "$IS_EDIT_SECURITY" = "y" ] || [ "$IS_EDIT_SECURITY" = "Y" ] ; then
  # Disable automatic login.
  sudo defaults write /Library/Preferences/com.apple.loginwindow autoLoginUser -string ""

  # Disable guest account login.
  sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false

  # Disable File Sharing allows other users to access shared folders on this computer
  # and allows administrators to access all volumes.
  # < https://apple.stackexchange.com/a/376494/318584 >
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server VirtualAdminShares -bool NO
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server VirtualHomeShares -bool NO
fi

################################################################################
# System Preferences > Trackpad
################################################################################

# Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Swipe down to switch any app to Expose.
defaults write com.apple.dock showAppExposeGestureEnabled -bool true

# Enable Three Finger Drag.
defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerSwipeGesture -int 1

################################################################################
# System Preferences > Keyboard
################################################################################

# Key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1

# Delay until repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 18

# Use the Tab key for navigating through dialog boxes
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2

# Txt Input > Correct spelling automatically
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# Txt Input > Capitalise words automatically
defaults write -g NSAutomaticCapitalizationEnabled -bool false

# Txt Input > Add full stop with double-space
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable typing Accent Menu.
defaults write -g ApplePressAndHoldEnabled -bool false

################################################################################
# System Preferences > Keyboard > Shortcuts > Screenshots
################################################################################

defaults write com.apple.screencapture location "${HOME}/Downloads"

# ===============================================================================

killall ControlCenter
killall SystemUIServer

echo "Done. Note that some of these changes require a log-out/restart to take effect."
