# Define your C compiler.  I recommend gcc if you have it.
# MacOS users should use "cc" even though it's really "gcc".
#
#CC = distcc
CC = gcc
#CC = cc
#CC = /opt/gnu/bin/gcc

# Define your optimization flags.  Most compilers understand -O and -O2,
# Standard (note: Solaris on UltraSparc using gcc 2.8.x might not like this.)
#
#OPTS = -O2 -g
OPTS = -g -ansi -pedantic -Wall -Wstrict-prototypes

# Pentium with gcc 2.7.0 or better
#OPTS = -O2 -fomit-frame-pointer -malign-functions=2 -malign-loops=2 \
#-malign-jumps=2

# Define where you want Frotz installed.  Usually this is /usr/local
PREFIX = /usr/local

MAN_PREFIX = $(PREFIX)
#MAN_PREFIX = /usr/local/share

CONFIG_DIR = $(PREFIX)/etc
#CONFIG_DIR = /etc

# Define where you want Frotz to look for frotz.conf.
#
CONFIG_DIR = $(PREFIX)/etc
#CONFIG_DIR = /etc
#CONFIG_DIR = /usr/pkg/etc
#CONFIG_DIR =

# Uncomment this if you want color support.  Most, but not all curses
# libraries that work with Frotz will support color.
#
#COLOR_DEFS = -DCOLOR_SUPPORT

# Uncomment these two if you want sound support
#SOUND_DEFS = -DESD_SOUND
#AUDIO_LIB = `esd-config --libs`

# If your vendor-supplied curses library won't work, uncomment the
# location where ncurses.h is.
#
#INCL = -I/usr/local/include
INCL = -I/usr/pkg/include
#INCL = -I/usr/freeware/include
#INCL = -I/5usr/include
#INCL = -I/path/to/ncurses.h

# If your vendor-supplied curses library won't work, uncomment the
# location where the ncurses library is.
#
#LIB = -L/usr/local/lib
LIB = -L/usr/pkg/lib
#LIB = -L/usr/freeware/lib
#LIB = -L/5usr/lib
#LIB = -L/path/to/libncurses.so

# One of these must always be uncommented.  If your vendor-supplied
# curses library won't work, comment out the first option and uncomment
# the second.
#
#CURSES = -lcurses
CURSES = -lncurses

# Uncomment this if your need to use ncurses instead of the
# vendor-supplied curses library.  This just tells the compile process
# which header to include, so don't worry if ncurses is all you have
# (like on Linux).  You'll be fine.
#
CURSES_DEF = -DUSE_NCURSES_H

XLIB = -L/usr/X11R6/lib -lSM -lICE -lX11 -lXt
XINCL = -I/usr/X11R6/include

# Uncomment this if you're compiling Unix Frotz on a machine that lacks
# the memmove(3) system call.  If you don't know what this means, leave it
# alone.
#
#MEMMOVE_DEF = -DNO_MEMMOVE

# Uncomment this if for some wacky reason you want to compile Unix Frotz
# under Cygwin under Windoze.  This sort of thing is not reccomended.
#
#EXTENSION = .exe


#####################################################
# Nothing under this line should need to be changed.
#####################################################

SRCDIR = src

VERSION = 2.44b6

NAME = frotz
BINNAME = $(NAME)

DISTFILES = bugtest

DISTNAME = $(BINNAME)-$(VERSION)
distdir = $(DISTNAME)

COMMON_DIR = $(SRCDIR)/common
COMMON_TARGET = $(SRCDIR)/frotz_common.a
COMMON_OBJECT = $(COMMON_DIR)/buffer.o \
		$(COMMON_DIR)/err.o \
		$(COMMON_DIR)/fastmem.o \
		$(COMMON_DIR)/files.o \
		$(COMMON_DIR)/hotkey.o \
		$(COMMON_DIR)/input.o \
		$(COMMON_DIR)/main.o \
		$(COMMON_DIR)/math.o \
		$(COMMON_DIR)/object.o \
		$(COMMON_DIR)/process.o \
		$(COMMON_DIR)/quetzal.o \
		$(COMMON_DIR)/random.o \
		$(COMMON_DIR)/redirect.o \
		$(COMMON_DIR)/screen.o \
		$(COMMON_DIR)/sound.o \
		$(COMMON_DIR)/stream.o \
		$(COMMON_DIR)/table.o \
		$(COMMON_DIR)/text.o \
		$(COMMON_DIR)/variable.o

# Curses interface
#
CURSES_DIR = $(SRCDIR)/curses
CURSES_TARGET = $(SRCDIR)/frotz_curses.a
CURSES_OBJECT = $(CURSES_DIR)/ux_init.o \
		$(CURSES_DIR)/ux_input.o \
		$(CURSES_DIR)/ux_pic.o \
		$(CURSES_DIR)/ux_screen.o \
		$(CURSES_DIR)/ux_text.o

