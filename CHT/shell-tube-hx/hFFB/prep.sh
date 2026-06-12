#!/bin/bash
set -e

if [ ! -f ../../../hippo_prereqs.sh ]; then
    echo "This script requires ../../../hippo_prereqs.sh"
    exit 1
fi

source ../../../hippo_prereqs.sh
NPROCS=$(set_nprocs $@)

set -v

foamCleanCase -case fluid-inner-openfoam
foamCleanCase -case fluid-outer-openfoam

rm -rf solid_out*

./download_meshes.sh

sed -i "s/numberOfSubdomains.*/numberOfSubdomains $NPROCS;/g" fluid-inner-openfoam/system/decomposeParDict
sed -i "s/numberOfSubdomains.*/numberOfSubdomains $NPROCS;/g" fluid-outer-openfoam/system/decomposeParDict


decomposePar -case fluid-inner-openfoam
decomposePar -case fluid-outer-openfoam

touch fluid-inner-openfoam/viz.foam
touch fluid-outer-openfoam/viz.foam

echo "Partitioned with $NPROCS processors"