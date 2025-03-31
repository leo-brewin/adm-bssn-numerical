#!/bin/bash

PROGRAM=$(basename $0 ".sh")

CDB2ADA=$PWD/../../utilities/bin/cdb2ada

HERE=$PWD
DEST=$PWD/../code/templates/code-ada/
CSRC=$PWD/code-c/
TEMPLATES=$PWD/templates/
TMP=$PWD/tmp/

mkdir -p $DEST
mkdir -p $TMP

# must use gsed
# sed scripts reformat.pre and reformat.post
# use syntax not supported by BSD sed

SED=/opt/homebrew/bin/gsed

function process {

   file=$1

   cd $CSRC

   if [[ -e ${file}.c ]]; then

      the_file=${file/.c/}

      rm -rf $TMP/A.ad $TMP/B.ad $TMP/C.ad $TMP/D.ad $TMP/E.ad
      cp ${the_file}.c $TMP/A.ad
      ${SED} -r -f $HERE/reformat.pre $TMP/A.ad > $TMP/B.ad
      ${CDB2ADA} -i$TMP/B.ad -v$TMP/C.ad -b$TMP/D.ad
      merge-src -i $TEMPLATES/${the_file}.ad -o $TMP/E.ad -S
      ${SED} -i "1i -- written by $HERE/$PROGRAM.sh" $TMP/E.ad
      ${SED} -i "2i -- using $TEMPLATES/${the_file}.ad" $TMP/E.ad
      ${SED} -r -f $HERE/reformat.post $TMP/E.ad > $DEST/${the_file}.ad
      rm -rf $TMP/A.ad $TMP/B.ad $TMP/C.ad $TMP/D.ad $TMP/E.ad

   else

      echo "> c-source "${file}.c" not found"

   fi

   cd $HERE

}

process dot-Kab
process dot-N
process dot-gab
process hamiltonian
process hessian
process momentum
process ricci-scalar
process ricci

rm -rf $TMP
