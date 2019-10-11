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
	@ rm -rf bin
	@ rm -rf obj
	@ rm -rf data
	@ rm -rf results
	@ rm -rf template/cadabra
	@ (cd template; make pristine)