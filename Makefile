RMR ?=rm -f

LDLIBS += -lstdc++
CFLAGS += -Iinclude -D__BSD_VISIBLE -D_KERNEL
CXXFLAGS += $(CFLAGS)

BUILD_TARGET := "UNKOWN"

ifeq ($(LANG),)
BUILD_TARGET := "mingw"
else
BUILD_TARGET := $(findstring mingw, $(CC))
endif

ifeq ($(BUILD_TARGET),)
BUILD_TARGET := $(shell uname)
endif

ifeq ($(BUILD_TARGET), mingw)
TARGETS = txcat.exe netcat.exe
CFLAGS += -Iwindows
LDLIBS += -lws2_32
else
TARGETS = txcat
endif

ifeq ($(BUILD_TARGET), Linux)
LDLIBS += -lrt
endif

XCLEANS = txcat.o netcat.o
COREOBJ = tx_loop.o tx_timer.o tx_socket.o \
		  tx_platform.o tx_file.o tx_debug.o tx_stdio.o
OBJECTS = $(COREOBJ) tx_poll.o tx_select.o \
		  tx_epoll.o tx_kqueue.o tx_completion_port.o

all: $(TARGETS)

txcat.exe: txcat.o $(OBJECTS)
	$(CC) $(LDFLAGS) -o txcat.exe txcat.o $(OBJECTS) $(LDLIBS)

netcat.exe: netcat.o $(OBJECTS)
	$(CC) $(LDFLAGS) -o netcat.exe netcat.o $(OBJECTS) $(LDLIBS)

txcat: txcat.o $(OBJECTS)

.PHONY: clean

clean:
	$(RM) $(OBJECTS) $(TARGETS) $(XCLEANS)

