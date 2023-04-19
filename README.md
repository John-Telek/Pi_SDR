# Pi_SDR
DIY SDR for the Raspberry Pi 3b and 4b

I wanted a dedicated, portable SDR package that was physicaly small in size for field work.
There are several Amature Radio linux distros available for PC's and the Pi with SDR but I wanted to
start from scratch and slowly make something that everyone wants and likes for the Pi by
giving you a say in it. As not all apps are available in the software repository I thought
that I could detail the buid instructions on this site so everyone else can do it. Get everyone
not just those who can.

(1) Development environment and dependencies courtesy of f4exb of sdrangel fame. Thanks mate. :)

$ sudo apt-get update && sudo apt-get -y install build-essential \
git cmake g++ pkg-config autoconf automake libtool libfftw3-dev libusb-1.0-0-dev libusb-dev libhidapi-dev libopengl-dev \
qtbase5-dev qtchooser libqt5multimedia5-plugins qtmultimedia5-dev libqt5websockets5-dev qt5-qmake qt5-qmake-bin \
qttools5-dev qttools5-dev-tools libqt5opengl5-dev libqt5quick5 libqt5charts5-dev \
qml-module-qtlocation  qml-module-qtpositioning qml-module-qtquick-window2 \
qml-module-qtquick-dialogs qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qtquick-layouts \
libqt5serialport5-dev qtdeclarative5-dev qtpositioning5-dev qtlocation5-dev libqt5texttospeech5-dev \
qtwebengine5-dev qtbase5-private-dev \
libfaad-dev zlib1g-dev libboost-all-dev libasound2-dev pulseaudio libopencv-dev libxml2-dev bison flex \
ffmpeg libavcodec-dev libavformat-dev libopus-dev doxygen graphviz libsndfile1 libsndfile1-dev

** The following installs the SoapySDR libs.
$ sudo apt install libsoapysdr-dev libsoapysdr0.7 soapysdr-module-all



SigDigger latest main release.

(2) Now we download and build sigutils, suscan, SuWidgets and SigDigger.
Make a temporary directory to download and build the code.

** We will get everything in one hit.
$ cd ~
$ mkdir tmp;cd tmp
$ git clone https://github.com/BatchDrake/sigutils
$ git clone https://github.com/BatchDrake/suscan
$ git clone https://github.com/BatchDrake/SuWidgets
$ git clone https://github.com/BatchDrake/SigDigger

(3) Building and installing sigutils
First, you must create a build directory and configure it with:
$ cd ~/tmp/sigutils
$ mkdir build
$ cd build
$ cmake ..

(4) If the previous commands were successful, you can start the build by typing:
$ make

(5) And proceed to install the library in your system by running as root:
$ sudo make install
$ sudo ldconfig

(6) Building and installing suscan.
$ cd ~/tmp/suscan
$ mkdir build
$ cd build
$ cmake ..
$ make

(7) If all is well.
$ sudo make install
$ sudo ldconfig

(8) You can verify your installation by running:
$ suscan.status

(9) Building and installing SuWidgets.
$ cd ~/tmp/SuWudgets
$ qmake SuWidgetsLib.pro
$ make
$ sudo make install

(10) Building and installing SigDigger.
$ cd ~/tmp/SigDigger
$ qmake SigDigger.pro
$ make -j5
$ sudo make install

(11) To run.
$ ./SigDigger

#######################################################################################################################

By executing the following, you will download and compile the latest dev release.
This release fixed the issue of the DC spike you see in the middle of the spectrum display.
And if you like, you can keep up with the latest. Create as file called SD.sh in dir ~/tmp
and paste the following code into it, make it executable and run.

############### BEGINNING of FILE #####################################################################################
#!/usr/bin/env bash
#
#  blsd: Build Latest SigDigger, easily
#
#  Copyright (C) 2021 Gonzalo JosÃ© Carracedo Carballal
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Lesser General Public License as
#  published by the Free Software Foundation, either version 3 of the
#  License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public
#  License along with this program.  If not, see
#  <http://www.gnu.org/licenses/>
#
#

DISTROOT="$PWD"
BLSDROOT="$DISTROOT/blsd-dir"

