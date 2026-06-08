#!/bin/bash

foamCleanCase 
blockMesh
sed -i 's/patch/wall/g' constant/polyMesh/boundary

decomposePar
mpirun -n 4 foamRun -parallel
