#!/bin/bash

if [[ $1 = '--Help' ]]; then

   bin/bssninitial --Help
   exit

fi

gprbuild -p -P bssninitial.gpr || exit

rm -rf data
mkdir -p data

bin/bssninitial $* \
   --GridNum 8x8x8 \
   --GridDelta 0.1:0.1:0.1 \
   --DataDir data | tee bssninitial.log
