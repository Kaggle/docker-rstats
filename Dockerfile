FROM gcr.io/kaggle-images/rcran
ARG ncpus=1

ADD clean-layer.sh  /tmp/clean-layer.sh

ADD kaggle/ /kaggle/
# RProfile sources files from /kaggle/ so ensure this runs after ADDing it.
ENV R_HOME=/usr/local/lib/R
ADD RProfile.R /usr/local/lib/R/etc/Rprofile.site
ADD install_iR.R  /tmp/install_iR.R
ADD bioconductor_installs.R /tmp/bioconductor_installs.R
ADD package_installs.R /tmp/package_installs.R
ADD nbconvert-extensions.tpl /opt/kaggle/nbconvert-extensions.tpl

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
    patch && \
    /tmp/clean-layer.sh

# Install bioconductor packages.
RUN Rscript /tmp/bioconductor_installs.R

RUN apt-get update && apt-get install -y libatlas-base-dev libopenblas-dev libopencv-dev && \
    cd /usr/local/src && git clone --recursive --depth=1 --branch v1.6.x https://github.com/apache/incubator-mxnet.git mxnet && \
    cd mxnet && make -j $(nproc) USE_OPENCV=1 USE_BLAS=openblas && make rpkg && \
    # Needed for "h5" library
    apt-get install -y libhdf5-dev && \
    # Needed for "topicmodels" library
    apt-get install -y libgsl-dev && \
    /tmp/clean-layer.sh

RUN apt-get install -y libzmq3-dev python-pip default-jdk && \
    apt-get install -y python-dev libcurl4-openssl-dev && \
    pip install jupyter pycurl && \
    # to avoid breaking UI change, pin the jupyter notebook package
    # the latest version also has a regression on the NotebookApp.ip option
    # see: https://www.google.com/url?q=https://github.com/jupyter/notebook/issues/3946&sa=D&usg=AFQjCNFieP7srXVWqX8PDetXGfhyxRmO4Q
    pip install notebook==5.5.0 && \
    R -e 'IRkernel::installspec()' && \
    # Build pyzmq from source instead of using a pre-built binary.
    yes | pip uninstall pyzmq && \
    pip install pyzmq --no-binary pyzmq && \
    cp -r /root/.local/share/jupyter/kernels/ir /usr/local/share/jupyter/kernels && \
    # Make sure Jupyter won't try to "migrate" its junk in a read-only container
    mkdir -p /root/.jupyter/kernels && \
    cp -r /root/.local/share/jupyter/kernels/ir /root/.jupyter/kernels && \
    touch /root/.jupyter/jupyter_nbconvert_config.py && touch /root/.jupyter/migrated && \
    /tmp/clean-layer.sh

# Tensorflow and Keras
# Keras sets up a virtualenv and installs tensorflow
# in the WORKON_HOME directory, so choose an explicit location for it.
ENV WORKON_HOME=/usr/local/share/.virtualenvs
RUN pip install --user virtualenv && R -e 'keras::install_keras(tensorflow = "1.15")'

# Install kaggle libraries.
RUN Rscript /tmp/package_installs.R
RUN Rscript /tmp/bioconductor_installs.R
RUN Rscript /tmp/install_iR.R

# Py3 handles a read-only environment fine, but Py2.7 needs
# help https://docs.python.org/2/using/cmdline.html#envvar-PYTHONDONTWRITEBYTECODE
ENV PYTHONDONTWRITEBYTECODE=1
# Tell reticulate where to find python
# https://rstudio.github.io/reticulate/articles/versions.html
ENV RETICULATE_PYTHON="/usr/local/share/.virtualenvs/r-reticulate/bin/"

# Install miniconda (for competitions time-series library)
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.12-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy

# Make a Python 3.6 env for time-series library with dependent packages
RUN /opt/conda/bin/conda create -n py36 python=3.6 pandas numpy pycryptodome

CMD ["R"]
