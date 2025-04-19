#!/bin/bash

# Define the directories to clean
DIRS=(
  "./case/pitzDaily/processors2"
  "./case/pitzDaily/constant/polyMesh"
)

echo "🧹 Cleaning up OpenFOAM case directories..."

for dir in "${DIRS[@]}"; do
  if [ -d "$dir" ]; then
    echo "🔸 Removing: $dir"
    rm -rf "$dir"
  else
    echo "⚠️  Skipped (not found): $dir"
  fi
done

echo "✅ Cleanup complete."

