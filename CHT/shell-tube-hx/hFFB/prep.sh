#!/bin/bash

set -e

foamCleanCase -case fluid-inner-openfoam
foamCleanCase -case fluid-outer-openfoam

rm -rf solid_out*

./download_meshes.sh

decomposePar -case fluid-inner-openfoam
decomposePar -case fluid-outer-openfoam

touch fluid-inner-openfoam/viz.foam
touch fluid-outer-openfoam/viz.foam
