#!/usr/bin/env bash
# Install the Firecrawl CLI and agent skills.

set -euo pipefail

if ! command -v npx >/dev/null 2>&1; then
  echo "npx is required. Install Node.js and npm first." >&2
  exit 1
fi

echo "Installing Firecrawl CLI and agent skills..."
npx -y firecrawl-cli@latest init --all --browser

echo "Done! Firecrawl is installed and authenticated."
