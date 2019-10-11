#!/bin/bash

(cd template; merge.sh)

gprbuild -p -P build.gpr
