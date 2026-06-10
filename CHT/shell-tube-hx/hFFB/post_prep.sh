#!/bin/bash

set -e -v
reconstructPar -case fluid-inner-openfoam -latestTime
reconstructPar -case fluid-outer-openfoam -latestTime

