#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# Pick the Quick Look engine that renders Markdown (.md) previews.
#
# macOS 12+ dropped legacy `.qlgenerator` bundles in favour of Quick Look app
# extensions (`.appex`), managed by `pluginkit` (NOT `qlmanage`). When several
# extensions register for the same UTI (`net.daringfireball.markdown`), macOS
# picks one with no user-facing chooser. To "specify" an engine you enable the
# one you want and ignore the competitors.
#
# NOTE: `pluginkit -e ignore` disables the WHOLE extension, not just its .md
# claim. Ignoring Syntax Highlight therefore also loses its source-code
# (.swift/.py/...) previews. Adjust the arrays below if that trade-off changes.
# For a per-UTI toggle, use the app's own settings instead of this script.
# ---------------------------------------------------------------------------

readonly GREEN="$(tput setaf 2 2>/dev/null || true)"
readonly YELLOW="$(tput setaf 3 2>/dev/null || true)"
readonly RESET="$(tput sgr 0 2>/dev/null || true)"

info() { printf '%s%s%s\n' "$GREEN" "$1" "$RESET"; }
warn() { printf '%s%s%s\n' "$YELLOW" "$1" "$RESET"; }

# Extension to prefer for Markdown previews (rendered output).
readonly PREFER="ltd.anybox.MarkdownPreview.Extension"

# Extensions that also claim .md and would compete with PREFER.
readonly IGNORE=(
  "org.sbarex.SourceCodeSyntaxHighlight.QuickLookExtension" # Syntax Highlight
  "com.findergg.iPreview.Preview"                           # iPreview
)

# True if pluginkit knows about this extension bundle id (installed/registered).
is_registered() {
  pluginkit -m -i "$1" 2>/dev/null | grep -q .
}

set_state() { # <use|ignore> <bundle-id>
  local action="$1" id="$2"
  if ! is_registered "$id"; then
    warn "skip (not installed): $id"
    return 0
  fi
  pluginkit -e "$action" -i "$id"
  info "$action: $id"
}

info "###### Configure Quick Look Markdown engine ######"

set_state use "$PREFER"
for id in "${IGNORE[@]}"; do
  set_state ignore "$id"
done

# Rebuild the Quick Look generator cache and relaunch Finder to apply.
qlmanage -r >/dev/null 2>&1 || true
qlmanage -r cache >/dev/null 2>&1 || true
killall Finder 2>/dev/null || true

info "Done. Select a .md file in Finder and press Space to verify the rendered preview."