# Dumb interface
#
DUMB_DIR = $(SRCDIR)/dumb
DUMB_TARGET = $(SRCDIR)/frotz_dumb.a
DUMB_OBJECT =	$(DUMB_DIR)/dumb_init.o \
		$(DUMB_DIR)/dumb_input.o \
		$(DUMB_DIR)/dumb_output.o \
		$(DUMB_DIR)/dumb_pic.o

# X11 interface with Xlib interface
#
XLIB_DIR = $(SRCDIR)/xlib
XLIB_TARGET = $(SRCDIR)/frotz_xlib.a
XLIB_OBJECT = $(XLIB_DIR)/x_init.o \
		$(XLIB_DIR)/x_input.o \
		$(XLIB_DIR)/x_pic.o \
		$(XLIB_DIR)/x_screen.o \
		$(XLIB_DIR)/x_text.o

# Blorb file handling
#
BLORB_DIR = $(SRCDIR)/blorb
BLORB_TARGET =	$(SRCDIR)/ux_blorb.a
BLORB_OBJECT =	$(BLORB_DIR)/blorblib.o \
		$(BLORB_DIR)/ux_blorb.o

# Audio code
#
AUDIO_DIR = $(SRCDIR)/audio
AUDIO_TARGET = $(SRCDIR)/frotz_audio.a
AUDIO_OBJECT = $(AUDIO_DIR)/audio.o \
		$(AUDIO_DIR)/audio_none.o


TARGETS = $(COMMON_TARGET) $(CURSES_TARGET) $(AUDIO_TARGET)

OPT_DEFS = -DCONFIG_DIR="\"$(CONFIG_DIR)\"" $(CURSES_DEF) \
	-DVERSION="\"$(VERSION)\""

COMP_DEFS = $(OPT_DEFS) $(COLOR_DEFS) $(SOUND_DEFS) $(MEMMOVE_DEF)

DUMB_DEFS = $(OPTS) -DCONFIG_DIR="\"$(CONFIG_DIR)\"" \
	-DVERSION="\"$(VERSION)\"" $(INCL)

FLAGS = $(OPTS) $(COMP_DEFS) $(INCL) $(XINCL)

$(NAME): $(NAME)-curses

curses:		$(NAME)-curses
$(NAME)-curses:		interface_curses $(COMMON_TARGET) $(CURSES_TARGET) $(AUDIO_TARGET) $(BLORB_TARGET)
	$(CC) -o $(BINNAME)$(EXTENSION) $(COMMON_TARGET) \
		$(CURSES_TARGET) $(AUDIO_TARGET) $(BLORB_TARGET) \
		$(LIB) $(CURSES) $(AUDIO_LIB)

#curses:		$(NAME)-curses
#$(NAME)-curses:		interface_curses $(COMMON_TARGET) $(CURSES_TARGET) $(AUDIO_TARGET)
#	$(CC) -o $(BINNAME)$(EXTENSION) $(COMMON_TARGET) \
#		$(CURSES_TARGET) $(AUDIO_TARGET) \
#		$(LIB) $(CURSES)

# all:	$(NAME) d$(NAME)

dumb:		$(NAME)-dumb
d$(NAME):	$(NAME)-dumb
$(NAME)-dumb:		$(COMMON_TARGET) $(DUMB_TARGET)
	$(CC) -o d$(BINNAME)$(EXTENSION) $(COMMON_TARGET) \
		$(DUMB_TARGET) $(LIB)


xlib:			$(NAME)-xlib
x$(NAME):		$(NAME)-xlib
$(NAME)-xlib:		soundcard.h interface_xlib $(COMMON_TARGET) $(XLIB_TARGET) $(AUDIO_TARGET) $(BLORB_TARGET)
	$(CC) -o x$(BINNAME)$(EXTENSION) $(COMMON_TARGET) $(AUDIO_TARGET) \
		$(XLIB_TARGET) $(BLORB_TARGET) $(LIB) $(XLIB)



.SUFFIXES:
.SUFFIXES: .c .o .h

.c.o:
	$(CC) $(FLAGS) $(CFLAGS) -o $@ -c $<

# If you're going to make these targets manually, you'd better know which
# config target to make first.
#
common_lib:	$(COMMON_TARGET)
$(COMMON_TARGET): $(COMMON_OBJECT)
	@echo
	@echo "Archiving common code..."
	ar rc $(COMMON_TARGET) $(COMMON_OBJECT)
	ranlib $(COMMON_TARGET)
	@echo

curses_lib:	$(CURSES_TARGET)
$(CURSES_TARGET): $(CURSES_OBJECT)
	@echo
	@echo "Archiving curses interface code..."
	ar rc $(CURSES_TARGET) $(CURSES_OBJECT)
	ranlib $(CURSES_TARGET)
	@echo

