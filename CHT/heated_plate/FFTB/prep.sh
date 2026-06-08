#!/bin/bash

set -e -v

NPROCS=8
foamCleanCase -case fluid-openfoam
rm -f *.e *.mp4
blockMesh -case fluid-openfoam

sed -i "s/numberOfSubdomains.*/numberOfSubdomains $NPROCS;/g" fluid-openfoam/system/decomposeParDict

decomposePar -case fluid-openfoam
touch fluid-openfoam/viz.foam
