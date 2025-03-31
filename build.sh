#!/bin/bash

(cd support;   echo "> compile support ..."; build.sh)
(cd adm/code;  echo "> compile adm ...";     build.sh)
(cd bssn/code; echo "> compile bssn ...";    build.sh)
