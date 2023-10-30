ARG BASE_TAG=staging
FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu18.04 AS nvidia
FROM gcr.io/kaggle-images/rstats:${BASE_TAG}
ARG ncpus=1

ADD clean-layer.sh  /tmp/clean-layer.sh

# Cuda support
COPY --from=nvidia /etc/apt/sources.list.d/cuda.list /etc/apt/sources.list.d/
COPY --from=nvidia /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d/cuda.gpg

ENV CUDA_MAJOR_VERSION=11
ENV CUDA_MINOR_VERSION=7
ENV CUDA_PATCH_VERSION=0
ENV CUDA_VERSION=$CUDA_MAJOR_VERSION.$CUDA_MINOR_VERSION.$CUDA_PATCH_VERSION
ENV CUDA_PKG_VERSION=$CUDA_MAJOR_VERSION-$CUDA_MINOR_VERSION
ENV CUDNN_VERSION=8.5.0.96
ENV NCCL_VERSION=2.13.4-1
LABEL com.nvidia.volumes.needed="nvidia_driver"
LABEL com.nvidia.cuda.version="${CUDA_VERSION}"
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"
ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
# The stub is useful to us both for built-time linking and run-time linking, on CPU-only systems.
# When intended to be used with actual GPUs, make sure to (besides providing access to the host
# CUDA user libraries, either manually or through the use of nvidia-docker) exclude them. One
# convenient way to do so is to obscure its contents by a bind mount:
#   docker run .... -v /non-existing-directory:/usr/local/cuda/lib64/stubs:ro ...
ENV LD_LIBRARY_PATH="/usr/local/nvidia/lib64:/usr/local/cuda/lib64:/usr/local/cuda/lib64/stubs"
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_REQUIRE_CUDA="cuda>=$CUDA_MAJOR_VERSION.$CUDA_MINOR_VERSION"
RUN apt-get update && apt-get install -y --no-install-recommends \
      cuda-cupti-$CUDA_PKG_VERSION \
      cuda-cudart-$CUDA_PKG_VERSION \
      cuda-cudart-dev-$CUDA_PKG_VERSION \
      cuda-libraries-$CUDA_PKG_VERSION \
      cuda-libraries-dev-$CUDA_PKG_VERSION \
      cuda-nvml-dev-$CUDA_PKG_VERSION \
      cuda-minimal-build-$CUDA_PKG_VERSION \
      cuda-command-line-tools-$CUDA_PKG_VERSION \
      libcudnn8=$CUDNN_VERSION-1+cuda$CUDA_MAJOR_VERSION.$CUDA_MINOR_VERSION \
      libcudnn8-dev=$CUDNN_VERSION-1+cuda$CUDA_MAJOR_VERSION.$CUDA_MINOR_VERSION \
      libcublas-$CUDA_PKG_VERSION \
      libcublas-dev-$CUDA_PKG_VERSION \
      libnccl2=$NCCL_VERSION+cuda$CUDA_MAJOR_VERSION.$CUDA_MINOR_VERSION \
      libnccl-dev=$NCCL_VERSION+cuda$CUDA_MAJOR_VERSION.$CUDA_MINOR_VERSION && \
    /tmp/clean-layer.sh

ENV CUDA_HOME=/usr/local/cuda

# Hack to fix R trying to use CUDA in `/usr/lib/x86_64-linux-gnu` directory instead
# of `/usr/local/nvidia/lib64` (b/152401083).
# For some reason, the CUDA file `libcuda.so.418.67` in the former directory is empty.
# R's ldpaths modifies LD_LIBRARY_PATH on start by adding `/usr/lib/x86_64-linux-gnu` upfront.
# Instead, this version of ldpaths adds it at the end.
ADD ldpaths $R_HOME/etc/ldpaths

# Install tensorflow with GPU support
RUN R -e 'keras::install_keras(tensorflow = "gpu", method="conda", envname="r-reticulate")' && \
    rm -rf /tmp/tensorflow_gpu && \
    /tmp/clean-layer.sh

# OpenCL for bayesCL, gpuR, ...
RUN apt-get install -y --no-install-recommends ocl-icd-opencl-dev && \
    mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

# Install GPU specific packages
RUN CPATH=/usr/local/cuda/targets/x86_64-linux/include install2.r --error --ncpus $ncpus --repo http://cran.rstudio.com \
    h2o4gpu

# Torch: install the full package upfront otherwise it will be installed on loading the package which doesn't work for kernels
# without internet (competitions for example). It will detect CUDA and install the proper version.
# Make Torch think we use CUDA 11.8 (https://github.com/mlverse/torch/issues/807)
ENV CUDA=11.7
RUN R -e 'install.packages("torch")'
RUN R -e 'library(torch); install_torch()'

CMD ["R"]
