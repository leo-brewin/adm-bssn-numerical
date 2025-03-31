SHELL = /bin/sh
.PHONY:	all data merge results clean veryclean pristine
#-------------------------------------------------------------------------------
all:
	@ (cd templates; merge.sh)
	@ build.sh
merge:
	@ (cd templates; merge.sh) # must do this before compiling admevolve & adminitial
data:
	@ adminitial.sh
results:
	@ admevolve.sh
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
	@ rm -rf src/admbase-constraints.adb
	@ rm -rf src/admbase-time_derivs.adb
	@ (cd templates; make pristine)
