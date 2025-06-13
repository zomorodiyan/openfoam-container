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

