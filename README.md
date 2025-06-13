# To run openfoam.sif interactively:
sudo singularity shell --bind /home/mzomoro1/code:/home/mzomoro1/code
OF10/openfoam10_jun11.sif

# To run pitzDaily case using openfoam.sif: 
#sudo apptainer exec --bind /home/mzomoro1/code:/home/mzomoro1/code openfoam.sif bash -c "source /opt/OpenFOAM/OpenFOAM-v2212/etc/bashrc && cd /home/mzomoro1/code/openfoam-container/case/pitzDaily && blockMesh && decomposePar && mpirun -np 2 simpleFoam -parallel"

sudo singularity exec --bind /home/mzomoro1/code:/home/mzomoro1/code OF10/openfoam10_jun11.sif bash
        cd case/pitzDaily/
        blockMesh
        decomposePar
        OMPI_ALLOW_RUN_AS_ROOT=1 OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 mpirun -np 2 foamExec simpleFoam


# Docker and Apptainer image generation and containers execution
docker build -t zomorodiyan/openfoam10:mpich-jun11 .
docker push zomorodiyan/openfoam10:mpich-jun11
sudo singularity build openfoam10_jun11.sif Singularity.def
sudo singularity exec --bind /home/mzomoro1/code:/home/mzomoro1/code OF10/openfoam10_jun11.sif bash

docker build -t zomorodiyan/openfoam10:mpich-lbf-jun12 -f Dockerfile.lbf .
docker run -it zomorodiyan/openfoam10:mpich-lbf bash
docker push zomorodiyan/openfoam10:mpich-lbf-jun12
sudo singularity build openfoam10-lbf-jun12.sif Singularity.def
