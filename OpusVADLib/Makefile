UNAME=$(shell uname)
OPUS_VERSION=1.3.1
OPUSSRC=../opus-$(OPUS_VERSION)
CFLAGS=-O -fPIC -Wall -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/linux -I$(OPUSSRC)/include -I$(OPUSSRC)/src -I$(OPUSSRC)/celt -I$(OPUSSRC)/silk -I$(OPUSSRC)/silk/float -std=c99
LDLIBS=-lopus
LDFLAGS=-L$(OPUSSRC)/.libs
ifeq ($(UNAME),Darwin)
  LDFLAGS+=-shared
  LIBEXT=dylib
  LDLIBS+=-lc
  LD=gcc
  JAVAHOSTOS=darwin
else
  LDFLAGS+=-shared
  LIBEXT=so
  JAVAHOSTOS=linux
endif

OBJS=opusvad.o adpcm.o dequeue.o

.DEFAULT: libopusvad.$(LIBEXT)

libopusvad.$(LIBEXT): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^ $(LDLIBS)

opusvadjava.o: CFLAGS+=-I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/$(JAVAHOSTOS)

libopusvadjava.$(LIBEXT): $(OBJS) opusvadjava.o
	$(LD) $(LDFLAGS) -o $@ $^ $(LDLIBS)

debug: CFLAGS += -DDEBUG -g
debug: libopusvad.$(LIBEXT)

clean:
	rm -f *.$(LIBEXT) *.o
	rm -rf doc

doc:
	doxygen

.PHONY: clean doc
