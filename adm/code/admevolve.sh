#!/bin/bash

if [[ $1 = '-h' ]]; then

   bin/admevolve -h
   exit

fi

(cd template; merge.sh > make.log) # only required if changes made to template sources

gprbuild -p -P admevolve.gpr || exit

rm -rf results

bin/admevolve $1 -C0.25 -t11.0 -p10 -P11.0 -M40000 -N8 -Oresults -Ddata | tee admevolve.log
