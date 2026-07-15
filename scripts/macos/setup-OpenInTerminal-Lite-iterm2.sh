#!/usr/bin/env bash
# < https://github.com/Ji4n1ng/OpenInTerminal/blob/master/Resources/README-Lite.md >

# Alacritty.
# defaults write wang.jianing.app.OpenInTerminal-Lite LiteDefaultTerminal Alacritty

# iTerm2.
defaults write wang.jianing.app.OpenInTerminal-Lite LiteDefaultTerminal iTerm
# Open a new Window
defaults write com.googlecode.iterm2 OpenFileInNewWindows -bool true

# Reset.
# defaults remove wang.jianing.app.OpenInTerminal-Lite LiteDefaultTerminal
