#!/bin/bash

if [[ $1 = '-h' ]]; then

   bin/adminitial -h
   exit

fi

gprbuild -p -P adminitial.gpr || exit

rm -rf data

bin/adminitial $1 -n8x8x8 -d0.1:0.1:0.1 -Ddata | tee adminitial.log
