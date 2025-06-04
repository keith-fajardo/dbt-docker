#!/bin/bash

img_name="keithfajardo/i-dbt-core:python3.12.10"
cnt_name="c-dbt-core"

function build_clean() {
  # Build image
  docker build \
    --no-cache \
    -t "${img_name}" \
    .
}

function build() {
  docker build \
    -t "${img_name}" \
    .
}

function stop_container() {
  # Check if container is running
  if [ "$(docker ps -q -f name=^/${cnt_name}$)" ]; then
    echo "Container '$cnt_name' is running. Stopping it..."
    docker stop "$cnt_name"
  fi
}

function remove_container() {
  docker rm "$cnt_name"
}

function restart_container() {
  # Check if container is running
  if [ "$(docker ps -q -f name=^/${cnt_name}$)" ]; then
    stop_container
    docker start "$cnt_name"
  fi

  # Run container
  echo "Run container (create container+start) '$cnt_name'..."
  docker run \
    -d \
    -v dbt-profile:/root/.dbt/ \
    --env-file .env \
    --network dbt-net \
    --rm \
    --name "${cnt_name}" \
    "${img_name}" \
    tail -f /dev/null
}

if [[ "$1" == "--clean" ]] then;
  build_clean --clean
  exit 0
else


# Check if image exists locally
if docker image inspect "${img_name}" > /dev/null 2>&1; then
  echo "Image ${img_name} already exists. Running container..."
  build_with_clean
  run_container

else
  echo "Image ${img_name} not found. Building image then running the container."
  # Build image
  build_image

  echo "Running the container..."
  # Run container
  run_container
fi



