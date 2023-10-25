FROM nvidia/cuda:11.7.1-devel-ubuntu22.04
# https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/11.7.1/ubuntu2204/devel/Dockerfile

# Install necessary packages
RUN apt-get update && apt-get install -y \
    git \
   	python3 \
    python3-pip \
    libboost-program-options-dev \
    libglew-dev \
    libmetis-dev \
   	libboost-filesystem-dev \
   	libceres-dev \
   	libfreeimage-dev \
    libqt5opengl5-dev \
    ffmpeg \
    p7zip-full \
   && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/graphdeco-inria/gaussian-splatting --recursive

# build and install required pip packages
#RUN pip install torch==1.10.2
RUN pip install -q plyfile tqdm \
     https://huggingface.co/camenduru/gaussian-splatting/resolve/main/diff_gaussian_rasterization-0.0.0-cp310-cp310-linux_x86_64.whl \
     https://huggingface.co/camenduru/gaussian-splatting/resolve/main/simple_knn-0.0.0-cp310-cp310-linux_x86_64.whl
#        /gaussian-splatting/submodules/diff-gaussian-rasterization \
#        /gaussian-splatting/submodules/simple-knn



#copy compiled colmap from root dir to /usr/bin
COPY ./colmap /usr/local/bin
# Copy the script to the container
COPY entrypoint.sh \
     colmap.sh \
     gaussian.sh \
     full.sh \
     ./

RUN chmod +x colmap.sh entrypoint.sh gaussian.sh full.sh
# copy colmap to bin
COPY ./colmap /usr/local/bin
# Create a workspace directory and clone the repository
WORKDIR /workspace

# Entrypoint entrypoint.sh
    #"Entrypoint": [ "/opt/nvidia/nvidia_entrypoint.sh"],


ENTRYPOINT ["/opt/nvidia/nvidia_entrypoint.sh", "../entrypoint.sh"]

