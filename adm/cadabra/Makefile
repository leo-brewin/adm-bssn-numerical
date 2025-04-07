SHELL = /bin/bash
#-------------------------------------------------------------------------------
.PHONY:	all merge code
#-------------------------------------------------------------------------------
TARGETS = adm-eqtns adm-code
#-------------------------------------------------------------------------------
all:
	@ touch shared.cdb # forces old versions of Cadabra < 2.5.12 to update its cache
	@ for file in $(TARGETS); do make .$${file}; done;
	@ make veryclean
#-------------------------------------------------------------------------------
adm-eqtns:
	@ make .adm-eqtns
.adm-eqtns: adm-eqtns.tex shared.cdb
	@ echo "> cadabra adm-eqtns ..."
	@ ${CDBLATEX} -s -i adm-eqtns &> adm-eqtns.cdblog
	@ touch .adm-eqtns
#-------------------------------------------------------------------------------
adm-code:
	@ echo "> cadabra adm-code ..."
	@ make .adm-code
.adm-code: adm-code.tex shared.cdb
	@ echo "> cadabra adm-code ..."
	@ ${CDBLATEX} -s -i adm-code &> adm-code.cdblog
	@ reformat.sh
	@ touch .adm-code
#-------------------------------------------------------------------------------
merge:
	@echo "> merge ..."
	@(cd ../code/templates; merge.sh)
#-------------------------------------------------------------------------------
code:
	@echo "> compile ..."
	@(cd ../code; build.sh)
#-------------------------------------------------------------------------------
%:
	@ echo "> cadabra $@ ..."
	@ ${CDBLATEX} -T -s -i $@ &> $@.cdblog
	@ # echo " -->"`cputime -i $@.cdblog`
	@ pdflatex -halt-on-error -interaction=batchmode $@ &> $@.texlog
	@ touch .$@
#-------------------------------------------------------------------------------
rm-dot:
	@ for file in $(TARGETS); \
	  do \
	     rm -rf .$${file}; \
	  done
#-------------------------------------------------------------------------------
clean:
	@ for file in $(TARGETS); \
	  do \
	     rm -rf $${file}.aux $${file}.log $${file}.texlog $${file}.out $${file}.synctex.gz; \
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
	@ rm -rf code-c/*.c
#-------------------------------------------------------------------------------
pristine:
	@ make rm-dot
	@ make veryclean
	@ rm -rf __pycache__
	@ for file in $(TARGETS); \
	  do \
	     rm -rf $${file}.pdf; \
		  rm -rf $${file}.json; \
		  rm -rf $${file}.cdbtex; \
	  done
#-------------------------------------------------------------------------------
# prepare files for github
github:
	@ make pristine
	@ make all
	@ make rm-dot
	@ make veryclean
