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

      dot-Kab)       cat dot-Kab.c        > tmp.c;;
      dot-N)         cat dot-N.c          > tmp.c;;
      dot-gab)       cat dot-gab.c        > tmp.c;;
      hamiltonian)   cat hamiltonian.c    > tmp.c;;
      hessian)       cat hessian.c        > tmp.c;;
      momentum)      cat momentum.c       > tmp.c;;
      ricci-scalar)  cat ricci-scalar.c   > tmp.c;;
      ricci)         cat ricci.c          > tmp.c;;

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

   process dot-Kab       set_3d_dot_Kab
   process dot-N         set_3d_dot_N
   process dot-gab       set_3d_dot_gab
   process hamiltonian   set_hamiltonian
   process hessian       set_3d_hessian
   process momentum      set_momentum
   process ricci-scalar  set_3d_ricci_scalar
   process ricci         set_3d_ricci

else

   process $1 $2

fi
