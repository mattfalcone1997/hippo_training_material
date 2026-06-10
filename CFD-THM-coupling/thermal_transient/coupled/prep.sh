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
    echo "Number of processes default
fi

set -v

foamCleanCase -case foam_cfd
blockMesh -case foam_cfd
sed -i 's/patch/wall/g' foam_cfd/constant/polyMesh/boundary
sed -i "s/numberOfSubdomains.*/numberOfSubdomains $NPROCS;/g" foam_cfd/system/decomposeParDict

decomposePar -case foam_cfd

touch foam_cfd/viz.foam

echo "Partitioned with $NPROCS processors"