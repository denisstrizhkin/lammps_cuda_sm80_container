FROM nvidia/cuda:11.7.1-devel-ubuntu22.04

WORKDIR /home/lammps

RUN apt update -y
RUN apt install -y git 

RUN git clone -b release https://github.com/lammps/lammps.git lammps_repo
RUN mkdir lammps_repo/build

RUN apt install -y cmake libomp-dev libopenmpi-dev ffmpeg voro++-dev python3-dev python3-pip

RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1

RUN export LD_LIBRARY_PATH=/usr/local/cuda/lib64/stubs:$LD_LIBRARY_PATH && \
  cd lammps_repo/build && \
  cmake ../cmake && \
  cmake -D BUILD_MPI=yes -D PKG_OPENMP=yes -D PKG_BODY=yes \
    -D PKG_MANYBODY=yes -D BUILD_SHARED_LIBS=yes -D PKG_VORONOI=yes \
    -D PKG_EXTRA-FIX=yes -D PKG_EXTRA-COMPUTE=yes -D LAMMPS_EXCEPTIONS=yes \
    -D PKG_PYTHON=yes -D PKG_GPU=yes -D GPU_API=cuda -D GPU_ARCH=sm_80 . && \
  make -j$(nproc) && \
  make install

RUN echo 'export PATH="$PATH:$HOME"/.local/bin' >> "$HOME"/.bashrc
RUN echo 'export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME"/.local/lib' >> "$HOME"/.bashrc
RUN echo 'export LAMMPS_POTENTIALS="$HOME"/.local/share/lammps/potentials' >> "$HOME"/.bashrc

WORKDIR /data