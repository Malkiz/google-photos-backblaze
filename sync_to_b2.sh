#!/bin/bash

# Exit if any command fails
set -e

# Check arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <src_directory> <b2_destination>"
  echo "Example: $0 'photos/real-albums/מלע' 'b2://omri-google-photos/gphotos/real-albums/מלע'"
  exit 1
fi

SRC="$1"
DEST="$2"

# Run the b2 sync command
b2 sync "$SRC" "$DEST"

