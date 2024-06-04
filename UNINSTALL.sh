#!/bin/bash

# defaults, edit to suit

WHERE=$1

if [[ $WHERE = '' ]]; then
   WHERE=$HOME/local/adm-bssn/
fi;

MyBin=$WHERE/bin/
MyLib=$WHERE/lib/
MyTex=$WHERE/tex/

rm -rf $MyBin
rm -rf $MyLib
rm -rf $MyTex

echo "> --------------------------------"
echo "> Also check $WHERE"
echo "> If that directory is empty, you can delete it with rm -rf $WHERE"
echo "> To completely remove all traces of this repo, use rm -rf $PWD"
echo "> --------------------------------"
