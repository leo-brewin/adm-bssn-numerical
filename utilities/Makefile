SHELL = /bin/sh
.PHONY:	clean veryclean pristine
#-------------------------------------------------------------------------------
all:
	build.sh
#-------------------------------------------------------------------------------
clean:
	@ rm -rf obj
veryclean:
	@ make clean
pristine:
	@ make veryclean
	@ rm -rf bin
