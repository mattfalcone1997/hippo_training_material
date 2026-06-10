#!/bin/bash
set -e

# Set number of processes to be run ion
if [[ $# -eq 2 ]]; then
    NPROCS=$1
    echo "Number of processes set through command line
elif [[ -n $HIPPO_NPROCS ]]; then
    NPROCS=${HIPPO_NPROCS}
    echo "Number of processes set through environment variable
else
    NPROCS=4
    echo "Number of processes default"
fi

set -v

foamCleanCase -case fluid-inner-openfoam
foamCleanCase -case fluid-outer-openfoam

rm -rf solid_out*

./download_meshes.sh

decomposePar -case fluid-inner-openfoam
decomposePar -case fluid-outer-openfoam

touch fluid-inner-openfoam/viz.foam
touch fluid-outer-openfoam/viz.foam

echo "Partitioned with $NPROCS processors"