#!/bin/bash

if [[ $1 = '--Help' ]]; then

   bin/bssnevolve --Help
   exit

fi

(cd templates; merge.sh > make.log) # only required if changes made to the template sources

build.sh bssnevolve || exit

rm -rf results
mkdir -p results
touch results/history.txt

bin/bssnevolve $* \
   --Courant 0.25 \
   --Tfinal 11.0 \
   --PrintCycle 10 \
   --PrintTimeStep 11.0 \
   --MaxTimeSteps 40000 \
   --NumTasks 8 \
   --OutputDir results \
   --UseRendezvous \
   --DataDir data | tee bssnevolve.log

# bin/bssnevolve $* \
#    --Courant 0.25 \
#    --Tfinal 11.0 \
#    --PrintCycle 10 \
#    --PrintTimeStep 11.0 \
#    --MaxTimeSteps 40000 \
#    --NumTasks 8 \
#    --OutputDir results \
#    --UseProtObject \
#    --DataDir data | tee bssnevolve.log

# bin/bssnevolve $* \
#    --Courant 0.25 \
#    --Tfinal 11.0 \
#    --PrintCycle 10 \
#    --PrintTimeStep 11.0 \
#    --MaxTimeSteps 40000 \
#    --NumTasks 8 \
#    --OutputDir results \
#    --UseTransientTasks \
#    --DataDir data | tee bssnevolve.log

# bin/bssnevolve $* \
#    --Courant 0.25 \
#    --Tfinal 11.0 \
#    --PrintCycle 10 \
#    --PrintTimeStep 11.0 \
#    --MaxTimeSteps 40000 \
#    --NumTasks 8 \
#    --OutputDir results \
#    --UseSyncBarriers \
#    --DataDir data | tee bssnevolve.log
