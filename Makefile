
### Library

dist_install_evilheaders_DATA = \
Evil.h \
evil_fcntl.h \
evil_inet.h \
evil_langinfo.h \
evil_macro.h \
evil_macro_pop.h \
evil_main.h \
evil_stdio.h \
evil_stdlib.h \
evil_string.h \
evil_time.h \
evil_unistd.h \
evil_util.h \
dirent.h \
dlfcn.h \
fnmatch.h \
pwd.h

dist_evilmmanheaders_DATA = \
lib/evil/sys/mman.h

lib_evil_libevil_la_SOURCES = \
evil_dirent.c \
evil_fcntl.c \
evil_fnmatch.c \
evil_fnmatch_list_of_states.c \
evil_inet.c \
evil_langinfo.c \
evil_link_xp.cpp \
evil_main.c \
evil_mman.c \
evil_pwd.c \
evil_stdio.c \
evil_stdlib.c \
evil_string.c \
evil_time.c \
evil_unistd.c \
evil_util.c \
evil_private.h \
evil_fnmatch_private.h


# regex

#dist_install_evilheaders_DATA += \
#regex/regex.h
#
#lib_evil_libevil_la_SOURCES += \
#regex/regcomp.c \
#regex/regerror.c \
#regex/regexec.c \
#regex/regfree.c \
#regex/cclass.h \
#regex/cname.h \
#regex/regex2.h \
#regex/utils.h

#EXTRA_DIST += \
#lib/evil/regex/regerror.ih \
#lib/evil/regex/engine.ih \
#lib/evil/regex/regcomp.ih \
#lib/evil/regex/engine.c \
#bin/evil/memcpy_glibc_i686.S


#lib_evil_libevil_la_CPPFLAGS = \
#-I$(top_srcdir)/src/lib/evil \
#-I$(top_srcdir)/src/lib/evil/regex \
#-DPOSIX_MISTAKE

### Binary

#suite_SOURCES +=  bin/evil/memcpy_glibc_i686.S # see EXTRA_DIST below!

bin_evil_evil_suite_CPPFLAGS = -I$(top_builddir)/src/lib/efl @EVIL_CFLAGS@
bin_evil_evil_suite_LDADD = @USE_EVIL_LIBS@ @DL_LIBS@ -lm
bin_evil_evil_suite_DEPENDENCIES = @USE_EVIL_INTERNAL_LIBS@ @DL_INTERNAL_LIBS@


########################################################

CC = gcc
XX = g++
CFLAGS = -Wall -O2
TARGET = ./libevil.a

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@ -I.

%.o:%.cpp
	$(XX) $(CFLAGS) -c $< -o $@ -I.

SOURCES = $(wildcard *.c *.cpp)
OBJS = $(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(SOURCES)))

$(TARGET) : $(OBJS)
	ar -r $(TARGET) $(OBJS)

clean:
	rm *.o
	rm $(TARGET)

DSTDIR = ./output
install:
	mkdir -p $(DSTDIR)/include
	mkdir -p $(DSTDIR)/lib
	cp $(TARGET) $(DSTDIR)/lib
	cp -r ./sys $(DSTDIR)/include
	cp *.h $(DSTDIR)/include
