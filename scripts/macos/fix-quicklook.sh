#!/usr/bin/env bash
# https://github.com/anthonygelibert/QLColorCode/issues/51#issuecomment-572932925
# https://github.com/whomwah/qlstephen/issues/81#issuecomment-582207278

command -v brew >/dev/null || exit 0
BREW_PREFIX="$(brew --prefix)"

# find "$BREW_PREFIX"/Caskroom -name "*.qlgenerator" -print0 | xargs -0 xattr -d com.apple.quarantine 2>/dev/null

[ -d "$BREW_PREFIX"/Caskroom ] && find "$BREW_PREFIX"/Caskroom -name "*.qlgenerator" -print0 | xargs -I_ -0 xattr -cr _ 2>/dev/null
[ -d "$HOME"/Library/QuickLook ] && find "$HOME"/Library/QuickLook -name "*.qlgenerator" -print0 | xargs -I_ -0 xattr -cr _ 2>/dev/null
# xattr -cr ~/Library/QuickLook/QLStephen.qlgenerator

qlmanage -r
qlmanage -r cache

echo "Restart Finder by holding down the option key and right click on Finder's dock icon, then select \"Relaunch\" from the menu."
killall Finder
