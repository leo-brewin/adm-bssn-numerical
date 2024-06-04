SHELL = /bin/sh
.PHONY:	bin clean veryclean pristine
.SECONDARY:
#-------------------------------------------------------------------------------
ADA      = gnatmake
ADAPKG   = ../../../support/
#-------------------------------------------------------------------------------
LIBTYPE  = -shared # -static, use shared or static libs
#-------------------------------------------------------------------------------
# DEBUG    = -g
OPTIMIZE = -O3       # also -Og for debugging
WARNINGS = -gnatwa   # -gnatwa or -gnatwA
MODE     = -gnat2022 # -gnat2012
REPORT   = -q        # suppress gnatmake commands
GNATOPTS = # -gnats    # Syntax check only
PACKAGES = -I. -I$(ADAPKG)
ADAFLAGS = -i $(PACKAGES) $(REPORT) $(GNATOPTS)
CARGS    = -cargs $(DEBUG) $(OPTIMIZE) $(WARNINGS) $(MODE)
BARGS    = -bargs -E $(LIBTYPE)
LARGS    = -largs -dead_strip -no-pie
ONEXIT   = rm -f $*.adalog # normal exit, delete adalog file on success
# ONEXIT   = :             # keep the adalog file, useful with -gnatwa
#-------------------------------------------------------------------------------
TARGETS  = $(sort $(patsubst %.adb,%,$(wildcard *.adb)) )
#-------------------------------------------------------------------------------
all:
	@ for file in $(TARGETS); do make $${file}; done;
#-------------------------------------------------------------------------------
%: %.sh
%:	%.o
.TimeStamp:
	touch .TimeStamp
%: %.adb %.ads .TimeStamp
	@ echo "gnatmake $*.adb ..."
	@ rm -f .fail-$*
	@ $(ADA) $(ADAFLAGS) $*.adb $(CARGS) $(BARGS) $(LARGS) &> $*.adalog; \
	if [ $$? = 0 ]; \
		then $(ONEXIT); touch .TimeStamp; \
		else touch .fail-$*; exit 1; \
	fi
#-------------------------------------------------------------------------------
clean:
	@ for file in $(TARGETS); do rm -rf $${file}.o $${file}.ali b~$${file}*; done
veryclean:
	@ make clean
	@ for file in $(TARGETS); do rm -rf $${file}.adalog; done
pristine:
	@ make veryclean
	@ rm -rf .TimeStamp
	@ rm -rf *.adalog
	@ rm -rf *.ali
	@ rm -rf *.o
	@ rm -rf .fail*
