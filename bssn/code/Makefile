SHELL = /bin/sh
.PHONY:	all data merge results clean veryclean pristine
#-------------------------------------------------------------------------------
all:
	@ (cd templates; merge.sh)
	@ build.sh
merge:
	@ (cd templates; merge.sh) # must do this before compiling bssnevolve & bssninitial
data:
	@ bssninitial.sh
results:
	@ bssnevolve.sh
#-------------------------------------------------------------------------------
clean:
	@ rm -rf obj
veryclean:
	@ make clean
pristine:
	@ make veryclean
	@ rm -rf *.log
	@ rm -rf bin
	@ rm -rf data
	@ rm -rf results/xy results/xz results/yz
	@ rm -rf templates/code-ada
	@ rm -rf src/bssnbase-constraints.adb
	@ rm -rf src/bssnbase-time_derivs.adb
	@ (cd templates; make pristine)
