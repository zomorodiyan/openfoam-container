#!/bin/bash
#SBATCH -p general             # Partition (queue)
#SBATCH -q public              # QoS
#SBATCH -N 1                   # Number of nodes
#SBATCH -n 2                   # Total MPI tasks
#SBATCH -c 1                   # Cores per task
#SBATCH -t 0-00:01:00          # Time in D-HH:MM:SS (1 min for test)
#SBATCH --job-name=openfoam-test
#SBATCH --output=job_output.log
#SBATCH --error=job_error.log

# Load Apptainer (if your cluster uses modules)
#module load apptainer

# Define variables
CASE_DIR=/home/mzomoro1/openfoam-container/case/pitzDaily
SIF_PATH=/home/mzomoro1/openfoam-container/openfoam.sif

# Step 1: blockMesh
apptainer exec $SIF_PATH bash -c "source /opt/OpenFOAM/OpenFOAM-v2212/etc/bashrc && cd $CASE_DIR && blockMesh"

# Step 2: decomposePar
apptainer exec $SIF_PATH bash -c "source /opt/OpenFOAM/OpenFOAM-v2212/etc/bashrc && cd $CASE_DIR && decomposePar"

# Step 3: Run solver (example: icoFoam)
srun --mpi=pmi2 apptainer exec $SIF_PATH bash -c "source /opt/OpenFOAM/OpenFOAM-v2212/etc/bashrc && cd $CASE_DIR && simpleFoam -parallel"

# Step 4: Reconstruct (optional)
apptainer exec $SIF_PATH bash -c "source /opt/OpenFOAM/OpenFOAM-v2212/etc/bashrc && cd $CASE_DIR && reconstructPar"

