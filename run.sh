#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

DOCKER_IMAGE_NAME=android-studio
DOCKER_HOSTNAME=android-studio

docker build -t "${DOCKER_IMAGE_NAME}" .

xhost "+local:${DOCKER_HOSTNAME}"
trap 'xhost "-local:${DOCKER_HOSTNAME}"' EXIT

docker run \
    --privileged \
    -it \
    -h "${DOCKER_HOSTNAME}" \
    -e DISPLAY="${DISPLAY}" \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /dev/kvm:/dev/kvm \
    -v "${PROJECT_PATH}:/$(basename ${PROJECT_PATH}):rw" \
    "${DOCKER_IMAGE_NAME}"
