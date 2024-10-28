#!/bin/bash

if [[ $1 = '-h' ]]; then

   bin/bssnevolve -h
   exit

fi

(cd template; merge.sh > make.log) # only required if changes made to template sources

gprbuild -p -P bssnevolve.gpr || exit

rm -rf results
mkdir -p results
touch results/history.txt

bin/bssnevolve $* \
   --Courant 0.25 \
   --Tfinal 11.0 \
   --PrintCycle 10 \
   --PrintTimeStep 11.0 \
   --MaxTimeSteps 40000 \
   --NumCores 8 \
   --OutputDir results \
   --DataDir data | tee bssnevolve.log
