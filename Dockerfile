FROM nvidia/cuda:11.7.1-devel-ubuntu22.04

RUN apt update -y
RUN apt install -y git cmake libomp-dev libopenmpi-dev ffmpeg voro++-dev

RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1

WORKDIR /home/lammps

RUN git clone -b release https://github.com/lammps/lammps.git lammps_repo
RUN mkdir lammps_repo/build

RUN export LD_LIBRARY_PATH=/usr/local/cuda/lib64/stubs:$LD_LIBRARY_PATH && \
  cd lammps_repo/build && \
  cmake ../cmake && \
  cmake -D BUILD_SHARED_LIBS=yes -D PKG_MANYBODY=yes -D PKG_VORONOI=yes \
    -D PKG_GPU=yes -D GPU_API=cuda -D GPU_ARCH=sm_80 . && \
  make -j$(nproc) && \
  make install

RUN echo 'export PATH="$PATH:$HOME"/.local/bin' >> "$HOME"/.bashrc
RUN echo 'export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME"/.local/lib' >> "$HOME"/.bashrc
RUN echo 'export LAMMPS_POTENTIALS="$HOME"/.local/share/lammps/potentials' >> "$HOME"/.bashrc

WORKDIR /data