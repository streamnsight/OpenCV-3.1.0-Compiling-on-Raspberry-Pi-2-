
 export CCPREFIX=/usr/bin/arm-linux-gnueabihf-
 
./configure --enable-cross-compile --cross-prefix=${CCPREFIX} --arch=armhf --target-os=linux \
--prefix=/mnt/chipfs --sysroot=/mnt/chipfs \
--enable-gpl \
--enable-postproc \
--enable-swscale \
--enable-avfilter \
--enable-libmp3lame \
--enable-libx264 \
--enable-pthreads \
--enable-libopenjpeg \
--enable-libfaac \
--enable-nonfree \
--enable-shared \
--enable-pic \
--enable-x11grab

sudo make C_FLAGS="-fPIC" -j33
