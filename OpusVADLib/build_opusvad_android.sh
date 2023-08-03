#!/bin/bash

OPUS_VERSION="1.3.1"
MIN_VERSION="4.3"
INSTALL_DIR="../lib-android"
NDK_LOCATION=$1

build()
{
	COMPILER=$1
	HOST=$2
    ARCH=$3

	export CC=${COMPILER}
	export LDFLAGS=-L${INSTALL_DIR}/${ARCH}

	make -f Makefile.android

	cp libopusvadjava.so ${INSTALL_DIR}/${ARCH}/libopusvadjava.so
	make -f Makefile.android clean

}


build ${NDK_LOCATION}/toolchains/llvm/prebuilt/darwin-x86_64/bin/i686-linux-android27-clang i686-linux-androideabi x86
build ${NDK_LOCATION}/toolchains/llvm/prebuilt/darwin-x86_64/bin/x86_64-linux-android27-clang x86_64-linux-androideabi x86_64
build ${NDK_LOCATION}/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android27-clang aarch64-linux-androideabi arm64-v8a
build ${NDK_LOCATION}/toolchains/llvm/prebuilt/darwin-x86_64/bin/armv7a-linux-androideabi27-clang armv7a-linux-androideabi armeabi-v7a

ls -l ${INSTALL_DIR}/*