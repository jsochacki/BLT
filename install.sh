#!/bin/bash

## Generic Path Setup
#Prevents errors due to sudo run setting USER as root
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd
CURHOMEDIR=$(pwd)
cd $CURDIR

INSTALLDIR=/usr/local/opencv
mkdir -p $INSTALLDIR

## Install generic/necessary package manager based packages
# Need git to pull this repo
sudo apt-get install -y git
#TODO under investigation, dont think i need this, recommend deleting
## Need to make documentation
#sudo apt-get install -y doxygen

## Install Open CV
# Compiler Package
sudo apt-get install -y build-essential
# Required Build Packages
sudo apt-get install -y cmake libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
# Optional Packages for Additional Features
sudo apt-get install -y python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev

# Get OpenCV
mkdir $INSTALLDIR/opencv_build && cd $INSTALLDIR/opencv_build
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git
git clone https://github.com/opencv/opencv_extra.git

# Make (see addition cmake options here https://docs.opencv.org/master/d7/d9f/tutorial_linux_install.html)
cd opencv
mkdir build && cd build
# Remove -D OPENCV_EXTRA_MODULES_PATH=$INSTALLDIR/opencv_build/opencv_contrib/modules \
# To get rid of unstable items
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_EXTRA_MODULES_PATH=$INSTALLDIR/opencv_build/opencv_contrib/modules \
    -D OPENCV_TEST_DATA_PATH=$INSTALLDIR/opencv_build/opencv_extra/testdata \
    -D BUILD_EXAMPLES=ON ..

# Build
make -j$(nproc)

# Install
sudo make install

# Make the docs
cd doc/
#TODO target of doxygen fails
make -j$(nproc)

# Verify
pkg-config --modversion opencv4

# Test
$INSTALLDIR/opencv_build/opencv/build/bin/opencv_test_core
