# Cross-compile OpenCV 3.1 for ARM on Ubuntu 16.04

These are my notes for cross-compiling OpenCV 3.1 on a Ubuntu 16.04 server

definitions:
- target: the ARM based system to install OpenCV on
- host: the Ubuntu server used to cross-compile

## Process

The steps are as follow:

- prepare target with all needed dependencies
- copy needed dependencies files from target to the host which will need the dependent libraries and headers
- configure build with cmake, using the cross-compile toolchain
- build the project
- package the project
- copy package to target
- install package on target

## Preparing the target

All the dependencies needed to compile on the target itself are needed by the host.
I haven't found an efficient (easy) way to install the dependencies for ARM on the 
Ubuntu host directly, so the strategy is to install the libraries on the target, and 
copy them over to the host

The process is the same as for installing on the target covered in the main readme.md 
except there is no need to install the OpenCV and contrib source or compile it; 
this will be done on the host.

the script `target_opencv3.1.sh` covers the libraries and dependencies I use; 
some are optional, and some are already commented out.

## Preparing the host

On the host, we will need a cross-compiling toolchain.
Many tutorials explain how to build a toolchain with crosstool-ng, but I just used the 
Ubuntu package

	$ sudo apt-get install gcc-arm-linux-gnueabihf binutils-arm-linux-gnueabihf
	
You might need other tools for building:
	
	$ sudo apt-get install git build-essential zlib1g-dev libncurses5-dev lzop unzip
	
	
## Copy dependencies from target over to the host

You will need the files under 

- `/usr`
- `/lib`
- `/opt` (if you built the `libjpeg-turbo` library)

That's a lot of files. On my board it was about 350MB.

I used tar to compress the folders and copy them over one at a time with

	tar -cvzf <folder-name>.tar.gz <folder-name>

and `scp` to copy them over to the host. (you can also use `rsync`)

I copied the dependencies in a folder at `~/sysroot-chip/`

Uncompress the folders in `~/sysroot-chip`

## Get the OpenCV source

Just like when compiling on the target directly, you need the openCV source and contrib

	cd ~/
	wget -O opencv.zip https://github.com/opencv/opencv/archive/3.1.0.zip
	unzip opencv.zip
	rm opencv.zip
	
	wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/3.1.0.zip
	unzip opencv_contrib.zip
	rm opencv_contrib.zip

## Configure build

	mkdir ~/build
	cd build

Then I used 

	ccmake .
	
To get into the `cmake` config menu and select the options I want / don't want
I typically don't use Java bindings, but need Python, and wanted NEON and TBB acceleration
So I selected those.
I also, select FFMPEG and other codecs I may need.

Hit `c` to configure

Then I used the script attached to configure the extra params (the libjpeg-turbo addon, NEON fpu support etc...)

## Build

	# I have 32 cores so I use -j33, typically j+1 for max speed
	make -j33 
	
## Build package

	make package
	
Now you end up with a `OpenCV-unknown-arm-linux.tar.gz` file that contains all you need to install on target

## Copy package to target

	scp OpenCV-unknown-arm-linux.tar.gz <user>@<target>:~/
	
## Install on target
	
	# untar in the /usr/local/ folder (stripping 1st level directory)
	tar -xvzf OpenCV-unknown-arm-linux.tar.gz -C /usr/local/ --strip 1
	
	# edit opencv.pc to reflect the install path
	# 
	nano $(find / -type f -iname opencv.pc)
	# replace the prefix that points to the original build dir, with the /usr/local dir
	