#!/bin/bash
set -e

if [ ! -f ../../../hippo_prereqs.sh ]; then
    echo "This script requires ../../../hippo_prereqs.sh"
    exit 1
fi
source ../../../hippo_prereqs.sh
NPROCS=$(set_nprocs $@)

set -v

foamCleanCase -case foam_cfd
blockMesh -case foam_cfd
sed -i 's/patch/wall/g' foam_cfd/constant/polyMesh/boundary
sed -i "s/numberOfSubdomains.*/numberOfSubdomains $NPROCS;/g" foam_cfd/system/decomposeParDict

decomposePar -case foam_cfd

touch foam_cfd/viz.foam

echo "Partitioned with $NPROCS processors"