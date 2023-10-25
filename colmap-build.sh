#!/usr/bin/env bash
# run it into docker image
# docker run -it --gpus all -v /home/stanislav/work/colmap_dir:/workspace nvidia/cuda:11.7.1-devel-ubuntu22.04 bash
# docs: https://colmap.github.io/install.html#linux
apt-get update && apt-get install -y\
    git \
    cmake \
    ninja-build \
    build-essential \
    libboost-program-options-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-system-dev \
    libeigen3-dev \
    libflann-dev \
    libfreeimage-dev \
    libmetis-dev \
    libgoogle-glog-dev \
    libgtest-dev \
    libsqlite3-dev \
    libglew-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
    libcgal-dev \
    libceres-dev \
    nvidia-cuda-toolkit \
    nvidia-cuda-toolkit-gcc \
    gcc-10 g++-10

mkdir -p /home
cd /home/ || exit

export CC=/usr/bin/gcc-10
export CXX=/usr/bin/g++-10
export CUDAHOSTCXX=/usr/bin/g++-10
# ... and then run CMake against COLMAP's sources.     

git clone https://github.com/colmap/colmap.git
cd colmap || exit
mkdir build
cd build || exit
cmake .. -GNinja -DCMAKE_CUDA_ARCHITECTURES=75 #ALL
ninja
ninja install
echo "------ninja install done!------"
cp /usr/local/bin/colmap /workspace/
echo "------colmap is done and copied to result/!------"
