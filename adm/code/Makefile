SHELL = /bin/bash
#-------------------------------------------------------------------------------
.PHONY:	data results
#-------------------------------------------------------------------------------
all:
	@ build.sh
data:
	@ adminitial.sh
results:
	@ admevolve.sh
pristine:
	@ rm -rf bin
	@ rm -rf obj
	@ rm -rf data
	@ rm -rf results
	@ rm -rf template/cadabra
	@ (cd template; make pristine)