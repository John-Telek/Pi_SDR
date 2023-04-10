# Pi_SDR
SDR ISO package for the Raspberry Pi 4b

I wanted a dedicated, portable SDR package that was physically small in size for field work.
There are several Amature Radio linux distros available for PC's with SDR but nothing as complete
for the Pi.

On this site you will find an ISO image thats just plug in and boot. It contains the following.

(1) SDRAnglel

(2) SigDigger

(3) SDRplusplus (Not in initial release)

(4) Cubic SDR

(5) GQRX


Once you have the ISO, just plug it in and boot. Username: user, Password: password

RELEASE: 1.0

This release is HUGE (32G) and I apologise because I hadn't thought about doing this.
I will get an 8G card when I can for the next release.


This is a direct copy of my own system for the Pi 4b.
Gqrx and CubicSDR and SigDigger (Latest main release) can be launched from the desktop.

Gqrx and CubicSDR are the latest Raspian packages. (Add/Remove Software)
SigDigger (Desktop) is the latest main release from github. 

To run SigDigger (latest development release) execute the following scripts in the user home directory.
1) ./SigDigger.sh

To run sdrangel (latest main release) execute the following scripts in the user home directory.
1) ./sdrangel.sh

If you want to play.

Sdrangel latest main release.
This made in /opt/build and the instructions to build it are at https://github.com/f4exb/sdrangel/wiki/Compile-from-source-in-Linux

It installs in /usr/local/bin

SigDigger latest main release.

(1) Dependencies. (Not listed on github)

$ sudo apt-get update && sudo apt-get -y install \
git cmake g++ pkg-config autoconf automake libtool libfftw3-dev libusb-1.0-0-dev libusb-dev libhidapi-dev libopengl-dev \
qtbase5-dev qtchooser libqt5multimedia5-plugins qtmultimedia5-dev libqt5websockets5-dev \
qttools5-dev qttools5-dev-tools libqt5opengl5-dev libqt5quick5 libqt5charts5-dev \
qml-module-qtlocation  qml-module-qtpositioning qml-module-qtquick-window2 \
qml-module-qtquick-dialogs qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qtquick-layouts \
libqt5serialport5-dev qtdeclarative5-dev qtpositioning5-dev qtlocation5-dev libqt5texttospeech5-dev \
qtwebengine5-dev qtbase5-private-dev \
libfaad-dev zlib1g-dev libboost-all-dev libasound2-dev pulseaudio libopencv-dev libxml2-dev bison flex \
ffmpeg libavcodec-dev libavformat-dev libopus-dev doxygen graphviz

$ sudo apt-get -y install libsndfile1 libsndfile1-dev

(2) Then follow the build instructions at https://github.com/BatchDrake/SigDigger

SigDigger latest development release.

By executing the following, you will download and compile the latest dev release.
This release fixed the issue of the DC spike you see in the middle of the spectrum display.
And if you like, you can keep up with the latest.

1) cd ./tmp;SD.sh
2) cd blsd-dir/SigDigger
3) ./Sigdigger

If there is something else that you want in the next release, please feel free to contact me.
Feel free to report any issues or if you'd like to see something else added.
In the releases section you'll find a little video demo and Ver 1.0 of Pi_SDR.

Regards,
    John Telek.
