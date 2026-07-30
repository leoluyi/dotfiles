#!/usr/bin/env bash

# Compare this machine's macOS startup apps against the recorded manifest.
#
# The manifest (macos/login-items.tsv) records which apps should launch at
# login -- the "Open at Login" entries under System Settings > General > Login
# Items & Extensions. On a new machine, run this to see what is still missing.
#
# Report-only by design: a modern app registers its own login item through
# SMAppService from inside the app, and several (AeroSpace, FlashSpace, Raycast)
# expose the toggle in their own preferences. Adding an entry from the outside
# with System Events either duplicates the app's own registration or gets
# overwritten the next time the app launches, so enabling is left to the app.
#
# Why sfltool and not System Events: `sfltool dumpbtm` reads the Background Task
# Management store, which covers both legacy login items and modern SMAppService
# registrations, and needs no Automation consent prompt. It also reports items
# that are registered but switched off, which is the common case on a machine
# where an app was installed but its login item was never enabled.
#
# Usage:
#   check-login-items.sh             compare this machine against the manifest
#   check-login-items.sh --list      print the current startup apps, nothing else
#   check-login-items.sh --capture   rewrite the manifest from this machine
#
# Exit status: 0 when the machine matches the manifest, 1 on drift, 2 on error.

set -euo pipefail
export LC_ALL=C

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST="${LOGIN_ITEMS_MANIFEST:-${SCRIPT_DIR}/../../macos/login-items.tsv}"
BTM_APP_TYPE='app (0x2)'

if [ -t 1 ]; then
  C_RED=$'\033[31m'
  C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'
  C_DIM=$'\033[2m'
  C_OFF=$'\033[0m'
else
  C_RED='' C_GREEN='' C_YELLOW='' C_DIM='' C_OFF=''
fi

die() {
  printf 'error: %s\n' "$*" >&2
  exit 2
}

# Print $1 as lines, or nothing when empty. `printf '%s\n' ""` would emit one
# blank line, and comm(1) would then count that blank line as an entry.
lines() {
  if [ -n "${1:-}" ]; then printf '%s\n' "$1"; fi
}

require_macos() {
  [ "$(uname -s)" = "Darwin" ] || die "macOS only (this is $(uname -s))"
  command -v sfltool >/dev/null 2>&1 ||
    die "sfltool not found; Background Task Management needs macOS 13 or later"
}

# One row per app-type Background Task Management record owned by the current
# user, sorted by bundle id: bundle_id, enabled|disabled, name, app path.
btm_app_items() {
  sfltool dumpbtm 2>/dev/null | awk -v want_uid="$(id -u)" -v app_type="$BTM_APP_TYPE" '
    BEGIN {
      for (n = 32; n < 127; n++) unhex[sprintf("%02X", n)] = sprintf("%c", n)
    }
    function urldecode(s,   out, i, h) {
      out = ""
      i = 1
      while (i <= length(s)) {
        h = toupper(substr(s, i + 1, 2))
        if (substr(s, i, 1) == "%" && (h in unhex)) {
          out = out unhex[h]
          i += 3
        } else {
          out = out substr(s, i, 1)
          i += 1
        }
      }
      return out
    }
    function apppath(u,   p) {
      if (u == "" || u == "(null)") return ""
      p = u
      sub(/^file:\/\//, "", p)
      sub(/\/$/, "", p)
      return urldecode(p)
    }
    function flush(   key) {
      if (name != "" && type == app_type && uid == want_uid) {
        key = bundle
        if (key == "") { key = ident; sub(/^2\./, "", key) }
        printf "%s\t%s\t%s\t%s\n", key,
          (disp ~ /^\[enabled/ ? "enabled" : "disabled"), name, apppath(url)
      }
      name = ""; type = ""; disp = ""; ident = ""; bundle = ""; url = ""
    }
    /Records for UID/         { flush(); uid = $4; next }
    /^ *#[0-9]+:/             { flush(); next }
    /^ *Name:/                { sub(/^ *Name: */, "");              name   = $0; next }
    /^ *Type:/                { sub(/^ *Type: */, "");              type   = $0; next }
    /^ *Disposition:/         { sub(/^ *Disposition: */, "");        disp   = $0; next }
    /^ *Identifier:/          { sub(/^ *Identifier: */, "");         ident  = $0; next }
    /^ *Bundle Identifier:/   { sub(/^ *Bundle Identifier: */, "");  bundle = $0; next }
    /^ *URL:/                 { sub(/^ *URL: */, "");               url    = $0; next }
    END                       { flush() }
  ' | sort
}

manifest_rows() {
  [ -f "$MANIFEST" ] || die "manifest not found: $MANIFEST"
  grep -v -e '^#' -e '^[[:space:]]*$' "$MANIFEST" || true
}

# Look up one tab-separated row by bundle id. $1 rows, $2 bundle id.
row_for() {
  lines "$1" | awk -F'\t' -v key="$2" '$1 == key { print; exit }'
}

# Turn an install column value into an actionable sentence.
install_hint() {
  case "${1:-}" in
    brew:*) printf 'install with: brew install --cask %s' "${1#brew:}" ;;
    manual) printf 'install manually (no Homebrew cask exists)' ;;
    *) printf 'install source unrecorded' ;;
  esac
}

