UNAME=$(shell uname)
OPUS_VERSION=1.3.1
OPUS_SRC=../../libopus-build-scripts/opus-$(OPUS_VERSION)
CFLAGS=-O -fPIC -Wall -std=c99 -I../../src -Wall -std=c99
LDFLAGS=-L$(OPUS_SRC)/.libs -L../../
ifeq ($(UNAME),Darwin)
	LDLIBS=-lopusvad -lopus
else
	LDLIBS=../../obj/dequeue.o ../../obj/opusvad.o ../../obj/adpcm.o $(OPUS_SRC)/.libs/libopus.a -luuid -lm
endif

ifdef USEMUSL
  CC=musl-gcc
  CFLAGS+=-static
  LDLIBS=../../obj/opusvad.o $(OPUS_SRC)/.libs/libopus.a
endif

opusvadtool:

clean:
	rm -f opusvadtool opusvadtool.o

.PHONY: clean
