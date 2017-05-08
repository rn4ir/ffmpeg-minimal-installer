#!/bin/bash

#################################################
#                                               #
#     A shell script to install FFMPEG on a     #
#     CentOS server                             #
#						#
#################################################

# check if the current user is root
if [[ $(/usr/bin/id -u) != "0" ]]; then
    echo -e "This looks like a 'non-root' user.\nPlease switch to 'root' and run the script again."
    exit
fi

yum groupinstall "Development Tools" -y
yum install autoconf automake bzip2 cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel -y

mkdir -p /opt/ffmpeg-sources


cd /opt/ffmpeg-sources
git clone --depth 1 git://github.com/yasm/yasm.git
cd yasm/
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make
make install

cd /opt/ffmpeg-sources/
git clone --depth 1 git://git.videolan.org/x264
cd x264/
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
make
make install

cd /opt/ffmpeg-sources/
hg clone https://bitbucket.org/multicoreware/x265
cd x265/
cd build/linux/
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source/
make 
make install


