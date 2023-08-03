#!/bin/bash

OPUS_VERSION="1.3.1"

MIN_VERSION="4.3"
INSTALL_DIR="../lib-ios"

build()
{
	SDK=$1
	ARCH=$2

	SYSROOT=eval xcrun -sdk ${SDK} --show-sdk-path

	pushd .

	#export CC="xcrun -sdk ${SDK} clang -arch ${ARCH} -miphoneos-version-min=${MIN_VERSION}"
	export CC="xcrun -sdk ${SDK} clang -arch ${ARCH}"
	make -f Makefile.ios

	cp libopusvad.a ./temp/libopusvad_${ARCH}.a
	make -f Makefile.ios clean

	popd
}

cd ..
if [ ! -e "./v${OPUS_VERSION}.zip" ]; then
	echo "Downloading opus-${OPUS_VERSION}.tar.gz"
	https://archive.mozilla.org/pub/opus/opus-${OPUS_VERSION}.tar.gz
	unzip v${OPUS_VERSION}.zip
fi
rm -rf "opus-${OPUS_VERSION}"
unzip "v${OPUS_VERSION}.zip"
patch -p1 < opus-1.3.patch
cd "opus-${OPUS_VERSION}" && ./autogen.sh 

cd ../OpusVADLib

rm -rf temp
mkdir temp

build iphoneos armv7
build iphoneos armv7s
build iphoneos arm64
build iphonesimulator i386
build iphonesimulator x86_64

rm -f ${INSTALL_DIR}/libopusvad.a
mkdir -p ${INSTALL_DIR}

#lipo temp/libopusvad_armv7.a temp/libopusvad_armv7s.a temp/libopusvad_arm64.a temp/libopusvad_i386.a temp/libopusvad_x86_64.a -create -output ${INSTALL_DIR}/libopusvad.a
lipo temp/libopusvad_armv7s.a temp/libopusvad_arm64.a temp/libopusvad_i386.a temp/libopusvad_x86_64.a -create -output ${INSTALL_DIR}/libopusvad.a
lipo -info ${INSTALL_DIR}/libopusvad.a

rm -rf temp
