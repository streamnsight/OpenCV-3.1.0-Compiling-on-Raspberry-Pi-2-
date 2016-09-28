# Compile OpenCV 3.1.0 + OpenCV Contrib for Python on Raspberry Pi 2 Model B

# Update sources and firmware:

	$ sudo apt-get update
	$ sudo apt-get upgrade
	$ sudo rpi-update (can be skipped, but recommended) (don't do it if you will use the RPI cam as recommended by official RPI Website)
	$ sudo reboot now

# Build tools:

	# build tools
	$ sudo apt-get install build-essential cmake pkg-config
	
	# ccmake curses (make our life easier to select options for CMAKE)
	$ sudo apt-get install cmake-curses-gui

# Image format support:

	# JPEG, TIFF, JPEG2000, PNG
	$ sudo apt-get install libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev
	
	# OpenEXR is a high dynamic-range (HDR) image file format
	# without this there seem to be an error loading cv2 in python
	$ sudo apt-get install openexr

# GUI Framework:

	# gtk GUI framework
	$ sudo apt-get install libgtk2.0-dev 
	
	# OpenGL extension to GTK (optional)
	$ sudo apt-get install libgtkglext1-dev

# Video Driver

	# video4linux device driver for video capture
	$ sudo apt-get install libv4l-dev 

	# other optional v4l stuff
	$ sudo apt-get install libv4l-0 v4l-utils

# AUDIO / VIDEO CODECS:
	# ffmpeg libraries (optional but recommended)
	$ sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev
	
	# xvid and x264 codecs (optional)
	$ sudo apt-get install libxvidcore-dev libx264-dev
	
	# Audio MP3, AAC encoding codecs (optional)
	$ sudo apt-get install libmp3lame-dev libfaac-dev

	# gstreamer (optional) multimedia framework
	$ sudo apt-get install libgstreamer0.10-0-dbg libgstreamer0.10-0 libgstreamer0.10-dev 
	
	# Theora video compression codec (optional, not recommended)
	$ sudo apt-get install libtheora-dev

	# Vorbis General Audio Compression Codec (optional, not recommended)
	$ sudo apt-get install libvorbis-dev
	
# Speech CODECS	:
	# Speech CODECs
	
	# Adaptive Multi Rate codec (Wide band and Narrow band) (optional)
	$ sudo apt-get install libopencore-amrnb-dev libopencore-amrwb-dev

# 1394 FireWire / iLink support:
	# FireWire support (optional)
	$suso apt-get install libdc1394-22 libdc1394-22-dev
	
# Optimizations:

	# TBB Multi-core / multi-processor framework (optional but recommended)
	$ sudo apt-get install libtbb-dev

	# ATLAS Automatically Tuned Linear Algebra Software; optimized version of BLAS and LAPACK
	$ sudo apt-get install libatlas-base-dev 

# Python bindings

	# python dev library
	$ sudo apt-get install python2.7-dev

	# install PIP
	$ wget https://bootstrap.pypa.io/get-pip.py
	$ sudo python get-pip.py

	# GNU Fortran compiler, used to optimize SciPy code
	$ sudo apt-get install gfortran

	# Python bindings dependencies
	$ sudo apt-get install python-numpy python-scipy python-matplotlib

	# python numpy already installed above ?!?
	$ sudo pip install numpy

# JAVA bindings
	# jdk, ant for java support (optional)
	$ sudo apt-get install default-jdk ant

# Get OpenCV source and contrib:
Download OpenCV 3.1.0 and unpack it

	$ cd ~
	$ wget -O opencv.zip https://github.com/opencv/opencv/archive/3.1.0.zip
	$ unzip opencv.zip

Contrib Libraries (Non-free Modules)

	$ wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/3.1.0.zip
	$ unzip opencv_contrib.zip

# Create MAKEFILE:
preparing the build

	$ cd ~/opencv-3.1.0/
	$ mkdir build
	$ cd build
	$ cmake -D CMAKE_BUILD_TYPE=RELEASE \
		-D CMAKE_INSTALL_PREFIX=/usr/local \
		-D INSTALL_C_EXAMPLES=OFF \
		-D INSTALL_PYTHON_EXAMPLES=ON \
		-D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-3.1.0/modules \
		-D BUILD_EXAMPLES=ON ..

# Build:
takes about 3.5 to 4 hours

	$ sudo make -j3 (I prefer -j3, because it doesn't use all the cores so it keeps the RasPi cool enough)
	
If any errors occurs and the process fails to continue, execute
	
	$ sudo make clean
	
Sometimes using multicores can cause problems, so if you face any problems just execute 
	
	$ sudo make 
(without the -jN), keep in mind that without multi-processor, it will take much longer (i.e. ~7-8h) 

# Install:
installing the build

	# install
	$ sudo make install
	
# configure linker 
	
	# define the opencv config for ldconfig
	$ sudo nano /etc/ld.so.conf.d/opencv.conf

opencv.conf will be blank, add the following line, then save and exit nano:

	/usr/local/lib          # enter this in opencv.conf, NOT at the command line
				(leave a blank line at the end of opencv.conf)

save opencv.conf by pressing ctrl+o
get back again to the command line by pressing ctrl+x

	# configure dynamic linker run time bindings 
	$ sudo ldconfig

# configure pkg-config

	$ sudo nano /etc/bash.bashrc

add the following lines at the bottom of bash.bashrc

	PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig       
	export PKG_CONFIG_PATH

(leave a blank line at the end of bash.bashrc)
save bash.bashrc changes (ctrl+o), then back at the command line (ctrl+x), 

# Reboot:
Reboot

	$ sudo shutdown -r now

# Verifying installation:

Open Python 2 IDLE on RasPi
Type the following lines in the python shell:

	>>> import cv2
	>>> print cv2.__version__

the following line should appear then:

	'3.1.0'
#Done

# Watch and Fork this repo to get updates. I will be posting how to connect Raspberry Pi to PC with ETHERNET CABLE (no internet needed)
