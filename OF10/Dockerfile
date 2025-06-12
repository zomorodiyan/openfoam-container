FROM quay.io/pawsey/mpich-base:3.4.3_ubuntu20.04

# Toggle LBF build ON or OFF
ARG INSTALL_LBF=true

# Core OpenFOAM env variables
ENV FOAM_INST_DIR=/opt/OpenFOAM \
    WM_PROJECT=OpenFOAM \
    WM_PROJECT_VERSION=10 \
    WM_INST_DIR=/opt/OpenFOAM \
    FOAMY_HEX_MESH=yes \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    FOAM_MPI=mpi

# Add OpenFOAM apt repo and update
RUN apt-get update && apt-get install -y \
    software-properties-common wget \
    && wget -O - https://dl.openfoam.org/gpg.key > /etc/apt/trusted.gpg.d/openfoam.asc \
    && add-apt-repository http://dl.openfoam.org/ubuntu \
    && apt-get update

# Install system dependencies
RUN apt-get install -y \
    openfoam-deps \
    paraview-dev \
    libfl-dev \
    libscotch-dev \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# CGAL support is required for building foamyMesh or conformal Voronoi features
RUN apt-get update && apt-get install -y libcgal-dev
RUN apt-get install -y libboost-all-dev libgmp-dev libmpfr-dev

# Clone OpenFOAM and ThirdParty
RUN mkdir -p $FOAM_INST_DIR && \
    cd $FOAM_INST_DIR && \
    git clone https://github.com/OpenFOAM/OpenFOAM-10.git && \
    git clone https://github.com/OpenFOAM/ThirdParty-10.git

# Configure OpenFOAM to use MPICH and system scotch
RUN echo "export WM_MPLIB=SYSTEMMPI" >> $FOAM_INST_DIR/OpenFOAM-10/etc/prefs.sh && \
    echo "export MPI_ROOT=/usr" >> $FOAM_INST_DIR/OpenFOAM-10/etc/prefs.sh && \
    echo "export MPI_ARCH_FLAGS='-DMPICH_SKIP_MPICXX'" >> $FOAM_INST_DIR/OpenFOAM-10/etc/prefs.sh && \
    echo "export MPI_ARCH_INC='-I/usr/include/mpich'" >> $FOAM_INST_DIR/OpenFOAM-10/etc/prefs.sh && \
    echo "export MPI_ARCH_LIBS='-L/usr/lib/x86_64-linux-gnu -lmpich -lrt'" >> $FOAM_INST_DIR/OpenFOAM-10/etc/prefs.sh && \
    echo "export SCOTCH_TYPE=system" >> $FOAM_INST_DIR/OpenFOAM-10/etc/prefs.sh


# Set bash as default shell
SHELL ["/bin/bash", "-c"]

# Build OpenFOAM from source
RUN source $FOAM_INST_DIR/OpenFOAM-10/etc/bashrc && \
    cd $FOAM_INST_DIR/OpenFOAM-10 && \
    ./Allwmake -j $(nproc) > /tmp/openfoam-build.log 2>&1 || \
    (echo "======= BUILD FAILED: Last 500 lines =======" && tail -n 500 /tmp/openfoam-build.log && false)

# Optional: Install laserbeamFoam if requested
#RUN if [ "$INSTALL_LBF" = "true" ]; then \
#      git clone https://github.com/micmog/LaserbeamFoam.git $FOAM_INST_DIR/OpenFOAM-10/applications/solvers/laserbeamFoam && \
#      source $FOAM_INST_DIR/OpenFOAM-10/etc/bashrc && \
#      cd $FOAM_INST_DIR/OpenFOAM-10/applications/solvers/laserbeamFoam && \
#      wmake; \
#    else echo "Skipping laserbeamFoam install."; fi

# Auto-load OpenFOAM for interactive shells
RUN echo "source $FOAM_INST_DIR/OpenFOAM-10/etc/bashrc" >> /etc/bash.bashrc

# Default working directory
WORKDIR /home/openfoam

# Add OpenFOAM entrypoint wrapper for consistent environment setup
# COPY openfoam-entrypoint.sh /usr/local/bin/openfoam-entrypoint.sh
# RUN chmod +x /usr/local/bin/openfoam-entrypoint.sh

# Set as default entrypoint for Singularity/Docker use
# ENTRYPOINT ["/usr/local/bin/openfoam-entrypoint.sh"]
