ARG BASE_TAG=latest

FROM gcr.io/kaggle-images/rcran:${BASE_TAG}

ADD clean-layer.sh  /tmp/clean-layer.sh

# Default to python3.7
RUN apt-get update && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1 && \
    update-alternatives --config python && \
    apt install -y python3-pip python3-venv && \
    /tmp/clean-layer.sh

RUN apt-get update && \
    apt-get install apt-transport-https && \
    apt-get install -y -f r-cran-rgtk2 && \
    apt-get install -y -f libv8-dev libgeos-dev libgdal-dev libproj-dev libsndfile1-dev \
    libtiff5-dev fftw3 fftw3-dev libfftw3-dev libjpeg-dev libhdf4-0-alt libhdf4-alt-dev \
    libhdf5-dev libx11-dev cmake libglu1-mesa-dev libgtk2.0-dev librsvg2-dev libxt-dev \
    patch libgit2-dev && \
    /tmp/clean-layer.sh

RUN apt-get update && apt-get install -y libatlas-base-dev libopenblas-dev libopencv-dev && \
    cd /usr/local/src && git clone --recursive --depth=1 --branch v1.6.x https://github.com/apache/incubator-mxnet.git mxnet && \
    cd mxnet && make -j$(nproc) USE_OPENCV=1 USE_BLAS=openblas && make rpkg && \
    /tmp/clean-layer.sh

    # Needed for "h5" library
RUN apt-get install -y libhdf5-dev && \
    # Needed for "topicmodels" library
    apt-get install -y libgsl-dev && \
    # Needed for "tesseract" library
    apt-get install -y libpoppler-cpp-dev libtesseract-dev tesseract-ocr-eng && \
    /tmp/clean-layer.sh

RUN apt-get install -y libzmq3-dev python-pip default-jdk && \
    apt-get install -y python-dev libcurl4-openssl-dev && \
    pip install jupyter pycurl && \
    # Install older tornado - https://github.com/jupyter/notebook/issues/4437
    pip install "tornado<6" && \
    # to avoid breaking UI change, pin the jupyter notebook package
    # the latest version also has a regression on the NotebookApp.ip option
    # see: https://www.google.com/url?q=https://github.com/jupyter/notebook/issues/3946&sa=D&usg=AFQjCNFieP7srXVWqX8PDetXGfhyxRmO4Q
    pip install notebook==5.5.0 && \
    # Pin nbconvert b/170301227
    pip install nbconvert==5.6.1 && \
    R -e 'IRkernel::installspec()' && \
    # Build pyzmq from source instead of using a pre-built binary.
    yes | pip uninstall pyzmq && \
    pip install pyzmq --no-binary pyzmq && \
    cp -r /root/.local/share/jupyter/kernels/ir /usr/local/share/jupyter/kernels && \
    # Make sure Jupyter won't try to "migrate" its junk in a read-only container
    mkdir -p /root/.jupyter/kernels && \
    cp -r /root/.local/share/jupyter/kernels/ir /root/.jupyter/kernels && \
    touch /root/.jupyter/jupyter_nbconvert_config.py && touch /root/.jupyter/migrated && \
    # papermill can replace nbconvert for executing notebooks
    pip install papermill && \
    /tmp/clean-layer.sh

# Tensorflow and Keras
# Keras sets up a virtualenv and installs tensorflow
# in the WORKON_HOME directory, so choose an explicit location for it.
ENV WORKON_HOME=/usr/local/share/.virtualenvs
RUN pip install --user virtualenv && R -e 'keras::install_keras(tensorflow = "2.3", extra_packages = c("pandas", "numpy", "pycryptodome"))'

# Install kaggle libraries.
# Do this at the end to avoid rebuilding everything when any change is made.
ADD kaggle/ /kaggle/
# RProfile sources files from /kaggle/ so ensure this runs after ADDing it.
ENV R_HOME=/usr/local/lib/R
ADD RProfile.R /usr/local/lib/R/etc/Rprofile.site
ADD install_iR.R  /tmp/install_iR.R
ADD bioconductor_installs.R /tmp/bioconductor_installs.R
ADD package_installs.R /tmp/package_installs.R
ADD nbconvert-extensions.tpl /opt/kaggle/nbconvert-extensions.tpl
# Install with `--vanilla` flag to avoid conflict. https://support.bioconductor.org/p/57187/
RUN Rscript --vanilla /tmp/package_installs.R
RUN Rscript --vanilla /tmp/bioconductor_installs.R
RUN Rscript --vanilla /tmp/install_iR.R

ARG GIT_COMMIT=unknown
ARG BUILD_DATE=unknown

LABEL git-commit=$GIT_COMMIT
LABEL build-date=$BUILD_DATE

# Find the current release git hash & build date inside the kernel editor.
RUN echo "$GIT_COMMIT" > /etc/git_commit && echo "$BUILD_DATE" > /etc/build_date
RUN echo "Hello Philmod"
RUN echo "$BUILD_DATE"
RUN cat /etc/build_date

CMD ["R"]
