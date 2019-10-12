SHELL = /bin/bash
#-------------------------------------------------------------------------------
.PHONY:	data results
#-------------------------------------------------------------------------------
all:
	@ build.sh
data:
	@ bssninitial.sh
results:
	@ bssnevolve.sh
pristine:
	@ rm -rf *.log
	@ rm -rf bin
	@ rm -rf obj
	@ rm -rf data
	@ rm -rf results
	@ rm -rf template/cadabra
	@ rm -rf src/bssnbase-constraints.adb
	@ rm -rf src/bssnbase-time_derivs.adb
	@ (cd template; make pristine)