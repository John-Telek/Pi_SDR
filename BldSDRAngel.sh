#!/bin/bash
echo Downloading and Building SDRAngel


sudo mkdir -p /opt/build
sudo chown $USER:users /opt/build
sudo mkdir -p /opt/install
sudo chown $USER:users /opt/install

sudo apt update; sudo apt -y install \
git cmake g++ pkg-config autoconf automake libtool libfftw3-dev libusb-1.0-0-dev libusb-dev libhidapi-dev libopengl-dev \
qtbase5-dev qtchooser libqt5multimedia5-plugins qtmultimedia5-dev libqt5websockets5-dev \
qttools5-dev qttools5-dev-tools libqt5opengl5-dev libqt5quick5 libqt5charts5-dev \
qml-module-qtlocation  qml-module-qtpositioning qml-module-qtquick-window2 \
qml-module-qtquick-dialogs qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qtquick-layouts \
libqt5serialport5-dev qtdeclarative5-dev qtpositioning5-dev qtlocation5-dev libqt5texttospeech5-dev \
qtwebengine5-dev qtbase5-private-dev libqt5gamepad5-dev \
libfaad-dev zlib1g-dev libboost-all-dev libasound2-dev pulseaudio libopencv-dev libxml2-dev bison flex \
ffmpeg libavcodec-dev libavformat-dev libopus-dev doxygen graphviz libsndfile-dev

echo Creating Directories.

echo Building APTDEC

cd /opt/build
git clone https://github.com/srcejon/aptdec.git
cd aptdec
git checkout libaptdec
git submodule update --init --recursive
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/aptdec ..
make -j3 install

echo Building CM256cc

cd /opt/build
git clone https://github.com/f4exb/cm256cc.git
cd cm256cc
git reset --hard c0e92b92aca3d1d36c990b642b937c64d363c559
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/cm256cc ..
make -j3 install

echo Building LibDAB

cd /opt/build
git clone https://github.com/srcejon/dab-cmdline
cd dab-cmdline/library
git checkout msvc
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/libdab ..
make -j3 install

echo Building MBElib

cd /opt/build
git clone https://github.com/szechyjs/mbelib.git
cd mbelib
git reset --hard 9a04ed5c78176a9965f3d43f7aa1b1f5330e771f
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/mbelib ..
make -j3 install

echo Building SerialDV

cd /opt/build
git clone https://github.com/f4exb/serialDV.git
cd serialDV
git reset --hard "v1.1.4"
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/serialdv ..
make -j $(nproc) install

echo Building DSDcc

cd /opt/build
git clone https://github.com/f4exb/dsdcc.git
cd dsdcc
git reset --hard "v1.9.3"
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/dsdcc -DUSE_MBELIB=ON -DLIBMBE_INCLUDE_DIR=/opt/install/mbelib/include -DLIBMBE_LIBRARY=/opt/install/mbelib/lib/libmbe.so -DLIBSERIALDV_INCLUDE_DIR=/opt/install/serialdv/include/serialdv -DLIBSERIALDV_LIBRARY=/opt/install/serialdv/lib/libserialdv.so ..
make -j3 install

echo Building Codec2/FreeDV

sudo apt-get -y install libspeexdsp-dev libsamplerate0-dev
cd /opt/build
git clone https://github.com/drowe67/codec2.git
cd codec2
git reset --hard 76a20416d715ee06f8b36a9953506876689a3bd2
mkdir build_linux; cd build_linux
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/codec2 ..
make -j3 install

echo Building SGP4

cd /opt/build
git clone https://github.com/dnwrnr/sgp4.git
cd sgp4
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/sgp4 ..
make -j3 install

echo Building LibSigMF

cd /opt/build
git clone https://github.com/f4exb/libsigmf.git
cd libsigmf
git checkout "new-namespaces"
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/libsigmf .. 
make -j3 install

echo Making Hardware Dependencies

echo Airspy

cd /opt/build
git clone https://github.com/airspy/airspyone_host.git libairspy
cd libairspy
git reset --hard 37c768ce9997b32e7328eb48972a7fda0a1f8554
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/libairspy ..
make -j3 install

echo SDRplay RSP1

cd /opt/build
git clone https://github.com/f4exb/libmirisdr-4.git
cd libmirisdr-4
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/libmirisdr ..
make -j3 install

echo RTL-SDR

cd /opt/build
git clone https://github.com/osmocom/rtl-sdr.git librtlsdr
cd librtlsdr
git reset --hard be1d1206bfb6e6c41f7d91b20b77e20f929fa6a7
mkdir build; cd build
cmake -Wno-dev -DDETACH_KERNEL_DRIVER=ON -DCMAKE_INSTALL_PREFIX=/opt/install/librtlsdr ..
make -j3 install

HackRF

cd /opt/build
git clone https://github.com/greatscottgadgets/hackrf.git
cd hackrf/host
git reset --hard "v2022.09.1"
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/libhackrf -DINSTALL_UDEV_RULES=OFF ..
make -j3 install

echo Building SDRAngel

cd /opt/build
git clone https://github.com/f4exb/sdrangel.git
cd sdrangel
mkdir build; cd build
cmake -Wno-dev -DDEBUG_OUTPUT=ON -DRX_SAMPLE_24BIT=ON \
-DCMAKE_BUILD_TYPE=RelWithDebInfo \
-DAIRSPY_DIR=/opt/install/libairspy \
-DHACKRF_DIR=/opt/install/libhackrf \
-DRTLSDR_DIR=/opt/install/librtlsdr \
-DAPT_DIR=/opt/install/aptdec \
-DCM256CC_DIR=/opt/install/cm256cc \
-DDSDCC_DIR=/opt/install/dsdcc \
-DSERIALDV_DIR=/opt/install/serialdv \
-DMBE_DIR=/opt/install/mbelib \
-DCODEC2_DIR=/opt/install/codec2 \
-DSGP4_DIR=/opt/install/sgp4 \
-DLIBSIGMF_DIR=/opt/install/libsigmf \
-DDAB_DIR=/opt/install/libdab \
-DCMAKE_INSTALL_PREFIX=/opt/install/sdrangel ..
make -j3 install

echo Compilation Complete




