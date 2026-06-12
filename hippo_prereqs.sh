#!/bin/bash

export PATH=/opt/hippo:$PATH
export PATH=/opt/moose/modules/thermal_hydraulics:$PATH
export MOOSE_LIBRARY_PATH=/opt/hippo/lib
unset FOAM_SIGFPE

set_nprocs(){
    # Set number of processes to be run ion
    if [[ $# -eq 1 ]]; then
        echo $1
    elif [[ -n $HIPPO_NPROCS ]]; then
        echo ${HIPPO_NPROCS}
    else
        echo 4
    fi
}