#!/usr/bin/env bash

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source_dir="$repo_dir/common_dotfiles/.gemini"
target_dir="$HOME/.gemini"
backup_dir=''

# Unfold only directory links owned by this repository.
ensure_directory() {
  local destination="$1" source="$2"
  if [ -L "$destination" ]; then
    if [ "$(readlink -f "$destination")" != "$source" ]; then
      printf 'Refusing unexpected directory symlink: %s\n' "$destination" >&2
      return 1
    fi
    rm "$destination"
  fi
  mkdir -p "$destination"
}

# Move state left by a folded Stow directory without overwriting local state.
move_runtime() {
  local source="$1" destination="$2" entry target
  for entry in "$source"/* "$source"/.[!.]* "$source"/..?*; do
    [ -e "$entry" ] || [ -L "$entry" ] || continue
    case "$entry" in
      "$source_dir/antigravity-cli/settings.json" | \
      "$source_dir/antigravity-cli/statusline.sh") continue ;;
    esac
    target="$destination/${entry##*/}"
    if [ "$entry" = "$source_dir/antigravity-cli" ]; then
      ensure_directory "$target" "$entry"
      move_runtime "$entry" "$target"
    elif [ ! -e "$target" ] && [ ! -L "$target" ]; then
      mv "$entry" "$target"
    elif [ -d "$entry" ] && [ ! -L "$entry" ] && \
         [ -d "$target" ] && [ ! -L "$target" ]; then
      move_runtime "$entry" "$target"
      rmdir "$entry"
    else
      printf 'Runtime state exists in both locations; preserved both: %s and %s\n' \
        "$entry" "$target" >&2
      return 1
    fi
  done
}

for name in settings.json statusline.sh; do
  if [ ! -f "$source_dir/antigravity-cli/$name" ]; then
    printf 'Missing tracked Antigravity config: %s\n' "$name" >&2
    exit 1
  fi
done

ensure_directory "$target_dir" "$source_dir"
ensure_directory "$target_dir/antigravity-cli" "$source_dir/antigravity-cli"
move_runtime "$source_dir" "$target_dir"

for name in settings.json statusline.sh; do
  source="$source_dir/antigravity-cli/$name"
  target="$target_dir/antigravity-cli/$name"
  if [ -L "$target" ] && [ "$(readlink -f "$target")" = "$source" ]; then
    continue
  fi
  if [ -e "$target" ] || [ -L "$target" ]; then
    if [ -z "$backup_dir" ]; then
      backup_dir="$(mktemp -d "$target_dir/antigravity-cli/.dotfiles-backup.XXXXXX")"
      printf 'Preserving existing Antigravity configs in %s\n' "$backup_dir"
    fi
    mv "$target" "$backup_dir/$name"
  fi
  ln -s "$source" "$target"
done

printf 'Antigravity configs linked; runtime state stays in %s\n' "$target_dir"
