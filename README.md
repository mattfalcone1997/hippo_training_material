# Hippo training materials


## Pre-requisites

1. Install apptainer.
  - For Ubuntu/Debian
```bash
wget https://github.com/apptainer/apptainer/releases/download/v1.4.5/apptainer_1.4.5_amd64.deb
sudo apt install -y ./apptainer_1.4.5_amd64.deb
```
  - If you are using the RPM package manager, go to [Apptainer release](https://github.com/apptainer/apptainer/releases/tag/v1.4.5) and find the correct package.
  - On MacOS, you will need a virtual machine. [Apptainer recommends using Lima](https://apptainer.org/docs/admin/main/installation.html).
  - On Windows, you can use Window Subsystem for Linus (WSL2) and follow the same commands as above.


2. Pull Hippo release container
```bash
apptainer pull hippo.sif oras://quay.io/ukaea/hippo:v0.1.0-rc2
```

## Running the tutorials
For convenience, we recommend running the tutorials within the Apptainer shell
```bash
apptainer shell hippo.sif

```

We also suggest running the following commands when the shell starts.
```bash
export PATH=/opt/hippo:$PATH
export PATH=/opt/moose/modules/thermal_hydraulics:$PATH
export MOOSE_LIBRARY_PATH=/opt/hippo/lib
unset FOAM_SIGFPE
```
All the tutorials have a `prep.sh` that runs all the ancillary functions to prepare the cases such as `blockMesh` and `decomposePar`. By default, `prep.sh` uses 4 processes to partition the mesh. If you wish to use a different number by default you can set
```bash
export HIPPO_NPROCS=8
```

To run Hippo use
```bash
mpirun -n $HIPPO_NPROCS hippo-opt -i solid.i
```
and to run the `thermal_hydraulics` app
```bash
mpirun -n $HIPPO_NPROCS thermal_hydraulics-opt -i main.i
```

## Visualisation

The examples also have Python scripts which use Pyvista to visualise the results.
While `pyvista` should be installed in the container, we recommend using a virtual environment.
```bash
python -m venv .venv
```
To install the required modules, activate the environment and use `pip`
```bash
source .venv/bin/activate
python -m pip install -r requirements.txt
```



