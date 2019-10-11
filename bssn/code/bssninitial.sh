#!/bin/bash

if [[ $1 = '-h' ]]; then

   bin/bssninitial -h
   exit
fi

gprbuild -p -P bssninitial.gpr || exit

bin/bssninitial $1 -n8x8x8 -d0.1:0.1:0.1 -Ddata | tee bssninitial.log
