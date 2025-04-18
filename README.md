# Google Photos → Backblaze Workflow

This project contains four Bash scripts that help you manage photo albums from Google Photos, organize them locally, back them up to Backblaze B2, and restore them with timestamps preserved.

## Scripts

### 1. `sync_album.sh`

Downloads a specific album from your Google Photos account using `gphotos-sync`.

**Usage:**
```bash
./sync_album.sh "Album Name"
```

This will sync the specified album into the `photos` directory.

### 2. `copy_album_real.sh`

Copies files from an album's symlink folder into a new location, organizing them by year/month based on each file’s modified date.

**Usage:**
```bash
./copy_album_real.sh <source_album_path> <destination_base_path>
```
**Example**
```bash
./copy_album_real.sh "albums/2025/0326 מלע" "real-albums/מלע"
```

This will copy real files (not symlinks) into `real-albums/מלע/YYYY/MM/`.

### 3. `sync_to_b2.sh`

Uploads a local directory to a Backblaze B2 bucket using the `b2 sync` command.

**Usage:**
```bash
./sync_to_b2.sh <local_dir> <b2_dest_path>
```
**Example**
```bash
./sync_to_b2.sh "photos/real-albums/מלע" "b2://omri-google-photos/gphotos/real-albums/מלע"
```

### 4. `download_b2_dir.sh`

Downloads a full directory from Backblaze B2, preserving the folder structure and original modified timestamps.

**Usage:**
```bash
./download_b2_dir.sh <bucket_name> <remote_dir> <local_dest>
```
**Example**
```bash
./download_b2_dir.sh omri-google-photos gphotos/real-albums/מלע ./downloads/מלע
```

## Requirements

- gphotos-sync
- b2
- jq
- macOS or Unix-like system

## Notes

- Make sure you've authenticated gphotos-sync and b2 before running the scripts.
- Album names with special characters or spaces should be quoted.
- Timestamps are preserved using the src_last_modified_millis metadata in B2.
