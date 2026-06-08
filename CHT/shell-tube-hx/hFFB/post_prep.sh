#!/bin/bash

set -e -v
reconstructPar -case fluid-inner-openfoam
reconstructPar -case fluid-outer-openfoam

