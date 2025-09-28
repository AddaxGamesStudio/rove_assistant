#!/bin/bash

# Define base directory
base_dir="./"
data_dirs=("$base_dir/rove_data/core" "$base_dir/rove_data/xulc")

# List of specific target directories
target_projects=("rove_assistant")

# Check if the data directories exist
for data_dir in "${data_dirs[@]}"; do
  if [[ ! -d "$data_dir" ]]; then
    echo "Error: Data directory $data_dir does not exist."
    exit 1
  fi
done

# Loop through specified target directories
for project_name in "${target_projects[@]}"; do
  project="$base_dir/$project_name"

  # Ensure it's a directory
  if [[ -d "$project" ]]; then
    echo "Updating assets for $project_name..."

    # Process each data directory
    for data_dir in "${data_dirs[@]}"; do
      # Extract the folder name (core or xulc)
      folder_name=$(basename "$data_dir")
      project_assets="$project/assets/$folder_name"

      # Ensure the target directory exists
      mkdir -p "$project_assets"

      # Copy all files and subdirectories recursively
      echo "Copying all files and folders from $data_dir to $project_assets..."
      cp -R "$data_dir/"* "$project_assets/"
    done
  else
    echo "Skipping $project_name (directory does not exist)."
  fi
done

echo "All specified projects updated!"