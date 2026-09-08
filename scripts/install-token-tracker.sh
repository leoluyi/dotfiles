#!/usr/bin/env bash
# Install Token Tracker (tt).

set -euo pipefail

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required." >&2
  exit 1
fi

curl -fsSL https://raw.githubusercontent.com/stormzhang/token-tracker/main/install.sh | bash
