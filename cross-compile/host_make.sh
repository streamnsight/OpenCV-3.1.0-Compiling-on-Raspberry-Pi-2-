#!/usr/bin/env bash
rm -rf build
mkdir build
pushd build

cmake -D CMAKE_TOOLCHAIN_FILE=../opencv-3.1.0/platforms/linux/arm-gnueabi.toolchain.cmake \
-D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_CXX_COMPILER=/usr/bin/arm-linux-gnueabihf-g++ \
-D CMAKE_C_COMPILER=/usr/bin/arm-linux-gnueabihf-gcc \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D INSTALL_C_EXAMPLES=OFF \
-D INSTALL_PYTHON_EXAMPLES=ON \
-D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib-3.1.0/modules/ \
-D BUILD_EXAMPLES=ON \
-D ENABLE_VFPV3=ON \
-D WITH_V4L=ON \
-D ENABLE_NEON=ON \
-D WITH_NEON=ON \
-D WITH_TBB=ON \
-D BUILD_TBB=ON \
-D CMAKE_C_FLAGS="-O3 -mfpu=neon -mfloat-abi=hard" \
-D BUILD_JPEG=OFF \
-D JPEG_INCLUDE_DIR=/mnt/chipfs/opt/libjpeg-turbo/include/ \
-D JPEG_LIBRARY=/mnt/chipfs/opt/libjpeg-turbo/lib/libjpeg.a \
-D FFMPEG_INCLUDE_DIR=/mnt/chipfs/usr/lib \
-D INCLUDE_DIRECTORIES=/mnt/chipfs/usr/lib \
-D INCLUDE_DIRECTORIES=/mnt/chipfs/usr/bin \
-D INCLUDE_DIRECTORIES=/mnt/chipfs/opt/lib \
-D INCLUDE_DIRECTORIES=/mnt/chipfs/lib \
-D PYTHON2_INCLUDE_PATH=/mnt/chipfs/usr/include/python2.7 \
-D PYTHON2_LIBRARIES=/mnt/chipfs/usr/lib/python2.7 \
-D PYTHON2_NUMPY_INCLUDE_DIRS=/mnt/chipfs/usr/lib/python2.7/dist-packages \
-D PYTHON3_INCLUDE_PATH=/mnt/chipfs/usr/include/python3.4 \
-D PYTHON3_LIBRARIES=/mnt/chipfs/usr/lib/python3.4 \
-D PYTHON3_NUMPY_INCLUDE_DIRS=/mnt/chipfs//usr/lib/python3.4/dist-packages \
../opencv-3.1.0/

popd