function try()
{
    echo -en "[  ....  ] $1 "
    shift
    
    STDOUT="$DISTROOT/$1-$$-stdout.log"
    STDERR="$DISTROOT/$1-$$-stderr.log"
    "$@" > "$STDOUT" 2> "$STDERR"
    
    if [ $? != 0 ]; then
	echo -e "\r[ \033[1;31mFAILED\033[0m ]"
	echo
	echo "Standard output and error were saved respectively in:"
	echo " - $STDOUT"
	echo " - $STDERR"
	echo
	echo "Fix errors and try again"
	echo
	exit 1
    fi

    echo -e "\r[   \033[1;32mOK\033[0m   ]"
    rm "$STDOUT"
    rm "$STDERR"
}

function locate_curl()
{
    if which curl; then
	export HAVE_CURL=1
	export CURL_PATH=`which curl`
	return 0
    fi

    exit 1
}

function locate_wget()
{
    if which wget; then
	export HAVE_WGET=1
	export WGET_PATH=`which wget`
	return 0
    fi

    return 1
}

function locate_downloader()
{
    if locate_wget; then
	return 0
    fi

    if locate_curl; then
	return 0
    fi

    echo >&2 'Cannot locate neither wget nor curl. Cannot download files.'

    return 0
}

function download_script()
{
    scrname=`basename "$1"`
    if [[ "x$scrname" == "x" ]]; then
	scrname="discard"
    fi
    
    DEST="$BLSDROOT/$scrname"
    if [[ "x$HAVE_WGET" != "x" ]]; then
	"$WGET_PATH" "$1" -O "$DEST"
    elif [[ "x$HAVE_CURL" != "x" ]]; then
	"$CURL_PATH" "$1" > "$DEST"
    else
	echo >&2 'No download script found.' 
    fi
    
    return $?
}

echo -e 'Welcome to \033[1;32mBLSD\033[0m, a script to \033[1;32mb\033[0muild the \033[1;32ml\033[0matest \033[1;32mS\033[0mig\033[1;32mD\033[0migger directly from \033[1mdevelop\033[0m.'
echo
echo -e '\033[1mPlease note:\033[0m You are about to build SigDigger directly from the development'
echo    'branch. This means lots of new untested and half-implemented features whose stability'
echo -n 'cannot be assured. Are you sure you want to proceed? [Y/n] '

read REPLY
echo

if [[ $REPLY =~ ^[nN]$ ]]; then
    echo 'Cancelled.'
    exit 0
fi

