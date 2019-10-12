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
	@ rm -rf *.log
	@ rm -rf bin
	@ rm -rf obj
	@ rm -rf data
	@ rm -rf results
	@ rm -rf template/cadabra
	@ rm -rf src/admbase-constraints.adb
	@ rm -rf src/admbase-time_derivs.adb
	@ (cd template; make pristine)
