#!/usr/bin/env bash

# Ermine Build Script
# This script builds all Ermine components from source using Docker.

set -e

# Configuration
BASE_IMAGE_NAME="ermine/base"
TAG_PREFIX="ermine"
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

echo "=== Building Ermine ==="

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
    "crond:src/backend/crates/daemons/crond"
    "pushd:src/backend/crates/daemons/pushd"
    "voice-ingress:src/backend/crates/daemons/voice-ingress"
)

for service_info in "${services[@]}"; do
    name="${service_info%%:*}"
    dir="${service_info#*:}"
    echo "--- Building Backend Service: $name ---"
    
    # We pipe the modified Dockerfile to docker build to use our local base image
    cat "$dir/Dockerfile" | sed "s|ghcr.io/erminechat/base:latest|$BASE_IMAGE_NAME|g" | \
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
    image: ermine/api
  events:
    image: ermine/events
  autumn:
    image: ermine/autumn
  january:
    image: ermine/january
  gifbox:
    image: ermine/gifbox
  crond:
    image: ermine/crond
  pushd:
    image: ermine/pushd
  voice-ingress:
    image: ermine/voice-ingress
  web:
    image: ermine/web
EOF
    echo "compose.override.yml generated successfully."
else
    echo ""
    echo "To use these images, you can run:"
    echo "./build.sh --generate-override"
fi
