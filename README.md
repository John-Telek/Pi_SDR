# Pi_SDR
DIY SDR for the Raspberry Pi 3b and 4b

I wanted a dedicated, portable SDR package that was physicaly small in size for field work.
There are several Amature Radio linux distros available for PC's and the Pi with SDR but I wanted to
start from scratch and slowly make something that everyone wants and likes for the Pi by
giving you a say in it. As not all apps are available in the software repository I thought
that I could detail the buid instructions on this site so everyone else can do it. Get everyone
not just those who can.

So I am doing 3 things.

1) Provide a plug and run iso that can be put onto a Micro SD card.
2) Provide step buy step instructions to do it yourself from scratch.
3) Provide precompiled binaries for those who just want to play.

Re the ISO.
At the moment I have one 32G SD card to use and need to get a smaller one that cam be compressed into
a smaller size for distribution when I'm able. It will have the following.

(1) SDRAnglel

(2) SigDigger

(3) SDRplusplus

(4) Cubic SDR

(5) GQRX

RELEASE: 1.0

Once you download the file you can uncompress it with.

$ tar -xfz Pi_SDR-1.0.tgz

Have a look at your disk utils as they might able to burn the image to SD or
search your software repositories for suitable tools.

This is a direct copy of my own system for the Pi 4b.

Gqrx and CubicSDR and SigDigger (Latest main release) can be launched from the desktop.

Gqrx and CubicSDR are the latest Raspian packages. (Add/Remove Software)

SigDigger (Desktop) is the latest main release from github. 

SDRPlusPlus is the latest daily build release.

To run SigDigger (latest development release) execute the following scripts in the user home directory.
1) $ ./SigDigger.sh

To run sdrangel (latest main release) execute the following scripts in the user home directory.
1) $ sdrpp

To start from scratch simply install Raspian onto your Pi and update its software. Once done you can start building.

***** IF YOU WANT TO PLAY *****

Sdrangel latest main release.

This is made in /opt/build and the instructions to build it are at https://github.com/f4exb/sdrangel/wiki/Compile-from-source-in-Linux

It installs in /usr/local/bin

SigDigger latest main release.

(1) Dependencies. Not listed on github SigDigger page but courtesy of f4exb of sdrangel fame. Thanks mate. :)

$ sudo apt-get update && sudo apt-get -y install \
git cmake g++ pkg-config autoconf automake libtool libfftw3-dev libusb-1.0-0-dev libusb-dev libhidapi-dev libopengl-dev \
qtbase5-dev qtchooser libqt5multimedia5-plugins qtmultimedia5-dev libqt5websockets5-dev \
qttools5-dev qttools5-dev-tools libqt5opengl5-dev libqt5quick5 libqt5charts5-dev \
qml-module-qtlocation  qml-module-qtpositioning qml-module-qtquick-window2 \
qml-module-qtquick-dialogs qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qtquick-layouts \
libqt5serialport5-dev qtdeclarative5-dev qtpositioning5-dev qtlocation5-dev libqt5texttospeech5-dev \
qtwebengine5-dev qtbase5-private-dev \
libfaad-dev zlib1g-dev libboost-all-dev libasound2-dev pulseaudio libopencv-dev libxml2-dev bison flex \
ffmpeg libavcodec-dev libavformat-dev libopus-dev doxygen graphviz libsndfile1 libsndfile1-dev

(2) Then follow the build instructions at https://github.com/BatchDrake/SigDigger

SigDigger latest development release.

By executing the following, you will download and compile the latest dev release.
This release fixed the issue of the DC spike you see in the middle of the spectrum display.
And if you like, you can keep up with the latest.

1) cd ./tmp;SD.sh
2) cd blsd-dir/SigDigger
3) ./Sigdigger

SDRPlusPlus
#######################################################################################
1) First update you pi

$ sudo apt update; sudo apt upgrade

***** If you dont have the C compiler installed execute the following. *****

$ sudo apt-get update && sudo apt-get -y install git cmake g++ pkg-config autoconf automake libtool libfftw3-dev libusb-1.0-0-dev libusb-dev libhidapi-dev libopengl-dev qtbase5-dev qtchooser libqt5multimedia5-plugins qtmultimedia5-dev libqt5websockets5-dev qttools5-dev qttools5-dev-tools libqt5opengl5-dev libqt5quick5 libqt5charts5-dev qml-module-qtlocation  qml-module-qtpositioning qml-module-qtquick-window2 qml-module-qtquick-dialogs qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qtquick-layouts libqt5serialport5-dev qtdeclarative5-dev qtpositioning5-dev qtlocation5-dev libqt5texttospeech5-dev qtwebengine5-dev qtbase5-private-dev libfaad-dev zlib1g-dev libboost-all-dev libasound2-dev pulseaudio libopencv-dev libxml2-dev bison flex ffmpeg libavcodec-dev libavformat-dev libopus-dev doxygen graphviz libsndfile1 libsndfile1-dev

Then come the dependancies.

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


If there is something else that you want made available, please feel free to contact me.
Feel free to report any issues or if you'd like to see something else added.
In the releases section you'll find a little video demo and Ver 1.0 of Pi_SDR.

And most importantly I'd like to thank the authors and open source community for allowing
us amatuers to partake in this ever expanding technology.

Regards,
    John Telek.
