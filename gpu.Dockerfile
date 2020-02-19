FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu16.04 AS nvidia
FROM gcr.io/kaggle-images/rstats:staging
ARG ncpus=1

ADD clean-layer.sh  /tmp/clean-layer.sh

# Cuda support
COPY --from=nvidia /etc/apt/sources.list.d/cuda.list /etc/apt/sources.list.d/
COPY --from=nvidia /etc/apt/sources.list.d/nvidia-ml.list /etc/apt/sources.list.d/
COPY --from=nvidia /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d/cuda.gpg

# Ensure the cuda libraries are compatible with the custom Tensorflow wheels.
# TODO(b/120050292): Use templating to keep in sync or COPY installed binaries from it.
ENV CUDA_VERSION=10.0.130
ENV CUDA_PKG_VERSION=10-0=$CUDA_VERSION-1
ENV CUDNN_VERSION=7.4.2.24
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
ENV NVIDIA_REQUIRE_CUDA="cuda>=10.0"
RUN apt-get update && apt-get install -y --no-install-recommends \
      cuda-cudart-$CUDA_PKG_VERSION \
      cuda-cudart-dev-$CUDA_PKG_VERSION \
      cuda-libraries-$CUDA_PKG_VERSION \
      cuda-libraries-dev-$CUDA_PKG_VERSION \
      cuda-nvml-dev-$CUDA_PKG_VERSION \
      cuda-minimal-build-$CUDA_PKG_VERSION \
      cuda-command-line-tools-$CUDA_PKG_VERSION \
      libcudnn7=$CUDNN_VERSION-1+cuda10.0 \
      libcudnn7-dev=$CUDNN_VERSION-1+cuda10.0 && \
    ln -s /usr/local/cuda-10.0 /usr/local/cuda && \
    ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 && \
    /tmp/clean-layer.sh

ENV CUDA_HOME=/usr/local/cuda

# Install tensorflow with GPU support
RUN R -e 'keras::install_keras(tensorflow = "1.15-gpu")' && \
    rm -rf /tmp/tensorflow_gpu && \
    /tmp/clean-layer.sh

# OpenCL for bayesCL, gpuR, ...
RUN apt-get install -y --no-install-recommends ocl-icd-opencl-dev && \
    mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

# Install GPU specific packages
RUN CPATH=/usr/local/cuda/targets/x86_64-linux/include install2.r --error --ncpus $ncpus --repo http://cran.rstudio.com \
    h2o4gpu \
    bayesCL \
    kmcudaR

RUN R -e 'install.packages("gpuR", INSTALL_opts=c("--no-test-load"))'
