SHELL = /bin/bash
#-------------------------------------------------------------------------------
.PHONY:	all adm bssn utilities
#-------------------------------------------------------------------------------
TARGETS = adm-bssn-eqtns adm-bssn-plots
#-------------------------------------------------------------------------------
all:
	@ echo "> make adm bssn ..."
	@ (cd utilities; make)
	@ make adm
	@ make bssn
	@ ${CDBLATEX} -s -i adm-bssn-eqtns &> adm-bssn-eqtns.cdblog
	@ pdflatex -halt-on-error -interaction=batchmode adm-bssn-plots &> adm-bssn-plots.texlog
	@ make veryclean
#-------------------------------------------------------------------------------
adm:
	@ echo "> make adm ..."
	@ (cd adm/cadabra;  make)
	@ (cd adm/code;     make; make data; make results)
#-------------------------------------------------------------------------------
bssn:
	@ echo "> make bssn ..."
	@ (cd bssn/cadabra; make)
	@ (cd bssn/code;    make; make data; make results)
#-------------------------------------------------------------------------------
cadabra:
	@ echo "> make adm/cadabra ..."
	@ (cd adm/cadabra;  make)
	@ echo "> make bssn/cadabra ..."
	@ (cd bssn/cadabra; make)
#-------------------------------------------------------------------------------
code:
	@ echo "> make adm/code ..."
	@ (cd adm/code;     make)
	@ echo "> make bssn/code ..."
	@ (cd bssn/code;    make)
#-------------------------------------------------------------------------------
rm-dot:
	@ (cd bssn/code/templates; make rm-dot)
	@ (cd bssn/cadabra;        make rm-dot)
	@ (cd adm/code/templates;  make rm-dot)
	@ (cd adm/cadabra;         make rm-dot)
#-------------------------------------------------------------------------------
clean:
	@ for file in $(TARGETS); \
	  do \
	     rm -rf $${file}.aux $${file}.log $${file}.out $${file}.texlog $${file}.synctex.gz; \
	  done
#-------------------------------------------------------------------------------
veryclean:
	@ make clean
	@ for file in $(TARGETS); \
	  do \
	     rm -rf $${file}.cdb $${file}_.cdb; \
		  rm -rf $${file}.cdbidx $${file}.cdbtxt $${file}.cdblog; \
		  rm -rf $${file}.py; \
	  done
#-------------------------------------------------------------------------------
pristine:
	@ make rm-dot
	@ make veryclean
	@ rm -rf adm-bssn-*.pdf adm-bssn-*.cdbtex
	@ (cd utilities;    make pristine)
	@ (cd adm/cadabra;  make pristine)
	@ (cd adm/code;     make pristine)
	@ (cd bssn/cadabra; make pristine)
	@ (cd bssn/code;    make pristine)
#-------------------------------------------------------------------------------
github-clean:
	@ # same as "pristine" but keep the final pdf's
	@ make rm-dot
	@ make veryclean
	@ (cd utilities;    make pristine)
	@ (cd adm/cadabra;  make pristine)
	@ (cd adm/code;     make pristine)
	@ (cd bssn/cadabra; make pristine)
	@ (cd bssn/code;    make pristine)
#-------------------------------------------------------------------------------
github:
	@ make pristine
	@ make all
	@ make github-clean
