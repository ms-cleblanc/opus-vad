UNAME=$(shell uname)
OPUS_VERSION=1.3.1
OPUS_SRC=../opus-$(OPUS_VERSION)
CFLAGS=-I../OpusVADLib -Wall -std=c99
LDFLAGS=-L$(OPUS_SRC)/.libs -L../OpusVADLib
ifeq ($(UNAME),Darwin)
	LDLIBS=-lopusvad -lopus
else
	LDLIBS=../OpusVADLib/dequeue.o ../OpusVADLib/opusvad.o ../OpusVADLib/adpcm.o $(OPUS_SRC)/.libs/libopus.a -luuid -lm
endif

ifdef USEMUSL
  CC=musl-gcc
  CFLAGS+=-static
  LDLIBS=../OpusVADLib/opusvad.o $(OPUS_SRC)/.libs/libopus.a
endif

opusvadtool:

clean:
	rm -f opusvadtool opusvadtool.o

.PHONY: clean
