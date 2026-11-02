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
echo "=== Step 2: Checking pnpm uses the hoisted linker ==="
linker=$(docker run --rm spfx:local pnpm config get node-linker)
if [ "$linker" != "hoisted" ]; then
  echo "Error: pnpm node-linker is '$linker', expected 'hoisted'." >&2
  exit 1
fi
echo "node-linker: $linker"

echo ""
echo "=== Step 3: Running tests (scaffold + build) ==="
docker build --target test-webpart .
docker build --target test-webpart-pnpm .
docker build --target test-webpart-yarn .

echo ""
echo "=== All checks passed ==="
