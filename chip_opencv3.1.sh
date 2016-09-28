#!/usr/bin/env bash
# Compile OpenCV 3.1.0 + OpenCV Contrib for Python on Raspberry Pi 2 Model B

# Update sources and firmware:

#sudo apt-get update
#sudo apt-get upgrade
#sudo rpi-update # (can be skipped, but recommended) (don't do it if you will use the RPI cam as recommended by official RPI Website)
#sudo reboot now

# Build tools:

# build tools
sudo apt-get install -y build-essential cmake pkg-config

# ccmake curses (make our life easier to select options for CMAKE)
sudo apt-get install -y cmake-curses-gui

# Build libjpeg-turbo
wget http://sourceforge.net/projects/libjpeg-turbo/files/1.3.0/libjpeg-turbo-1.3.0.tar.gz
tar xzvf libjpeg-turbo-1.3.0.tar.gz
pushd libjpeg-turbo-1.3.0
mkdir build
pushd build

#By default libjpeg-turbo will install into /opt/libjpeg-turbo. You may install to a different directory by
# passing the --prefix option to the configure script.
# However, the remainder of these instructions will assume that libjpeg-turbo was installed in its default location.
../configure CPPFLAGS="-O3 -pipe -fPIC -mfpu=neon -mfloat-abi=hard"
make
sudo make install
popd
popd

# Image format support:

# JPEG, TIFF, JPEG2000, PNG
sudo apt-get install -y libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev

# GUI Framework:

# gtk GUI framework
sudo apt-get install -y libgtk2.0-dev 

# OpenGL extension to GTK (optional)
sudo apt-get install -y libgtkglext1-dev

# Video Driver

# video4linux device driver for video capture
sudo apt-get install -y libv4l-dev 

# other optional v4l stuff
sudo apt-get install -y libv4l-0 v4l-utils

# AUDIO / VIDEO CODECS:
# ffmpeg libraries (optional but recommended)
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev

# xvid and x264 codecs (optional)
sudo apt-get install -y libxvidcore-dev libx264-dev

# Audio MP3, AAC encoding codecs (optional)
#sudo apt-get install -y libmp3lame-dev libfaac-dev

# gstreamer (optional) multimedia framework
sudo apt-get install -y libgstreamer0.10-0-dbg libgstreamer0.10-0 libgstreamer0.10-dev 

# Theora video compression codec (optional, not recommended)
#sudo apt-get install -y libtheora-dev

# Vorbis General Audio Compression Codec (optional, not recommended)
#sudo apt-get install -y libvorbis-dev

# Speech CODECS	:
# Speech CODECs

# Adaptive Multi Rate codec (Wide band and Narrow band) (optional)
#sudo apt-get install -y libopencore-amrnb-dev libopencore-amrwb-dev

# 1394 FireWire / iLink support:
# FireWire support (optional)
sudo apt-get install -y libdc1394-22 libdc1394-22-dev

# Optimizations:

# TBB Multi-core / multi-processor framework (optional but recommended)
sudo apt-get install -y libtbb-dev

# ATLAS Automatically Tuned Linear Algebra Software; optimized version of BLAS and LAPACK
sudo apt-get install -y libatlas-base-dev 

# Python bindings

# python dev library
sudo apt-get install -y python2.7-dev

# install -y PIP
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py

# GNU Fortran compiler, used to optimize SciPy code
sudo apt-get install -y gfortran

# Python bindings dependencies
sudo apt-get install -y python-numpy python-scipy python-matplotlib

# python numpy already installed above ?!?
sudo pip install numpy

# JAVA bindings
# jdk, ant for java support (optional)
#sudo apt-get install -y default-jdk ant

# Get OpenCV source and contrib:
# Download OpenCV 3.1.0 and unpack it

#cd ~
wget -O opencv.zip https://github.com/opencv/opencv/archive/3.1.0.zip
unzip opencv.zip
rm -rf opencv.zip

# Contrib Libraries (Non-free Modules)

wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/3.1.0.zip
unzip opencv_contrib.zip
rm -rf opencv_contrib.zip

# Create MAKEFILE:
# preparing the build

#cd ~/opencv-3.1.0/
mkdir build

pushd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D INSTALL_C_EXAMPLES=OFF \
	-D INSTALL_PYTHON_EXAMPLES=ON \
	-D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib-3.1.0/modules \
	-D BUILD_EXAMPLES=ON ../opencv-3.1.0

# Build:
# takes about 3.5 to 4 hours

#sudo make -j3

# If any errors occurs and the process fails to continue, execute

sudo make 
# (without the -jN), keep in mind that without multi-processor, it will take much longer (i.e. ~7-8h)

# Install:
#installing the build

# install
sudo make install
popd

# configure linker 

# define the opencv config for ldconfig
echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf
# configure dynamic linker run time bindings
sudo ldconfig

# configure pkg-config

#add the following lines at the bottom of bash.bashrc
echo "PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig" >> /etc/bash.bashrc
echo "export PKG_CONFIG_PATH" >> /etc/bash.bashrc
