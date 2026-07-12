#!/usr/bin/env bash
UBUNTU_VERSION=$(cat /etc/os-release | grep VERSION_ID | cut -d'"' -f2)

cd /spot-cpp-sdk/cpp
if [ -d build ]; then
  rm -r build
fi
mkdir build
cd build
cmake .. -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=TRUE -DBUILD_CHOREOGRAPHY_LIBS=ON -DBUILD_SHARED_LIBS=ON -DDEB_NAME_SUFFIX="_ubuntu_$UBUNTU_VERSION"
make -j8 install package
