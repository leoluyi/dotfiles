#!/usr/bin/env bash

# Remove the duplicate "Espanso" macOS app Login Item.
#
# Why: espanso is set to auto-start at login by TWO independent mechanisms:
#   1. the launchd agent ~/Library/LaunchAgents/com.federicoterzi.espanso.plist
#      (RunAtLoad=true) -- the canonical `espanso service register` path that
#      this repo manages and that setup-espanso-watchdog.sh relies on.
#   2. an app Login Item that Espanso.app registers for itself ("Open at Login",
#      visible in System Settings > General > Login Items & Extensions).
#
# At every reboot both fire. Whichever loses the race finds the live instance
# and pops the "espanso is already running" dialog. Removing the app Login Item
# (mechanism 2) leaves a single launchd-driven startup and silences the popup.
#
# Espanso's onboarding re-adds this Login Item on a fresh install, so re-run this
# after (re)installing espanso. Idempotent: a no-op when the item is absent.
#
# Note: the first run triggers a one-time macOS Automation consent prompt to let
# the controlling terminal drive System Events. Approve it for the delete to work.

set -euo pipefail

LOGIN_ITEM_NAME="Espanso"

login_item_exists() {
  [ "$(osascript -e "tell application \"System Events\" to exists login item \"$LOGIN_ITEM_NAME\"")" = "true" ]
}

if login_item_exists; then
  osascript -e "tell application \"System Events\" to delete login item \"$LOGIN_ITEM_NAME\""
  echo "Removed '$LOGIN_ITEM_NAME' app Login Item; espanso now auto-starts via launchd only."
else
  echo "'$LOGIN_ITEM_NAME' app Login Item not present, nothing to do."
fi
