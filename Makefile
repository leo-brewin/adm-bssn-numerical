SHELL = /bin/bash
#-------------------------------------------------------------------------------
.PHONY:	adm bssn utilities
#-------------------------------------------------------------------------------
TARGETS = adm-bssn-eqtns adm-bssn-plots
#-------------------------------------------------------------------------------
all:
	@ echo "> make install adm bssn ..."
	@ make install
	@ make adm
	@ make bssn
	@ cdblatex.sh -s -i adm-bssn-eqtns &> adm-bssn-eqtns.cdblog
	@ pdflatex -halt-on-error -interaction=batchmode adm-bssn-plots &> /dev/null
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
install:
	@ echo "> make intsall ..."
	@ INSTALL.sh
#-------------------------------------------------------------------------------
rm-dot:
	@ (cd bssn/code/template; make rm-dot)
	@ (cd bssn/cadabra;       make rm-dot)
	@ (cd adm/code/template;  make rm-dot)
	@ (cd adm/cadabra;        make rm-dot)
	@ rm -rf .[a-z]*.lb
#-------------------------------------------------------------------------------
clean:
	@ for file in $(TARGETS); \
	  do \
	     rm -rf $${file}.aux $${file}.log $${file}.out $${file}.synctex.gz; \
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
	@ make rm-dot
	@ make veryclean
	@ rm -rf adm-bssn-*.cdbtex
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
