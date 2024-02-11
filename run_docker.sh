#!/bin/bash

# Get the current Git branch name or use a default name if not available
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "default_branch")

# Define Docker image name and tag
DOCKER_IMAGE="mycppapp:$CURRENT_BRANCH"
REBUILD=false

# Parse command-line options
while [[ $# -gt 0 ]]; do
    key="$1"

    case "$key" in
        --rebuild)
            REBUILD=true
            shift
            ;;
        *)
            echo "Unknown option: $key"
            exit 1
            ;;
    esac
done

# Check if the Docker image exists
if [[ "$REBUILD" == true || "$(docker images -q $DOCKER_IMAGE 2> /dev/null)" == "" ]]; then
  echo "Docker image $DOCKER_IMAGE not found or --rebuild option specified. Building..."
  # Build the Docker image
  docker build -t "$DOCKER_IMAGE" .
fi

# Run the Docker container
docker run -it --rm "$DOCKER_IMAGE" /bin/bash

# The script continues after the Docker container exits
echo "Docker container has exited."
