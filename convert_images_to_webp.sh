#!/bin/bash

# Check if the cwebp command is available
if ! command -v cwebp &> /dev/null; then
    echo "Error: cwebp is not installed. Please install it first."
    exit 1
fi

# Function to convert images to WebP
convert_to_webp() {
    local input_file="$1"
    local output_file="${input_file%.*}.webp"

    # Convert the image to WebP format
    cwebp -q 80 -sharp_yuv "$input_file" -o "$output_file" > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "Converted: $input_file -> $output_file"
    else
        echo "Failed to convert: $input_file"
    fi
}

# Main script
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

input_directory="$1"

# Find all image files recursively and process them
find "$input_directory" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.bmp" -o -iname "*.tiff" -o -iname "*.gif" \) | while read -r file; do
    convert_to_webp "$file"
done
