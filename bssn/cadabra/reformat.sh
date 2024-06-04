#!/bin/bash

HERE=$PWD
DEST=$PWD/code-ada/
CSRC=$PWD/code-c/

SED=/opt/homebrew/bin/gsed

function process {

   # echo "> "$1

   file=$1
   name=$2

   cd $CSRC

   rm -rf tmp.c

   case $file in

   	dot-gBar)       cat dot-gBar.c        > tmp.c;;
   	dot-ABar)       cat dot-ABar.c        > tmp.c;;
   	dot-N)          cat dot-N.c           > tmp.c;;
   	dot-Gi)         cat dot-Gi.c          > tmp.c;;
   	dot-phi)        cat dot-phi.c         > tmp.c;;
   	dot-trK)        cat dot-trK.c         > tmp.c;;
   	ricci)          cat ricci.c           > tmp.c;;
   	ricci-scalar)   cat ricci-scalar.c    > tmp.c;;
   	hamiltonian)    cat hamiltonian.c     > tmp.c;;
   	momentum)       cat momentum.c        > tmp.c;;

      *) echo "Huh? I'm confused in reformat.sh, choice: $file"; exit 1 ;;

   esac

   rm -rf tmpA.del tmpB.del tmpC.del
   cp tmp.c tmpA.del
   ${SED} -r -f $HERE/reformat.pre tmpA.del > tmpB.del
   cdb2ada -itmpB.del -otmpC.del -P${name} -vx
   ${SED} -r -f $HERE/reformat.post tmpC.del > $DEST/${file}.ad
   rm -rf tmpA.del tmpB.del tmpC.del

   rm -rf tmp.c

   cd $HERE

}

mkdir -p $DEST

if [[ $1 = '' ]]; then

	process dot-gBar        set_3d_dot_gBar
	process dot-ABar        set_3d_dot_ABar
	process dot-N           set_3d_dot_N
	process dot-Gi          set_3d_dot_Gi
	process dot-phi         set_3d_dot_phi
	process dot-trK         set_3d_dot_trK
	process ricci           set_3d_ricci
	process ricci-scalar    set_3d_ricci_scalar
	process hamiltonian     set_hamiltonian
	process momentum        set_momentum

else

   process $1 $2

fi