try 'Detecting downloader tool' locate_downloader
try 'Cleaning previous builds (if any)' rm -Rfv "$BLSDROOT"
try "Creating download dir ($BLSDROOT)" mkdir -p "$BLSDROOT"
try 'Testing Internet connection' download_script 'http://example.com'
try 'Downloading dist-common.sh (develop)' download_script 'https://raw.githubusercontent.com/BatchDrake/SigDigger/develop/Scripts/dist-common.sh'
try 'Downloading build.sh (develop)' download_script 'https://raw.githubusercontent.com/BatchDrake/SigDigger/develop/Scripts/build.sh'
try 'Setting permissions' chmod a+x "$BLSDROOT"/*.sh

echo
echo ' * * * All scripts downloaded, starting build! * * *'
echo 
cd "$BLSDROOT"
if ./build.sh "$@"; then
    echo ' * * * Build successful! * * *'
    echo
    
    try 'Moving deploy directory to its final location' mv deploy-root "SigDigger"
    try 'Cleaning up download directory' rm -Rfv *.com build.sh dist-common.sh build-root
    echo
    echo 'SigDigger (along with all its dependencies) has been built to:'
    echo
    echo -e "  \033[1m$BLSDROOT/SigDigger/\033[0m"
    echo 
    echo -e 'Just place this directory to wherever you want, cd to it and run ./\033[1;32mSigDigger\033[0m'
fi

############## END of FILE ###############################################################################################

Now
1) cd ~/tmp; vi SD.sh
chmod +x SD.sh
2) cd blsd-dir/SigDigger
3) ./Sigdigger


#############
SDRPlusPlus #
#############
Source code for the latest nightly build.
https://github.com/AlexandreRouma/SDRPlusPlus/archive/refs/heads/master.zip

Source and binaries for stable releases
https://github.com/AlexandreRouma/SDRPlusPlus/releases

Source and binaries for nightly release.
https://github.com/AlexandreRouma/SDRPlusPlus/releases/tag/nightly

###########################################################################
In this example we will build the latest nightly release.

1) First update you pi
$ sudo apt update; sudo apt upgrade

***** If you dont have the C compiler installed execute the following. *****

$ sudo apt update && sudo apt -y install git cmake g++ pkg-config autoconf automake libtool libfftw3-dev libusb-1.0-0-dev libusb-dev libhidapi-dev libopengl-dev qtbase5-dev qtchooser libqt5multimedia5-plugins qtmultimedia5-dev libqt5websockets5-dev qttools5-dev qttools5-dev-tools libqt5opengl5-dev libqt5quick5 libqt5charts5-dev qml-module-qtlocation  qml-module-qtpositioning qml-module-qtquick-window2 qml-module-qtquick-dialogs qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qtquick-layouts libqt5serialport5-dev qtdeclarative5-dev qtpositioning5-dev qtlocation5-dev libqt5texttospeech5-dev qtwebengine5-dev qtbase5-private-dev libfaad-dev zlib1g-dev libboost-all-dev libasound2-dev pulseaudio libopencv-dev libxml2-dev bison flex ffmpeg libavcodec-dev libavformat-dev libopus-dev doxygen graphviz libsndfile1 libsndfile1-dev
$ sudo apt install libfftw3-dev libglfw3-dev libvolk2-dev libsoapysdr-dev libairspyhf-dev libiio-dev libad9361-dev librtaudio-dev libhackrf-dev
$ sudo apt install libzstd1 libzstd-dev libairspy-dev librtlsdr-dev

2) Make a place to build it.

$ mkdir tmp;cd tmp
$ unzip SDRPlusPlus-master.zip
$ cd SDRPlusPlus-master

3) Start building.

$ mkdir build;cd build
$ cmake ..

### NOTE ###############################################################
If you get errors while running cmake it will most likely be a missing library.
For example.

-- Checking for module 'libzstd'
--   No package 'libzstd' found
CMake Error at /usr/share/cmake-3.18/Modules/FindPkgConfig.cmake:545 (message):
  A required package was not found

This comes up because you're missing a required development library. In this case we do this.

$ sudo apt search libzstd
And it will return

Sorting... Done
Full Text Search... Done
golang-github-valyala-gozstd-dev/stable,stable 1.9.0+ds-7 all
  go wrapper for zstd (library)

libarchive-dev/stable 3.4.3-2+deb11u1 arm64
  Multi-format archive and compression library (development files)

libarchive13/stable,now 3.4.3-2+deb11u1 arm64 [installed,automatic]
  Multi-format archive and compression library (shared library)

libzstd-dev/stable,now 1.4.8+dfsg-2.1 arm64 [installed]
  fast lossless compression algorithm -- development files

libzstd1/stable,now 1.4.8+dfsg-2.1 arm64 [installed]
  fast lossless compression algorithm


No as you can see it's installed but if not.

$ sudo apt install libzstd-dev

This will also install libzstd1 if it isnt already and repeate for any others.
########################################################################

Now we compile it.

$ make -j5

And you will see something like this.

user@raspberrypi:~/Code/SDR/SDRPlusPlus-master/build $ make -j6
Scanning dependencies of target correct-reed-solomon
Scanning dependencies of target correct-h
Scanning dependencies of target correct-convolutional
Scanning dependencies of target error_sim_shim
Scanning dependencies of target discord-rpc
Scanning dependencies of target error_sim
[  1%] Building C object core/libcorrect/src/reed-solomon/CMakeFiles/correct-reed-solomon.dir/polynomial.c.o
[  2%] Building C object core/libcorrect/util/CMakeFiles/error_sim_shim.dir/error-sim.c.o
[  3%] Building C object core/libcorrect/util/CMakeFiles/error_sim.dir/error-sim.c.o
[  4%] Building C object core/libcorrect/src/convolutional/CMakeFiles/correct-convolutional.dir/bit.c.o
[  4%] Built target correct-h
[  5%] Building CXX object misc_modules/discord_integration/discord-rpc/src/CMakeFiles/discord-rpc.dir/discord_rpc.cpp.o
[  5%] Building C object core/libcorrect/src/convolutional/CMakeFiles/correct-convolutional.dir/metric.c.o
[  6%] Building C object core/libcorrect/src/convolutional/CMakeFiles/correct-convolutional.dir/history_buffer.c.o
/home/user/Code/SDR/SDRPlusPlus-master/core/libcorrect/src/convolutional/history_buffer.c: In function ‘history_buffer_search’:
/home/user/Code/SDR/SDRPlusPlus-master/core/libcorrect/src/convolutional/history_buffer.c:57:12: warning: ‘bestpath’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   57 |     return bestpath;
      |            ^~~~~~~~
[  6%] Built target error_sim

And at the end.

/home/user/Code/SDR/SDRPlusPlus-master/misc_modules/frequency_manager/src/main.cpp:790:30: warning: ‘std::ostream& nlohmann::operator>>(const nlohmann::basic_json<>&, std::ostream&)’ is deprecated: Since 3.0.0; use operator<<(std::ostream&, const basic_json&) [-Wdeprecated-declarations]
  790 |         exportedBookmarks >> fs;
      |                              ^~
In file included from /home/user/Code/SDR/SDRPlusPlus-master/core/src/module.h:4,
                 from /home/user/Code/SDR/SDRPlusPlus-master/misc_modules/frequency_manager/src/main.cpp:3:
/home/user/Code/SDR/SDRPlusPlus-master/core/src/json.hpp:22968:26: note: declared here
22968 |     friend std::ostream& operator>>(const basic_json& j, std::ostream& o)
      |                          ^~~~~~~~
[ 96%] Linking CXX shared library meteor_demodulator.so
[ 96%] Built target meteor_demodulator
Scanning dependencies of target scanner
[ 96%] Building CXX object misc_modules/scanner/CMakeFiles/scanner.dir/src/main.cpp.o
[ 97%] Linking CXX shared library rigctl_client.so
[ 97%] Built target rigctl_client
Scanning dependencies of target do_always
[ 97%] Built target do_always
[ 97%] Building CXX object decoder_modules/radio/CMakeFiles/radio.dir/src/rds.cpp.o
[ 98%] Linking CXX shared library scanner.so
[ 98%] Built target scanner
[ 98%] Linking CXX shared library rigctl_server.so
[ 98%] Built target rigctl_server
[100%] Linking CXX shared library radio.so
[100%] Built target radio
[100%] Linking CXX shared library frequency_manager.so
[100%] Built target frequency_manager
[100%] Linking CXX shared library recorder.so
[100%] Built target recorder
user@raspberrypi:~/Code/SDR/SDRPlusPlus-master/build $

Now dont worry about warnings. Any errors, cut and paste > google is your friend.

Now to install and run.

$ sudo make install
$ sdrpp

#############################################################################################################
Setting up an rtl_tcp server.
Use ifconfig to get your local IP address.
Default port number is 1234

$ sudo apt install librtlsdr0 librtlsdr-dev rtl-sdr
$ cd ~/tmp
$ rtl_tcp -a xxx.xxx.xxx.xxx 2>&1 >./rtl_tcp.log &
        #####  IP ADDRESS  #####
              
To check if it's running and listening.
user@debian:~/tmp$ sudo netstat -natp | grep LIST
tcp        0      0 192.168.1.102:1234      0.0.0.0:*               LISTEN      31860/rtl_tcp 

Now just setup the IP and PORT number in your SDR app and your ready to go.


If there is something else that you want made available, please feel free to contact me.
Feel free to report any issues or if you'd like to see something else added.
In the releases section you'll find a little video demo and Ver 1.0 of Pi_SDR.

And most importantly I'd like to thank the authors and open source community for allowing
us amatuers to partake in this ever expanding technology.

Regards,
    John Telek.
