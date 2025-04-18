#!/bin/bash

if [[ $1 = '--Help' ]]; then

   bin/adminitial --Help
   exit

fi

build.sh adminitial || exit

rm -rf data
mkdir -p data

bin/adminitial $* \
   --GridNum 8x8x8 \
   --GridDelta 0.1:0.1:0.1 \
   --DataDir data | tee adminitial.log
