#!/bin/bash
CONTAINER_NAME="c-dbt-core"
DOCKERHUB_REPOSITORY=keithfajardo/ # Change this to your Docker Hub repository
IMG_NAME=${DOCKERHUB_REPOSITORY}i-dbt-core:python3.12.10
CLEAN=false
CONTAINER_NETWORK="dbt-net"

function build_image() {
  if [[ "$CLEAN" == "true" ]]; then
    docker build \
      --no-cache \
      -t "${IMG_NAME}" \
      .
    RESTART_CONTAINER=true
  else
    docker build \
      -t "${IMG_NAME}" \
      .
  fi
}

function stop_container() {
  # Check if container is running
  if [ "$(docker ps -q -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "Container '$CONTAINER_NAME' is running. Stopping it..."
    docker stop "$CONTAINER_NAME"
  fi
}

function run_container() {
  # Check if the container exists (either running or stopped)
  if docker container inspect "$CONTAINER_NAME" > /dev/null 2>&1; then
    echo "Container '$CONTAINER_NAME' exists. Stopping it..."
    docker stop "$CONTAINER_NAME"
  fi

  # Wait until it's completely removed (if --rm is used)
  while docker container inspect "${CONTAINER_NAME}" > /dev/null 2>&1; do
    echo "Waiting for container '${CONTAINER_NAME}' to be fully removed..."
    sleep 1
  done

  echo "Running container ${CONTAINER_NAME}..."
  docker run \
    -d \
    --env-file .env \
    --network ${CONTAINER_NETWORK} \
    --rm \
    --name "${CONTAINER_NAME}" \
    "${IMG_NAME}" \
    tail -f /dev/null
}

# Parse flags
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --clean) CLEAN=true ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
  shift
done

# Check if image exists locally
if docker image inspect "${IMG_NAME}" > /dev/null 2>&1; then
  read -p "Image ${IMG_NAME} already exists. Do you want a clean build? (y/n): " CLEAN_INPUT
  if [[ "$CLEAN_INPUT" =~ ^[Yy]$ ]]; then
    echo "Running a clean build..."
    CLEAN=true
  fi
else
  echo "Image ${IMG_NAME} not found. Building image then running the container."
fi

build_image
run_container
