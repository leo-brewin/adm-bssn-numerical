SHELL = /bin/bash
#-------------------------------------------------------------------------------
.PHONY:	all merge code
#-------------------------------------------------------------------------------
TARGETS = adm-eqtns adm-code
#-------------------------------------------------------------------------------
all:
	@ make shared.py
	@ for file in $(TARGETS); do make .$${file}; done;
	@ make veryclean
#-------------------------------------------------------------------------------
shared.py: hide/shared.cdb
	@ echo "> cadabra2python shared ..."
	@ cadabra2python hide/shared.cdb shared.py
#-------------------------------------------------------------------------------
adm-eqtns:
	@ make .adm-eqtns
.adm-eqtns: adm-eqtns.tex shared.py
	@ echo "> cadabra adm-eqtns ..."
	@ cdblatex.sh -s -i adm-eqtns &> adm-eqtns.cdblog
	@ touch .adm-eqtns
#-------------------------------------------------------------------------------
adm-code:
	@ echo "> cadabra adm-code ..."
	@ make .adm-code
.adm-code: adm-code.tex shared.py
	@ echo "> cadabra adm-code ..."
	@ cdblatex.sh -s -i adm-code &> adm-code.cdblog
	@ reformat.sh
	@ mkdir -p              ../code/template/code-ada
	@ cp -rf code-ada/*.ad  ../code/template/code-ada/.
	@ touch .adm-code
#-------------------------------------------------------------------------------
merge:
	@echo "> merge ..."
	@(cd ../code/template; merge.sh)
#-------------------------------------------------------------------------------
code:
	@echo "> compile ..."
	@(cd ../code; build.sh)
#-------------------------------------------------------------------------------
%:
	@ echo "> cdblatex.sh $@ ..."
	@ cdblatex.sh -T -s -i $@ &> $@.cdblog
	@ # echo " -->"`cputime -i $@.cdblog`
	@ pdflatex -halt-on-error -interaction=batchmode $@ &> $@.texlog
	@ touch .$@
#-------------------------------------------------------------------------------
rm-dot:
	@ for file in $(TARGETS); \
	  do \
	     rm -rf .$${file}; \
	  done
	@ rm -rf .[a-z]*.lb
	@ rm -rf .merged.tex .tmp.txt
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
	@ rm -rf code-c/*.c code-ada/*.ad
	@ rm -rf .merged.tex .tmp.txt
#-------------------------------------------------------------------------------
pristine:
	@ make rm-dot
	@ make veryclean
	@ rm -rf shared.py
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
