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
shared.py: shared.cdb
	@ echo "> cadabra2python shared ..."
	@ cadabra2python shared.cdb shared.py
#-------------------------------------------------------------------------------
adm-eqtns:
	@ make .adm-eqtns
.adm-eqtns: adm-eqtns.tex shared.py
	@ echo "> cadabra adm-eqtns ..."
	@ cdblatex.sh -sx -i adm-eqtns &> adm-eqtns.cdblog
	@ echo "> pdflatex.sh adm-eqtns ..."
	@ pdflatex -halt-on-error -interaction=batchmode adm-eqtns &> /dev/null
	@ touch .adm-eqtns
#-------------------------------------------------------------------------------
adm-code:
	@ echo "> cadabra adm-code ..."
	@ make .adm-code
.adm-code: adm-code.tex
	@ echo "> cadabra adm-code ..."
	@ cdblatex.sh -s -i adm-code &> /tmp/tmp.del
	@ reformat.sh dot-N.c           set_3d_dot_N
	@ reformat.sh dot-Kab.c         set_3d_dot_Kab
	@ reformat.sh dot-gab.c         set_3d_dot_gab
	@ reformat.sh hessian.c         set_3d_hessian
	@ reformat.sh ricci.c           set_3d_ricci
	@ reformat.sh ricci-scalar.c    set_3d_ricci_scalar
	@ reformat.sh hamiltonian.c     set_hamiltonian
	@ reformat.sh momentum.c        set_momentum
	@ mkdir -p                   ../code/template/cadabra
	@ cp -rf dot-N.ad            ../code/template/cadabra/.
	@ cp -rf dot-Kab.ad          ../code/template/cadabra/.
	@ cp -rf dot-gab.ad          ../code/template/cadabra/.
	@ cp -rf hessian.ad          ../code/template/cadabra/.
	@ cp -rf ricci.ad            ../code/template/cadabra/.
	@ cp -rf ricci-scalar.ad     ../code/template/cadabra/.
	@ cp -rf hamiltonian.ad      ../code/template/cadabra/.
	@ cp -rf momentum.ad         ../code/template/cadabra/.
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
	@ # echo " -->"`cdbstats -i $@.cdblog`
	@ pdflatex -halt-on-error -interaction=batchmode $@ &> /dev/null
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
	@ rm -rf dot-N.c         dot-N.ad
	@ rm -rf dot-Kab.c       dot-Kab.ad
	@ rm -rf dot-gab.c       dot-gab.ad
	@ rm -rf hessian.c       hessian.ad
	@ rm -rf ricci.c         ricci.ad
	@ rm -rf ricci-scalar.c  ricci-scalar.ad
	@ rm -rf hamiltonian.c   hamiltonian.ad
	@ rm -rf momentum.c      momentum.ad
	@ rm -rf .merged.tex     .tmp.txt
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
