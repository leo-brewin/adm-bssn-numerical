SHELL = /bin/bash
#-------------------------------------------------------------------------------
.PHONY: all merge code
#-------------------------------------------------------------------------------
TARGETS = \
		bssn-eqtns-09 bssn-eqtns-10 bssn-eqtns-11\
		bssn-eqtns-12 bssn-eqtns-14 bssn-eqtns-20\
		bssn-lapse bssn-ricci-scalar bssn-constraints\
		bssn-eqtns bssn-code
#-------------------------------------------------------------------------------
all:
	@ make shared.py
	@ for file in $(TARGETS); do make .$${file}; done;
	@ make veryclean
#-------------------------------------------------------------------------------
.bssn-eqtns-09: bssn-eqtns-09.tex shared.py
	@ make bssn-eqtns-09
.bssn-eqtns-10: bssn-eqtns-10.tex shared.py
	@ make bssn-eqtns-10
.bssn-eqtns-11: bssn-eqtns-11.tex shared.py
	@ make bssn-eqtns-11
.bssn-eqtns-12: bssn-eqtns-12.tex shared.py
	@ make bssn-eqtns-12
.bssn-eqtns-14: bssn-eqtns-14.tex shared.py
	@ make bssn-eqtns-14
.bssn-eqtns-20: bssn-eqtns-20.tex shared.py
	@ make bssn-eqtns-20
.bssn-lapse: bssn-lapse.tex shared.py
	@ make bssn-lapse
.bssn-ricci-scalar: bssn-ricci-scalar.tex bssn-eqtns-14.tex shared.py
	@ make bssn-ricci-scalar
.bssn-constraints: bssn-constraints.tex shared.py
	@ make bssn-constraints
#-------------------------------------------------------------------------------
shared.py: hide/shared.cdb
	@ echo "> cadabra2python shared ..."
	@ cadabra2python hide/shared.cdb shared.py
#-------------------------------------------------------------------------------
bssn-eqtns:
	@ make .bssn-eqtns
.bssn-eqtns: bssn-eqtns.tex  shared.py\
	          .bssn-eqtns-09 .bssn-eqtns-10 .bssn-eqtns-11\
	          .bssn-eqtns-12 .bssn-eqtns-14 .bssn-eqtns-20\
				 .bssn-lapse .bssn-ricci-scalar .bssn-constraints
	@ # note: bssn-eqtns.tex is a pure LaTeX file
	@ echo "> pdflatex bssn-eqtns ..."
	@ pdflatex -halt-on-error -interaction=batchmode bssn-eqtns &> bssn-eqtns.texlog
	@ touch .bssn-eqtns
#-------------------------------------------------------------------------------
bssn-code:
	@ echo "> cadabra bssn-code ..."
	@ make .bssn-code
.bssn-code: bssn-code.tex  shared.py\
	        .bssn-eqtns-09 .bssn-eqtns-10 .bssn-eqtns-11\
	        .bssn-eqtns-12 .bssn-eqtns-14 .bssn-eqtns-20\
			  .bssn-lapse    .bssn-ricci-scalar .bssn-constraints
	@ echo "> cadabra bssn-code ..."
	@ ${CDBLATEX} -s -i bssn-code &> bssn-code.cdblog
	@ reformat.sh
	@ touch .bssn-code
#-------------------------------------------------------------------------------
merge:
	@ echo "> merge ..."
	@ (cd ../code/templates; merge.sh)
#-------------------------------------------------------------------------------
code:
	@ echo "> compile ..."
	@ (cd ../code; build.sh)
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