cmd_list() {
  local current
  current="$(btm_app_items)"
  printf '%s%-9s %-30s %s%s\n' "$C_DIM" STATE BUNDLE_ID NAME "$C_OFF"
  lines "$current" | awk -F'\t' '{ printf "%-9s %-30s %s\n", $2, $1, $3 }'
}

cmd_capture() {
  local current tmp count
  current="$(btm_app_items | awk -F'\t' '$2 == "enabled"')"
  [ -n "$current" ] || die "no enabled startup apps found; refusing to write an empty manifest"

  tmp="${MANIFEST}.tmp.$$"
  trap 'rm -f "$tmp"' EXIT

  # Keep the comment header verbatim so a capture produces a minimal git diff.
  awk '/^#/ || /^[[:space:]]*$/ { print; next } { exit }' "$MANIFEST" >"$tmp" 2>/dev/null ||
    die "cannot read existing manifest header: $MANIFEST"

  local existing
  existing="$(manifest_rows)"
  while IFS=$'\t' read -r id _state name path; do
    [ -n "$id" ] || continue
    local install
    install="$(row_for "$existing" "$id" | cut -f4)"
    printf '%s\t%s\t%s\t%s\n' "$id" "$name" "$path" "${install:-unknown}" >>"$tmp"
  done <<EOF
$current
EOF

  mv "$tmp" "$MANIFEST"
  trap - EXIT
  count="$(lines "$current" | wc -l | tr -d ' ')"
  printf '%sWrote %s startup apps to %s%s\n' "$C_GREEN" "$count" "$MANIFEST" "$C_OFF"
  printf 'Review with `git diff -- %s`; fill in any "unknown" install values.\n' "$MANIFEST"
}

cmd_check() {
  local current expected enabled_ids expected_ids missing extra rc=0
  current="$(btm_app_items)"
  expected="$(manifest_rows)"

  enabled_ids="$(lines "$current" | awk -F'\t' '$2 == "enabled" { print $1 }' | sort)"
  expected_ids="$(lines "$expected" | cut -f1 | sort)"

  missing="$(comm -23 <(lines "$expected_ids") <(lines "$enabled_ids"))"
  extra="$(comm -13 <(lines "$expected_ids") <(lines "$enabled_ids"))"

  printf '%s expected, %s enabled on this machine\n\n' \
    "$(lines "$expected_ids" | wc -l | tr -d ' ')" \
    "$(lines "$enabled_ids" | wc -l | tr -d ' ')"

  if [ -n "$missing" ]; then
    rc=1
    printf '%snot enabled (%s)%s\n' "$C_RED" "$(lines "$missing" | wc -l | tr -d ' ')" "$C_OFF"
    while IFS= read -r id; do
      [ -n "$id" ] || continue
      local row name install state
      row="$(row_for "$expected" "$id")"
      name="$(printf '%s' "$row" | cut -f2)"
      install="$(printf '%s' "$row" | cut -f4)"
      state="$(row_for "$current" "$id" | cut -f2)"
      printf '  %-28s %s%s%s\n' "$name" "$C_DIM" "$id" "$C_OFF"
      if [ "$state" = "disabled" ]; then
        printf '    registered but switched off -- turn it on in System Settings >\n'
        printf '    General > Login Items & Extensions, or in the app'"'"'s preferences\n'
      else
        printf '    not registered -- %s, then enable "Open at Login"\n' "$(install_hint "$install")"
      fi
    done <<EOF
$missing
EOF
    printf '\n'
  fi

  if [ -n "$extra" ]; then
    rc=1
    printf '%sunexpected (%s)%s\n' "$C_YELLOW" "$(lines "$extra" | wc -l | tr -d ' ')" "$C_OFF"
    while IFS= read -r id; do
      [ -n "$id" ] || continue
      printf '  %-28s %s%s%s\n' "$(row_for "$current" "$id" | cut -f3)" "$C_DIM" "$id" "$C_OFF"
    done <<EOF
$extra
EOF
    printf '    enabled here but absent from the manifest -- adopt it with --capture,\n'
    printf '    or switch it off if it is not wanted\n\n'
  fi

  if [ "$rc" -eq 0 ]; then
    printf '%sAll startup apps match the manifest.%s\n' "$C_GREEN" "$C_OFF"
  fi
  return "$rc"
}

main() {
  require_macos
  case "${1:-}" in
    '' | --check) cmd_check ;;
    --list) cmd_list ;;
    --capture) cmd_capture ;;
    -h | --help) sed -n '3,26p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//' ;;
    *) die "unknown option: $1 (try --help)" ;;
  esac
}

main "$@"