dumb_lib:	$(DUMB_TARGET)
$(DUMB_TARGET): $(DUMB_OBJECT)
	@echo
	@echo "Archiving dumb interface code..."
	ar rc $(DUMB_TARGET) $(DUMB_OBJECT)
	ranlib $(DUMB_TARGET)
	@echo

xlib_lib:	$(XLIB_TARGET)
$(XLIB_TARGET): $(XLIB_OBJECT)
	@echo
	@echo "Archiving X11 interface (raw XLib) code..."
	ar rc $(XLIB_TARGET) $(XLIB_OBJECT)
	ranlib $(XLIB_TARGET)
	@echo

blorb_lib:	$(BLORB_TARGET)
$(BLORB_TARGET): $(BLORB_OBJECT)
	@echo
	@echo "Archiving Blorb file handling code..."
	ar rc $(BLORB_TARGET) $(BLORB_OBJECT)
	ranlib $(BLORB_TARGET)
	@echo


#FIXME when the bugs are done

audio_lib:	interface_curses $(AUDIO_TARGET)
$(AUDIO_TARGET): $(AUDIO_OBJECT)
	@echo
	@echo "Archiving audio driver code..."
	ar rc $(AUDIO_TARGET) $(AUDIO_OBJECT)
	ranlib $(AUDIO_TARGET)
	@echo


install: $(NAME)
	strip $(BINNAME)$(EXTENSION)
	install -d $(PREFIX)/bin
	install -d $(MAN_PREFIX)/man/man6
	install -c -m 755 $(BINNAME)$(EXTENSION) $(PREFIX)/bin
	install -c -m 644 doc/$(NAME).6 $(MAN_PREFIX)/man/man6

uninstall:
	rm -f $(PREFIX)/bin/$(NAME)
	rm -f $(MAN_PREFIX)/man/man6/$(NAME).6

deinstall: uninstall

install_dumb: d$(NAME)
	strip d$(BINNAME)$(EXTENSION)
	install -d $(PREFIX)/bin
	install -d $(MAN_PREFIX)/man/man6
	install -c -m 755 d$(BINNAME)$(EXTENSION) $(PREFIX)/bin
	install -c -m 644 doc/d$(NAME).6 $(MAN_PREFIX)/man/man6

uninstall_dumb:
	rm -f $(PREFIX)/bin/d$(NAME)
	rm -f $(MAN_PREFIX)/man/man6/d$(NAME).6

deinstall_dumb: uninstall_dumb

install_xfrotz:	x$(NAME)
	strip x$(BINNAME)$(EXTENSION)
	install -d $(PREFIX)/bin
	install -d $(MAN_PREFIX)/man/man6
	install -c -m 755 x$(BINNAME)$(EXTENSION) $(PREFIX)/bin
	install -c -m 644 doc/x$(NAME).6 $(MAN_PREFIX)/man/man6

uninstall_xfrotz:
	rm -f $(PREFIX)/bin/x$(NAME)
	rm -f $(MAN_PREFIX)/man/man6/x$(NAME).6

distro: dist

dist: distclean
	mkdir $(distdir)
	@for file in `ls`; do \
		if test $$file != $(distdir); then \
			cp -Rp $$file $(distdir)/$$file; \
		fi; \
	done
	find $(distdir) -type l -exec rm -f {} \;
	tar chof $(distdir).tar $(distdir) --exclude=.svn
	gzip -f --best $(distdir).tar
	rm -rf $(distdir)
	@echo
	@echo "$(distdir).tar.gz created"
	@echo

clean:
	find $(SRCDIR) -name "*.o" -exec rm -f {} \;
	find $(SRCDIR) -name "*core" -exec rm -f {} \;
	rm -f $(SRCDIR)/*.h $(SRCDIR)/*.a
	rm -f endian
	rm -f *core

distclean: clean
	rm -f $(BINNAME)$(EXTENSION) d$(BINNAME)$(EXTENSION) x$(BINNAME)$(EXTENSION)
	-rm -rf $(distdir)
	-rm -f $(distdir).tar $(distdir).tar.gz

realclean: distclean

clobber: distclean

help:
	@echo
	@echo "Targets:"
	@echo "    frotz"
	@echo "    dumb"
	@echo "    xlib"
	@echo "    install"
	@echo "    uninstall"
	@echo "    clean"
	@echo "    distclean"
	@echo



# Assorted "mini-config" stuff

endian:	$(SRCDIR)/misc/endian.o
	$(CC) -o endian $(SRCDIR)/misc/endian.o
	@sh $(SRCDIR)/misc/endian.sh

interface_xlib:
	@sh $(SRCDIR)/misc/interface_check.sh $(SRCDIR) xlib;

interface_curses:
	@sh $(SRCDIR)/misc/interface_check.sh $(SRCDIR) curses;

soundcard.h:
	@if [ ! -f $(SRCDIR)/soundcard.h ] ; then \
		 sh $(SRCDIR)/misc/findsound.sh $(SRCDIR); \
	fi

