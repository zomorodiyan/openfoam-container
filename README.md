# Containerized Workflows for OpenFOAM-10 & LaserbeamFoam

This repository provides ready-to-use **Docker** and **Apptainer (Singularity)** recipes for:

* Building an **OpenFOAM-10** base image  
* Building a **laserbeamFoam (lbf)** image that layers on top of OpenFOAM-10  
* Running tutorial cases interactively or through **SLURM** on HPC systems (tested on **Sol**)

> **Prerequisites**  
> * Docker 20.10+ with **BuildKit** enabled  
> * Apptainer ≥1.2 (or SingularityCE ≥3.11) with `fakeroot` support  
> * A Slurm-enabled cluster (for sections 2.3 & 4.3)  

---

## 1.1 OpenFOAM-10 Docker image and push to Docker Hub
```bash
docker build -t zomorodiyan/openfoam10:mpich -f Dockerfile.of10 .
docker push zomorodiyan/openfoam10:mpich
```

## 1.2 Run an OpenFOAM tutorial in the Docker container
```bash
docker run -it --rm \
  -v /home/mzomoro1/code:/home/mzomoro1/code \
  zomorodiyan/openfoam10:mpich bash

cd case/pitzDaily/
blockMesh
decomposePar
OMPI_ALLOW_RUN_AS_ROOT=1 OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 \
  mpirun -np 2 foamExec simpleFoam
```

---

## 2.1 Generate an Apptainer *.sif* for OpenFOAM-10 (from the Docker image)
```bash
sudo singularity build openfoam10.sif Singularity.def
```

## 2.2 Run an OpenFOAM tutorial in the Apptainer container (local)
```bash
# Interactive shell
sudo singularity shell \
  --bind /home/mzomoro1/code:/home/mzomoro1/code \
  openfoam10_jun11.sif
```

## 2.3 Run an OpenFOAM tutorial via Slurm on **Sol** with the *.sif*
```bash
sbatch lbf_slurm.sh
```

---

## 3.1 laserbeamFoam Docker image (built FROM the OF10 image) and push
```bash
docker build -t zomorodiyan/openfoam10:mpich-lbf -f Dockerfile.lbf .
docker push zomorodiyan/openfoam10:mpich-lbf
```

## 3.2 Run a laserbeamFoam tutorial in the Docker container
```bash
docker run -it --rm \
  -v /home/mzomoro1/code:/home/mzomoro1/code \
  zomorodiyan/openfoam10:mpich-lbf bash

cd case/pitzDaily/
blockMesh
decomposePar
OMPI_ALLOW_RUN_AS_ROOT=1 OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1   mpirun -np 4 foamExec laserbeamFoam
```

---

## 4.1 Generate an Apptainer *.sif* for laserbeamFoam (from the lbf image)
```bash
sudo singularity build openfoam10-lbf.sif Singularity.def
```

## 4.2 Test *openfoam10-lbf.sif* locally (interactive shell)
```bash
sudo singularity shell \
  --bind /home/mzomoro1/code:/home/mzomoro1/code \
  openfoam10-lbf.sif
```

## 4.3 Run a laserbeamFoam tutorial via Slurm on **Sol** with the *.sif*
```bash
sbatch lbf_slurm.sh
```
