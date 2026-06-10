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

cd fluid-openfoam && ./Allclean
cd ..
rm -f *.e *.mp4
blockMesh -case fluid-openfoam

sed -i "s/numberOfSubdomains.*/numberOfSubdomains $NPROCS;/g" fluid-openfoam/system/decomposeParDict

decomposePar -case fluid-openfoam

touch fluid-openfoam/viz.foam
echo "Partitioned with $NPROCS processors"
