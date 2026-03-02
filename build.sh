#!/usr/bin/env bash

# Ermin Build Script
# This script builds all Ermin components from source using Docker.

set -e

# Configuration
BASE_IMAGE_NAME="ermin/base"
TAG_PREFIX="ermin"
BACKEND_DIR="src/backend"
FRONTEND_DIR="src/frontend-new"
GENERATE_OVERRIDE=false

# Parse arguments
for arg in "$@"; do
    case $arg in
        --generate-override)
            GENERATE_OVERRIDE=true
            shift
            ;;
        --help)
            echo "Usage: ./build.sh [options]"
            echo "Options:"
            echo "  --generate-override    Generate a compose.override.yml file to use the built images"
            echo "  --help                 Show this help message"
            exit 0
            ;;
    esac
done

# Check for docker
if ! command -v docker &> /dev/null; then
    echo "Error: docker is not installed."
    exit 1
fi

echo "=== Building Ermin ==="

# 1. Build Backend Base Image
echo "--- Building Backend Base Image ---"
# We use Dockerfile.useCurrentArch to build for the host architecture efficiently.
docker build -t "$BASE_IMAGE_NAME" -f "$BACKEND_DIR/Dockerfile.useCurrentArch" "$BACKEND_DIR"

# 2. Build Backend Services
# These services depend on the base image.
services=(
    "api:src/backend/crates/delta"
    "events:src/backend/crates/bonfire"
    "autumn:src/backend/crates/services/autumn"
    "january:src/backend/crates/services/january"
    "gifbox:src/backend/crates/services/gifbox"
    "fediverse:src/backend/crates/services/fediverse"
    "discord_bridge:src/backend/crates/services/discord_bridge"
    "crond:src/backend/crates/daemons/crond"
    "pushd:src/backend/crates/daemons/pushd"
    "voice-ingress:src/backend/crates/daemons/voice-ingress"
)

for service_info in "${services[@]}"; do
    name="${service_info%%:*}"
    dir="${service_info#*:}"
    echo "--- Building Backend Service: $name ---"
    
    # We pipe the modified Dockerfile to docker build to use our local base image
    cat "$dir/Dockerfile" | sed "s|ghcr.io/erminchat/base:latest|$BASE_IMAGE_NAME|g" | \
        docker build -t "$TAG_PREFIX/$name" -f - "$dir"
done

# 3. Build Frontend
echo "--- Building Frontend ---"
docker build -t "$TAG_PREFIX/web" -f "$FRONTEND_DIR/Dockerfile" "$FRONTEND_DIR"

echo ""
echo "=== Build Complete ==="
echo "Images built:"
docker images | grep "$TAG_PREFIX/" || echo "No images with tag prefix $TAG_PREFIX/ found."

if [ "$GENERATE_OVERRIDE" = true ]; then
    echo "--- Generating compose.override.yml ---"
    cat > compose.override.yml <<EOF
services:
  api:
    image: ermin/api
  events:
    image: ermin/events
  autumn:
    image: ermin/autumn
  january:
    image: ermin/january
  gifbox:
    image: ermin/gifbox
  fediverse:
    image: ermin/fediverse
  discord_bridge:
    image: ermin/discord_bridge
  crond:
    image: ermin/crond
  pushd:
    image: ermin/pushd
  voice-ingress:
    image: ermin/voice-ingress
  web:
    image: ermin/web
EOF
    echo "compose.override.yml generated successfully."
else
    echo ""
    echo "To use these images, you can run:"
    echo "./build.sh --generate-override"
fi
