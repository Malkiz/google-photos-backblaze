#!/bin/bash

# Usage: ./sync_album.sh "Album Name"

album="$1"

if [ -z "$album" ]; then
  echo "❗ Error: Please provide an album name."
  echo "Usage: $0 \"Album Name\""
  exit 1
fi

echo "🔄 Syncing album: $album"
gphotos-sync ./photos --album "$album"

