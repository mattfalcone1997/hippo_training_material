#!/bin/bash
set -e -v

NPROCS=8

foamCleanCase -case foam_cfd
blockMesh -case foam_cfd
sed -i 's/patch/wall/g' foam_cfd/constant/polyMesh/boundary
sed -i "s/numberOfSubdomains.*/numberOfSubdomains $NPROCS;/g" foam_cfd/system/decomposeParDict

decomposePar -case foam_cfd
mpirun -n $NPROCS ~/SOFTWARE/moose/modules/thermal_hydraulics/thermal_hydraulics-opt -i main.i
