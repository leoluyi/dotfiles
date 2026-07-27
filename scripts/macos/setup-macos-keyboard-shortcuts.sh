#!/usr/bin/env bash

set -euo pipefail

_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
_CONFIG="$_SCRIPT_DIR/macos-keyboard-shortcuts.xml"
_DOMAIN="com.apple.symbolichotkeys"
_ACTIVATE_SETTINGS="/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings"

usage() {
  cat <<EOF
Usage: ${BASH_SOURCE[0]##*/} [import|export]

  import   Apply '$_CONFIG' to the system. (default)
  export   Capture the current system shortcuts back into '$_CONFIG'.
EOF
}

cmd_import() {
  if [ ! -f "$_CONFIG" ]; then
    echo "Config file not found: '$_CONFIG'" >&2
    cat >&2 <<EOF

Please create the file by running:

  ${BASH_SOURCE[0]##*/} export

EOF
    exit 1
  fi

  defaults import "$_DOMAIN" "$_CONFIG"
  "$_ACTIVATE_SETTINGS" -u
  echo "Finished setting shortcut keys using: '$_CONFIG'"
}

cmd_export() {
  local tmp
  tmp="$(mktemp)"
  # shellcheck disable=SC2064
  trap "rm -f '$tmp'" RETURN

  defaults export "$_DOMAIN" "$tmp"
  # 'defaults export' writes a binary plist; keep the tracked file diffable.
  plutil -convert xml1 "$tmp"
  mv "$tmp" "$_CONFIG"

  echo "Exported '$_DOMAIN' to: '$_CONFIG'"
}

case "${1:-import}" in
  import) cmd_import ;;
  export) cmd_export ;;
  -h | --help | help) usage ;;
  *)
    echo "Unknown command: '$1'" >&2
    usage >&2
    exit 1
    ;;
esac
