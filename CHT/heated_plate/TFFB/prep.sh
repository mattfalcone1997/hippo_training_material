#!/bin/bash

set -e -v

NPROCS=4
foamCleanCase -case fluid-openfoam
rm -f *.e *.mp4
blockMesh -case fluid-openfoam

sed -i 's/numberOfSubdomains.*/numberOfSubdomains 4;/g' fluid-openfoam/system/decomposeParDict

decomposePar -case fluid-openfoam

