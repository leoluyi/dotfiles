#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

if [ -f "$_SCRIPT_DIR"/macos-keyboard-shortcuts.xml ]; then
  defaults import com.apple.symbolichotkeys "$_SCRIPT_DIR"/macos-keyboard-shortcuts.xml \
  && /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  echo "Finished setting shortcut keys using: '$_SCRIPT_DIR/macos-keyboard-shortcuts.xml'"
else
  echo "Config file not found: '$_SCRIPT_DIR/macos-keyboard-shortcuts.xml' not found"
  cat <<EOF
Please create the file with the following command and try again.

defaults export com.apple.symbolichotkeys $_SCRIPT_DIR/macos-keyboard-shortcuts.xml"
EOF
  exit 1
fi
