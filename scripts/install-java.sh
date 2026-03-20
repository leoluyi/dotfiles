#!/usr/bin/env bash
set -eo pipefail

# ---------------------------------------------------------------------------
# Install Java (Temurin 17 & 21), Maven, and Gradle via SDKMAN
# ---------------------------------------------------------------------------

readonly GREEN="$(tput setaf 2)"
readonly YELLOW="$(tput setaf 3)"
readonly RED="$(tput setaf 1)"
readonly RESET="$(tput sgr 0)"

info()  { printf '%s%s%s\n' "$GREEN"  "$1" "$RESET"; }
warn()  { printf '%s%s%s\n' "$YELLOW" "$1" "$RESET"; }
error() { printf '%s%s%s\n' "$RED"    "$1" "$RESET" >&2; }

# --- Source SDKMAN ----------------------------------------------------------

init_sdkman() {
  if command -v sdk &>/dev/null; then
    return 0
  fi

  # Homebrew install (macOS)
  if [[ -n "${HOMEBREW_PREFIX:-}" && -d "${HOMEBREW_PREFIX}/opt/sdkman-cli" ]]; then
    export SDKMAN_DIR="${HOMEBREW_PREFIX}/opt/sdkman-cli/libexec"
  fi

  # Curl-based install fallback
  if [[ -z "${SDKMAN_DIR:-}" && -d "${HOME}/.sdkman" ]]; then
    export SDKMAN_DIR="${HOME}/.sdkman"
  fi

  local init_script="${SDKMAN_DIR:-}/bin/sdkman-init.sh"
  if [[ -s "$init_script" ]]; then
    # shellcheck disable=SC1090
    source "$init_script"
  else
    error "SDKMAN not found. Install it first:"
    error "  brew install sdkman/tap/sdkman-cli"
    error "  -- or --"
    error "  curl -s https://get.sdkman.io | bash"
    exit 1
  fi
}

# --- Version resolver -------------------------------------------------------

resolve_temurin_version() {
  local major="$1"
  local resolved
  resolved="$(sdk list java 2>/dev/null \
    | grep -oE "${major}\.[0-9]+(\.[0-9]+)?-tem" \
    | head -1)"
  if [[ -z "$resolved" ]]; then
    error "Could not resolve Temurin version for Java $major"
    return 1
  fi
  printf '%s' "$resolved"
}

# --- Install helper ---------------------------------------------------------

install_if_missing() {
  local candidate="$1"
  local version="${2:-}"

  if [[ -n "$version" ]]; then
    # Check if specific version is already installed
    if sdk list "$candidate" 2>/dev/null | grep -q "installed.*${version}" \
       || [[ -d "${SDKMAN_DIR}/candidates/${candidate}/${version}" ]]; then
      info "  $candidate $version is already installed -- skipping"
      return 0
    fi
    info "  Installing $candidate $version ..."
    sdk install "$candidate" "$version" < /dev/null
  else
    # Latest version -- check if any version is installed
    if sdk current "$candidate" 2>/dev/null | grep -q "Using"; then
      info "  $candidate is already installed -- skipping"
      return 0
    fi
    info "  Installing $candidate (latest) ..."
    sdk install "$candidate" < /dev/null
  fi
}

# --- Main -------------------------------------------------------------------

main() {
  info "=== Java Development Environment Setup ==="
  echo

  init_sdkman
  export sdkman_auto_answer=true

  # Java versions
  info "--- Java (Temurin) ---"
  local java17 java21
  java17="$(resolve_temurin_version 17)"
  java21="$(resolve_temurin_version 21)"
  info "  Resolved: Java 17 -> $java17, Java 21 -> $java21"
  install_if_missing java "$java17"
  install_if_missing java "$java21"
  echo

  # Set Java 21 as default (use native binary to avoid legacy deprecation notice)
  info "--- Setting Java $java21 as default ---"
  "${SDKMAN_DIR}/libexec/default" java "$java21"
  echo

  # Build tools
  info "--- Build Tools ---"
  install_if_missing maven
  install_if_missing gradle
  echo

  # Summary
  info "=== Installation Summary ==="
  echo
  info "Java:"
  java -version 2>&1 | head -1
  echo
  info "Maven:"
  mvn -version 2>&1 | head -1
  echo
  info "Gradle:"
  gradle -version 2>&1 | grep "^Gradle" || true
}

main "$@"
