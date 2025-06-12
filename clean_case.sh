#!/bin/bash

# Define the directories to clean
DIRS=(
  "./case/pitzDaily/processor0"
  "./case/pitzDaily/processor1"
  "./case/pitzDaily/postProcessing"
  "./case/pitzDaily/constant/polyMesh"
  "./case/pitzDaily/100"
  "./case/pitzDaily/200"
  "./case/pitzDaily/287"
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

