SHELL = /bin/sh
.PHONY:	data results bin obj clean veryclean pristine
.SECONDARY:
#-------------------------------------------------------------------------------
all:
	@ build.sh
merge:
	@ (cd template; merge.sh) # must do this before compiling bssnevolve & bssninitial
data:
	@ bssninitial.sh
results:
	@ bssnevolve.sh
#-------------------------------------------------------------------------------
ADA      = gnatmake
ADAPKG   = ../../support/
SRCPKG   = ./src/
#-------------------------------------------------------------------------------
LIBTYPE  = -shared # -static, use shared or static libs
#-------------------------------------------------------------------------------
DEBUG    = -g
OPTIMIZE = -O3       # also -Og for debugging
WARNINGS = -gnatwa   # -gnatwa or -gnatwA
MODE     = -gnat2022 # -gnat2012
REPORT   = -q        # suppress gnatmake commands
GNATOPTS = # -gnats  # Syntax check only
PACKAGES = -I. -I$(ADAPKG) -I$(SRCPKG)
ADAFLAGS = -D obj $(PACKAGES) $(REPORT) $(GNATOPTS)
CARGS    = -cargs $(DEBUG) $(OPTIMIZE) $(WARNINGS) $(MODE)
BARGS    = -bargs -E $(LIBTYPE)
LARGS    = -largs -dead_strip -no-pie
ONEXIT   = rm -f $*.adalog # normal exit, delete adalog file on success
# ONEXIT   = :             # keep the adalog file, useful with -gnatwa
#-------------------------------------------------------------------------------
TARGETS  = $(sort $(patsubst %.adb,%,$(wildcard *.adb)) )
#-------------------------------------------------------------------------------
bin:
	@ for file in $(TARGETS); do make $${file}; done;
#-------------------------------------------------------------------------------
%: %.sh
%:	%.o
.TimeStamp:
	touch .TimeStamp
$(ADAPKG)/.TimeStamp:
	@ (cd $(ADAPKG); make)
bin/%: %.adb .TimeStamp $(ADAPKG)/.TimeStamp
	@ echo "gnatmake $*.adb ..."
	@ rm -f bin/$* .fail-$*
	@ $(ADA) -o bin/$* $(ADAFLAGS) $< $(CARGS) $(BARGS) $(LARGS) &> $*.adalog; \
	if [ $$? = 0 ]; \
		then $(ONEXIT); touch .TimeStamp; \
		else touch .fail-$*; exit 1;\
	fi
%:
	@ mkdir -p bin
	@ mkdir -p obj
	@ make bin/$@
#-------------------------------------------------------------------------------
clean:
	@ for file in $(TARGETS); do rm -rf $${file}.adalog obj/$${file}.o obj/$${file}.ali; done
veryclean:
	@ make clean
	@ for file in $(TARGETS); do rm -rf obj/$${file}.adb bin/$${file}; done
pristine:
	@ make veryclean
	@ rm -rf .TimeStamp
	@ rm -rf *.adalog
	@ rm -rf .fail*
	@ rm -rf *.log
	@ rm -rf bin
	@ rm -rf obj
	@ rm -rf data
	@ rm -rf results
	@ rm -rf template/code-ada
	@ rm -rf src/bssnbase-constraints.adb
	@ rm -rf src/bssnbase-time_derivs.adb
	@ (cd template; make pristine)
