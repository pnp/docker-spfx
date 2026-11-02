#!/usr/bin/env bash
set -euo pipefail

# Run from the repo root so the docker build context is correct
cd "$(dirname "$0")/.."

# Ensure docker buildx is available
if ! docker buildx version &>/dev/null; then
  echo "Error: docker buildx is required but not available." >&2
  exit 1
fi

echo "=== Step 1: Building default image ==="
docker build --target default -t spfx:local .

echo ""
echo "=== Step 2: Running tests (scaffold + build) ==="
docker build --target test-webpart .
docker build --target test-webpart-pnpm .
docker build --target test-webpart-yarn .

echo ""
echo "=== All checks passed ==="
