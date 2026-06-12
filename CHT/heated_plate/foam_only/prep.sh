#!/bin/bash

set -e

if [ ! -f ../../../hippo_prereqs.sh ]; then
    echo "This script requires ../../../hippo_prereqs.sh"
    exit 1
fi
source ../../../hippo_prereqs.sh
NPROCS=$(set_nprocs $@)

set -v

cd fluid-openfoam && ./Allclean
cd ..
rm -f *.e *.mp4
blockMesh -case fluid-openfoam

sed -i "s/numberOfSubdomains.*/numberOfSubdomains $NPROCS;/g" fluid-openfoam/system/decomposeParDict

decomposePar -case fluid-openfoam

touch fluid-openfoam/viz.foam
echo "Partitioned with $NPROCS processors"
