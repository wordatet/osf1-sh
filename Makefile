# Portable Makefile for OSF/1 v2.0 sh
CC = cc
CFLAGS = -O2 -Wall -g -D_POSIX_C_SOURCE=200809L -D_XOPEN_SOURCE=700 -Wno-pointer-sign -I.
LDFLAGS =

OFILES = main.o args.o blok.o cmd.o ctype.o defs.o \
         echo.o error.o expand.o fault.o func.o \
         hash.o hashserv.o io.o macro.o \
         msg.o name.o nls.o print.o pwd.o \
         service.o setbrk.o stak.o string.o \
         test.o word.o xec.o

all: sh

sh: $(OFILES)
	$(CC) $(CFLAGS) -o sh $(OFILES) $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f sh $(OFILES)

.PHONY: all clean
