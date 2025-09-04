#!/bin/bash

# Build script for Docker images with versioning support
# Usage: ./scripts/build-docker.sh [environment] [build_number]

set -e

# Default values
ENVIRONMENT=${1:-Development}
BUILD_NUMBER=${2:-$(date +%Y%m%d)}
BUILD_CONFIGURATION=${BUILD_CONFIGURATION:-Release}

# Get git information
GIT_COMMIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")

# Set version suffix based on environment
case $ENVIRONMENT in
    "Production")
        VERSION_SUFFIX=""
        ;;
    "Staging")
        VERSION_SUFFIX="rc"
        ;;
    "Testing")
        VERSION_SUFFIX="test"
        ;;
    "Development")
        VERSION_SUFFIX="dev"
        ;;
    *)
        VERSION_SUFFIX="dev"
        ;;
esac

# Build the Docker image
echo "Building Docker image for environment: $ENVIRONMENT"
echo "Build Number: $BUILD_NUMBER"
echo "Git Commit: $GIT_COMMIT_HASH"
echo "Git Branch: $GIT_BRANCH"

docker build \
    --build-arg BUILD_CONFIGURATION=$BUILD_CONFIGURATION \
    --build-arg BUILD_NUMBER=$BUILD_NUMBER \
    --build-arg GIT_COMMIT_HASH=$GIT_COMMIT_HASH \
    --build-arg BUILD_SOURCEBRANCHNAME=$GIT_BRANCH \
    --build-arg ASPNETCORE_ENVIRONMENT=$ENVIRONMENT \
    -f src/Karage.Web/Dockerfile \
    -t karage-api:latest \
    -t karage-api:$BUILD_NUMBER \
    .

echo "Docker image built successfully!"
echo "Tags: karage-api:latest, karage-api:$BUILD_NUMBER"