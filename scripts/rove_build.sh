#!/bin/bash

# Script to update data and build the rove_assistant Flutter app
# Usage: ./scripts/rove_build.sh [flutter build subcommand and arguments]
# Example: ./scripts/rove_build.sh macos

set -e  # Exit on any error

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🔄 Updating data assets..."
# Run the data update script first
"$SCRIPT_DIR/rove_update_data.sh"

if [ $? -ne 0 ]; then
  echo "❌ Failed to update data assets"
  exit 1
fi

echo "✅ Data assets updated successfully"

# Change to the rove_assistant directory
cd "$PROJECT_ROOT/rove_assistant"

echo "🏗️  Building Flutter app..."

# Check if any arguments were provided
if [ $# -eq 0 ]; then
  echo "❌ Error: No build target specified"
  echo "Usage: ./scripts/rove_build.sh [flutter build subcommand and arguments]"
  echo "Examples:"
  echo "  ./scripts/rove_build.sh macos"
  echo "  ./scripts/rove_build.sh apk --release"
  echo "  ./scripts/rove_build.sh web"
  exit 1
fi

# Pass all arguments to flutter build
flutter build "$@"

if [ $? -eq 0 ]; then
  echo "✅ Flutter build completed successfully"
else
  echo "❌ Flutter build failed"
  exit 1
fi