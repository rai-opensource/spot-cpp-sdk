#!/usr/bin/env bash
set -euo pipefail

UBUNTU_VERSION="22.04"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --ubuntu)
      UBUNTU_VERSION="$2"
      shift 2
      ;;
    *)
      echo "Usage: $0 [--ubuntu 22.04|24.04]" >&2
      exit 1
      ;;
  esac
done

ARCH=$(dpkg --print-architecture)
echo "Building Docker image for architecture: $ARCH with Ubuntu: $UBUNTU_VERSION"

if [ "$ARCH" == "amd64" ]; then
  docker build --build-arg UBUNTU_VERSION="$UBUNTU_VERSION" -t spot_builder -f Dockerfile.amd64 .
elif [ "$ARCH" == "arm64" ]; then
  docker build --build-arg UBUNTU_VERSION="$UBUNTU_VERSION" -t spot_builder -f Dockerfile.arm64 .
else
  echo "Unknown architecture: $ARCH" > /dev/stderr
  exit 1
fi

docker run -v ~/spot-cpp-sdk:/spot-cpp-sdk spot_builder /entrypoint.sh
