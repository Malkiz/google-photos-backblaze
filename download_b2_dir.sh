#!/bin/bash

# Usage: ./download_b2_dir.sh <bucket> <remote_dir> <local_dir>
# Example: ./download_b2_dir.sh omri-google-photos gphotos/real-albums/מלע ./downloads/מלע

BUCKET="$1"
REMOTE_DIR="$2"
LOCAL_BASE="$3"

if [[ -z "$BUCKET" || -z "$REMOTE_DIR" || -z "$LOCAL_BASE" ]]; then
  echo "Usage: $0 <bucket> <remote_dir> <local_dir>"
  exit 1
fi

# Remove any trailing slashes from remote dir for clean prefixing
REMOTE_DIR="${REMOTE_DIR%/}"

b2 ls --long --recursive "b2://$BUCKET/$REMOTE_DIR" | while read -r line; do
  # Get the last field (full remote path)
  remote_path="${line##* }"

  # Make sure it starts with REMOTE_DIR
  if [[ "$remote_path" == "$REMOTE_DIR/"* ]]; then
    # Strip prefix to get relative path
    rel_path="${remote_path#$REMOTE_DIR/}"
    local_path="$LOCAL_BASE/$rel_path"

    echo "Downloading: $remote_path → $local_path"

    # Create the local directory structure if needed
    mkdir -p "$(dirname "$local_path")"

    # Download the file
    b2 file download "b2://$BUCKET/$remote_path" "$local_path"

    # Get metadata and apply timestamp
    meta=$(b2 file info "b2://$BUCKET/$remote_path")
    millis=$(jq -r '.fileInfo["src_last_modified_millis"]' <<< "$meta")

    if [[ "$millis" != "null" && "$millis" =~ ^[0-9]+$ ]]; then
      seconds=$((10#${millis} / 1000))
      date_str=$(date -r "$seconds" +"%Y%m%d%H%M.%S")
      touch -t "$date_str" "$local_path"
      echo "→ Timestamp applied: $date_str"
    else
      echo "→ No timestamp found, skipping touch."
    fi
  fi
done

