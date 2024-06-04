#!/bin/bash

# defaults, edit to suit
# must match choices made in INSTALL.sh

if [[ $HERE = '' ]]; then
   HERE=$HOME/local/adm-bssn/
fi;

MyBin=$HERE/bin/
MyLib=$HERE/lib/
MyTex=$HERE/tex/

rm -rf $MyBin
rm -rf $MyLib
rm -rf $MyTex

# this is only neded if you are still in the shell where you ran INSTALL.sh
# note that INSTALL.sh is also run when using make
source OLDPATHS

echo "> --------------------------------"
echo "> Also check $HERE"
echo "> If that directory is empty, you can delete it with rm -rf $HERE"
echo "> To completely remove all traces of this repo, use rm -rf $PWD"
echo "> --------------------------------"
