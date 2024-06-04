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

bin/bssnevolve $1 -C0.25 -t11.0 -p10 -P11.0 -M40000 -N8 | tee bssnevolve.log
