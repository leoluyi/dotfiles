#!/usr/bin/env bash
# Merge tracked Claude Code defaults into the machine-local user settings.

set -euo pipefail
umask 077

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
template="${script_dir}/../common_dotfiles/.claude/settings.template.json"
claude_dir="${HOME}/.claude"
target="${claude_dir}/settings.json"

command -v jq >/dev/null || {
  echo "error: jq is required" >&2
  exit 1
}

[[ -f "${template}" ]] || {
  echo "error: missing Claude settings template: ${template}" >&2
  exit 1
}

mkdir -p "${claude_dir}"

if [[ -L "${target}" ]]; then
  echo "error: refusing to merge into symlinked Claude settings: ${target}" >&2
  exit 1
fi

tmp="$(mktemp "${claude_dir}/settings.json.tmp.XXXXXX")"
trap 'rm -f "${tmp}"' EXIT

if [[ -f "${target}" ]]; then
  jq -S -s '.[0] * .[1]' "${target}" "${template}" >"${tmp}"
else
  jq -S . "${template}" >"${tmp}"
fi

mv "${tmp}" "${target}"
trap - EXIT
echo "Merged Claude defaults into ${target}"
