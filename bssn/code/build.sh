#!/bin/bash

(cd templates; merge.sh)

source ../../alire.ini

gprbuild -p -P build.gpr $*
