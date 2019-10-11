#!/bin/bash

rm -rf ./adm/code/bin   ./adm/code/obj
rm -rf ./bssn/code/bin  ./bssn/code/obj
rm -rf ./support/obj

(cd adm;  build.sh)
(cd bssn; build.sh)
