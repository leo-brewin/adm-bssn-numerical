#!/bin/bash

# defaults, edit to suit

# these must be visible on the respective paths

MyBin=$HOME/local/adm-bssn/bin/
MyLib=$HOME/local/adm-bssn/lib/
MyTex=$HOME/local/adm-bssn/tex/

# Parse the command-line options

while getopts 'b:l:t:h' option
do
   case "$option" in
   "b")  MyBin="$OPTARG"      ;;
   "l")  MyLib="$OPTARG"      ;;
   "t")  MyTex="$OPTARG"      ;;
   "h")  echo "usage : INSTALL.sh [-bBIN] [-lLIB] [-tTEX]"
         echo "options : -b : where to find the binaries and shell scripts"
         echo "          -l : where to find the python libraries"
         echo "          -t : where to find the LaTeX files "
         echo "          -h : this help message"
         exit                 ;;
   ?)    echo "INSTALL.sh: Unknown option specified."
         exit                 ;;
   esac
done

mkdir -p $MyBin $MyLib $MyTex

rm -rf utilities/bin utilities/obj

(cd utilities; build.sh; cp bin/* $MyBin)

(cd hybrid-latex; INSTALL.sh -b $MyBin -l $MyLib -t $MyTex)

# testing, each should return a brief help message

# ada-merge -h
# cdb2ada -h
# cdblatex.sh -h
# cdbpreproc.py -h
# cdbpostproc.py -h
