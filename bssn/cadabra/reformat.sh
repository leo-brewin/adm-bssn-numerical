#!/bin/bash

file=$1
name=$2

SED=/usr/local/bin/sed             # need a sed that understands extended regular expressions

the_file=`basename -s.c ${file}`   # the C source (without the file extension)

rm -rf tmpA.del tmpB.del tmpC.del

cp ${the_file}.c tmpA.del

${SED} -r -f reformat.pre tmpA.del > tmpB.del

cdb2ada -itmpB.del -otmpC.del -sx -n${name}

${SED} -r -f reformat.post tmpC.del > ${the_file}.ad

rm -rf tmpA.del tmpB.del tmpC.del
