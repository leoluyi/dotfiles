#!/usr/bin/env bash

# Install the espanso-watchdog launchd user agent.

set -euo pipefail

SRC=/Users/leoluyi/.dotfiles/macos/com.leoluyi.espanso-watchdog.plist
DEST="$HOME/Library/LaunchAgents/com.leoluyi.espanso-watchdog.plist"

mkdir -p "$HOME/Library/LaunchAgents" "$HOME/.local/state/espanso-watchdog"

if [ -e "$DEST" ] || [ -L "$DEST" ]; then
  launchctl bootout "gui/$(id -u)/com.leoluyi.espanso-watchdog" 2>/dev/null || true
  rm -f "$DEST"
fi

ln -s "$SRC" "$DEST"

launchctl bootstrap "gui/$(id -u)" "$DEST"
launchctl kickstart -k "gui/$(id -u)/com.leoluyi.espanso-watchdog"

echo "Installed com.leoluyi.espanso-watchdog"
launchctl print "gui/$(id -u)/com.leoluyi.espanso-watchdog" | head -20 || true
