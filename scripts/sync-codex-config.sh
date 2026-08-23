#!/usr/bin/env bash

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tracked_config="$repo_dir/common_dotfiles/.codex/config.toml"
codex_dir="$HOME/.codex"
user_config="$codex_dir/config.toml"
base_config="$codex_dir/.config.toml.base"

copy_private() {
  local source="$1"
  local destination="$2"
  local temporary

  temporary="$(mktemp "$codex_dir/.config.toml.XXXXXX")"
  cp "$source" "$temporary"
  chmod 600 "$temporary"
  mv -f "$temporary" "$destination"
}

if [ ! -f "$tracked_config" ]; then
  printf 'Codex config source is missing: %s\n' "$tracked_config" >&2
  exit 1
fi

if [ "${1:-}" = "--check" ]; then
  if [ ! -f "$user_config" ] || [ -L "$user_config" ]; then
    printf 'Codex user config is not a regular file: %s\n' "$user_config" >&2
    exit 1
  fi
  if [ ! -f "$base_config" ] || [ -L "$base_config" ] || ! cmp -s "$base_config" "$tracked_config"; then
    printf 'Codex tracked base is not synchronized: %s\n' "$base_config" >&2
    exit 1
  fi
  printf 'Codex config layout is valid\n'
  exit 0
fi

mkdir -p "$codex_dir"

if [ -L "$user_config" ]; then
  if [ "$(readlink -f "$user_config")" != "$tracked_config" ]; then
    printf 'Refusing to replace unexpected Codex config symlink: %s\n' "$user_config" >&2
    exit 1
  fi
  copy_private "$tracked_config" "$user_config"
  copy_private "$tracked_config" "$base_config"
  printf 'Detached Codex user config from tracked config\n'
  exit 0
fi

if [ -e "$user_config" ] && [ ! -f "$user_config" ]; then
  printf 'Codex user config is not a regular file: %s\n' "$user_config" >&2
  exit 1
fi

if [ -e "$base_config" ] && { [ -L "$base_config" ] || [ ! -f "$base_config" ]; }; then
  printf 'Codex merge base is not a regular file: %s\n' "$base_config" >&2
  exit 1
fi

if [ ! -e "$user_config" ]; then
  copy_private "$tracked_config" "$user_config"
  copy_private "$tracked_config" "$base_config"
  printf 'Installed Codex user config from tracked defaults\n'
  exit 0
fi

chmod 600 "$user_config"

if [ ! -e "$base_config" ]; then
  copy_private "$tracked_config" "$base_config"
  printf 'Adopted existing Codex user config without overwriting it\n'
  exit 0
fi

if cmp -s "$base_config" "$tracked_config"; then
  printf 'Codex tracked defaults are already synchronized\n'
  exit 0
fi

before_checksum="$(cksum <"$user_config")"
merge_output="$(mktemp "$codex_dir/.config.toml.merge.XXXXXX")"
set +e
git merge-file -p "$user_config" "$base_config" "$tracked_config" >"$merge_output"
merge_status=$?
set -e

if [ "$merge_status" -eq 1 ]; then
  conflict_file="$codex_dir/config.toml.merge-conflict"
  chmod 600 "$merge_output"
  mv -f "$merge_output" "$conflict_file"
  printf 'Codex config merge conflict; original preserved, resolve: %s\n' "$conflict_file" >&2
  exit 1
fi

if [ "$merge_status" -ne 0 ]; then
  rm -f "$merge_output"
  printf 'Codex config merge failed with status %s\n' "$merge_status" >&2
  exit "$merge_status"
fi

# ponytail: checksum narrows the concurrent App-write race; a complete lock requires App support.
if [ "$(cksum <"$user_config")" != "$before_checksum" ]; then
  conflict_file="$codex_dir/config.toml.merge-raced"
  chmod 600 "$merge_output"
  mv -f "$merge_output" "$conflict_file"
  printf 'Codex App changed config during merge; original preserved, candidate: %s\n' "$conflict_file" >&2
  exit 1
fi

chmod 600 "$merge_output"
mv -f "$merge_output" "$user_config"
copy_private "$tracked_config" "$base_config"
printf 'Merged tracked Codex defaults into machine-local config\n'
