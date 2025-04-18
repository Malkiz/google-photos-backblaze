#!/bin/bash

# Usage: ./copy_album_real.sh "source_album_path" "destination_base_path" [--dry-run]

src="$1"
dest="$2"
dry_run=false

# Check for dry-run flag
if [[ "$3" == "--dry-run" ]]; then
  dry_run=true
fi

if [ -z "$src" ] || [ -z "$dest" ]; then
  echo "Usage: $0 <source_album_path> <destination_base_path> [--dry-run]"
  exit 1
fi

echo "📁 Scanning source: $src"
echo "📂 Target base: $dest"
$dry_run && echo "🔍 Dry-run mode ON"

find -L "$src" -type f -exec bash -c '
  dest="$0"
  dry_run="$1"
  shift 2
  for f; do
    y=$(date -r "$f" +%Y)
    m=$(date -r "$f" +%m)
    dir="$dest/$y/$m"
    file_name=$(basename "$f")
    target="$dir/$file_name"

    if [ -e "$target" ]; then
      echo "⏭️  Skipping existing file: $target"
      continue
    fi

    echo "➡️  Copying $f to $target"
    if [ "$dry_run" != "true" ]; then
      mkdir -p "$dir"
      cp -aL "$f" "$target"
    fi
  done
' "$dest" "$dry_run" {} +

echo "✅ Done."

