#!/bin/bash

# This script is Adapted from https://github.com/ThirdPartyNinjas/opus_ios

OPUS_VERSION="1.3.1"
MIN_VERSION="4.3"
INSTALL_DIR="../lib-android"
NDK_LOCATION=$1

build()
{
	COMPILER=$1
	HOST=$2
    ARCH=$3

	rm -rf "opus-${OPUS_VERSION}"
	tar -zxvf "opus-${OPUS_VERSION}.tar.gz"
	cd "opus-${OPUS_VERSION}"
	patch -p1 < ../opus.patch
	cd ..

	cd "opus-${OPUS_VERSION}"

	export CC="${COMPILER}"

	mkdir ${INSTALL_DIR}/${ARCH}

    ./configure --disable-doc --disable-extra-programs CC=${COMPILER} --host=${HOST}
	make clean && make

	cp .libs/libopus.so ${INSTALL_DIR}/${ARCH}/libopus.so
	cd ..
	rm -rf "opus-${OPUS_VERSION}"
}

rm -rf ${INSTALL_DIR}
mkdir ${INSTALL_DIR}

if [ ! -e "./v${OPUS_VERSION}.zip" ]; then
	echo "Downloading opus-${OPUS_VERSION}.tar.gz"
	curl -LOk https://archive.mozilla.org/pub/opus/opus-${OPUS_VERSION}.tar.gz
fi

build ${NDK_LOCATION}/toolchains/llvm/prebuilt/darwin-x86_64/bin/i686-linux-android27-clang i686-linux-androideabi x86
build ${NDK_LOCATION}/toolchains/llvm/prebuilt/darwin-x86_64/bin/x86_64-linux-android27-clang x86_64-linux-androideabi x86_64
build ${NDK_LOCATION}/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android27-clang aarch64-linux-androideabi arm64-v8a
build ${NDK_LOCATION}/toolchains/llvm/prebuilt/darwin-x86_64/bin/armv7a-linux-androideabi27-clang armv7a-linux-androideabi armeabi-v7a

pwd
ls -l ${INSTALL_DIR}/*
