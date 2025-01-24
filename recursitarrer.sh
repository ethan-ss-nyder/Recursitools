#!/bin/bash

# Recursively tars subdirectories
# Essentially replaces every folder under a given root directory with a compressed .tar
# Then tars up the root as well

# Define the root directory to be archived
ROOT_DIR="./"
OUTPUT_FILE="final_renameable_archive.tar"

# Exclude any file names?
# EXCLUDE_FILE_LIST=("WAVECAR" "CHG")

# Helper function to build the --exclude arguments for tar
build_exclude_args() {
    local exclude_args=()
    for file in "${EXCLUDE_LIST[@]}"; do
        exclude_args+=("--exclude=$file")
    done
    echo "${exclude_args[@]}"
}

# Function to compress all subdirectories
compress_subdirs() {
    local exclude_args
    exclude_args=$(build_exclude_args)

    find "$ROOT_DIR" -type d | while read -r dir; do
        # Replace / with underscores in tar filenames to avoid overwriting
        relative_dir="${dir#$ROOT_DIR/}"
        archive_name="$(echo "$relative_dir" | tr '/' '_').tar"
        
        # Skip if already compressed
        if [[ -f "$dir/$archive_name" ]]; then
            echo "Skipping $dir, already compressed."
            continue
        fi

        echo "Compressing $dir -> $dir/$archive_name"
        tar -cf "$dir/$archive_name" -C "$dir" . $exclude_args
    done
}

# Step 1: Compress subdirectories
compress_subdirs

# Step 2: Create the final tar archive of the entire structure
echo "Creating final archive $OUTPUT_FILE..."
tar -cf "$OUTPUT_FILE" -C "$ROOT_DIR" . $(build_exclude_args)

echo "Done! The final archive is $OUTPUT_FILE."
