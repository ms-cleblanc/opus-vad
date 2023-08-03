#!/bin/bash

# This script is Adapted from https://github.com/ThirdPartyNinjas/opus_ios

OPUS_VERSION="1.3.1"
MIN_VERSION="4.3"
INSTALL_DIR="lib-ios"

build()
{
	SDK=$1
	ARCH=$2

	SYSROOT=eval xcrun -sdk ${SDK} --show-sdk-path

	rm -rf "opus-${OPUS_VERSION}"
	tar -zxvf "opus-${OPUS_VERSION}.tar.gz"
	cd "opus-${OPUS_VERSION}"
	patch -p1 < ../opus.patch
	cd ..

	cd "opus-${OPUS_VERSION}" && ./autogen.sh 

	export CC="xcrun -sdk ${SDK} clang -fembed-bitcode -arch ${ARCH}"
	export CCAS="xcrun -sdk ${SDK} clang -fembed-bitcode -arch ${ARCH}"

#	export CC="xcrun -sdk ${SDK} clang -arch ${ARCH} -miphoneos-version-min=${MIN_VERSION}"
#	export CCAS="xcrun -sdk ${SDK} clang -arch ${ARCH} -miphoneos-version-min=${MIN_VERSION} -no-integrated-as"

	./configure --disable-doc --disable-extra-programs --with-sysroot=${SYSROOT} --host=arm-apple-darwin
	make clean && make

	cp .libs/libopus.a ../temp/libopus_${ARCH}.a
	cd ..
	rm -rf "opus-${OPUS_VERSION}"
}

rm -rf temp
mkdir temp

if [ ! -e "./v${OPUS_VERSION}.zip" ]; then
	echo "Downloading opus-${OPUS_VERSION}.tar.gz"
	curl -LOk https://archive.mozilla.org/pub/opus/opus-${OPUS_VERSION}.tar.gz
fi

build iphoneos armv7
build iphoneos armv7s
build iphoneos arm64
build iphonesimulator i386
build iphonesimulator x86_64

rm -rf ${INSTALL_DIR}
mkdir ${INSTALL_DIR}
pwd
cd ..
#lipo temp/libopus_arm64.a temp/libopus_i386.a temp/libopus_x86_64.a -create -output lib-ios/libopus.a
#lipo temp/libopus_armv7.a -create -output ${INSTALL_DIR}/libopus.a
lipo temp/libopus_armv7.a temp/libopus_armv7s.a temp/libopus_arm64.a temp/libopus_i386.a temp/libopus_x86_64.a -create -output ${INSTALL_DIR}/libopus-1.3.a
lipo -info ${INSTALL_DIR}/libopus.a

#rm -rf temp
