# Heated plate CHT tutorial

This example is derived from the [flow over heated plate preCICE tutorial](https://precice.org/tutorials-flow-over-heated-plate). There are four examples
1. OpenFOAM only: 310K imposed directly on fluid-only interface
1. TFFB: case replicating the preCICE tutorial
1. FFTB: case showing how under these conditions, FFTB is unstable
1. FFTB with modified properties: A working example with FFTB

`post.py` and for the FFTB case, `post_error.py` will create videos and frames of the results.