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
shared.py: shared.cdb
	@ echo "> cadabra2python shared ..."
	@ cadabra2python shared.cdb shared.py
#-------------------------------------------------------------------------------
bssn-eqtns:
	@ make .bssn-eqtns
.bssn-eqtns: bssn-eqtns.tex  shared.py\
	          .bssn-eqtns-09 .bssn-eqtns-10 .bssn-eqtns-11\
	          .bssn-eqtns-12 .bssn-eqtns-14 .bssn-eqtns-20\
				 .bssn-lapse .bssn-ricci-scalar .bssn-constraints
	@ echo "> pdflatex bssn-eqtns ..."
	@ pdflatex -halt-on-error -interaction=batchmode bssn-eqtns &> /dev/null
	@ touch .bssn-eqtns
#-------------------------------------------------------------------------------
bssn-code:
	@ echo "> cadabra bssn-code ..."
	@ make .bssn-code
.bssn-code: bssn-code.tex  shared.py\
	        .bssn-eqtns-09 .bssn-eqtns-10 .bssn-eqtns-11\
	        .bssn-eqtns-12 .bssn-eqtns-14 .bssn-eqtns-20\
			  .bssn-lapse    .bssn-ricci-scalar .bssn-constraints
	@ echo "> cdblatex.sh bssn-code ..."
	@ cdblatex.sh -sx -i bssn-code &> bssn-code.cdblog
	@ pdflatex -halt-on-error -interaction=batchmode bssn-code &> /dev/null
	@ reformat.sh dot-gBar.c        set_3d_dot_gBar
	@ reformat.sh dot-ABar.c        set_3d_dot_ABar
	@ reformat.sh dot-N.c           set_3d_dot_N
	@ reformat.sh dot-Gi.c          set_3d_dot_Gi
	@ reformat.sh dot-phi.c         set_3d_dot_phi
	@ reformat.sh dot-trK.c         set_3d_dot_trK
	@ reformat.sh ricci.c           set_3d_ricci
	@ reformat.sh ricci-scalar.c    set_3d_ricci_scalar
	@ reformat.sh hamiltonian.c     set_hamiltonian
	@ reformat.sh momentum.c        set_momentum
	@ mkdir -p                   ../code/template/cadabra
	@ cp -rf dot-gBar.ad         ../code/template/cadabra/.
	@ cp -rf dot-ABar.ad         ../code/template/cadabra/.
	@ cp -rf dot-N.ad            ../code/template/cadabra/.
	@ cp -rf dot-Gi.ad           ../code/template/cadabra/.
	@ cp -rf dot-phi.ad          ../code/template/cadabra/.
	@ cp -rf dot-trK.ad          ../code/template/cadabra/.
	@ cp -rf ricci.ad            ../code/template/cadabra/.
	@ cp -rf ricci-scalar.ad     ../code/template/cadabra/.
	@ cp -rf hamiltonian.ad      ../code/template/cadabra/.
	@ cp -rf momentum.ad         ../code/template/cadabra/.
	@ touch .bssn-code
#-------------------------------------------------------------------------------
merge:
	@ echo "> merge ..."
	@ (cd ../code/template; merge.sh)
#-------------------------------------------------------------------------------
code:
	@ echo "> compile ..."
	@ (cd ../code; build.sh)
#-------------------------------------------------------------------------------
%:
	@ echo "> cdblatex.sh $@ ..."
	@ cdblatex.sh -T -s -i $@ &> $@.cdblog
	@ # echo " -->"`cputime -i $@.cdblog`
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
	@ rm -rf dot-gBar.c      dot-gBar.ad
	@ rm -rf dot-ABar.c      dot-ABar.ad
	@ rm -rf dot-N.c         dot-N.ad
	@ rm -rf dot-Gi.c        dot-Gi.ad
	@ rm -rf dot-phi.c       dot-phi.ad
	@ rm -rf dot-trK.c       dot-trK.ad
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
