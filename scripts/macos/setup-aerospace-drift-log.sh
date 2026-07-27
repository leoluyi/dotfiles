#!/usr/bin/env bash

# Install the aerospace-drift-log launchd user agent.
#
# This is diagnostic instrumentation, not a permanent service. Once
# docs/aerospace-hotkey-debug.md has an answer, uninstall it with:
#
#   launchctl bootout "gui/$(id -u)/com.leoluyi.aerospace-drift-log"
#   rm ~/Library/LaunchAgents/com.leoluyi.aerospace-drift-log.plist

set -euo pipefail

LABEL="com.leoluyi.aerospace-drift-log"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$LABEL.plist"
DEST="$HOME/Library/LaunchAgents/$LABEL.plist"

mkdir -p "$HOME/Library/LaunchAgents" "$HOME/.local/state/aerospace-drift"

if [ -e "$DEST" ] || [ -L "$DEST" ]; then
  launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null || true
  rm -f "$DEST"
fi

ln -s "$SRC" "$DEST"

launchctl bootstrap "gui/$(id -u)" "$DEST"
launchctl kickstart -k "gui/$(id -u)/$LABEL"

echo "Installed $LABEL"
echo "Log: ~/.local/state/aerospace-drift/drift.log"
