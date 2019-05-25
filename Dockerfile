FROM gcr.io/kaggle-images/rcran
ARG ncpus=1

ADD clean-layer.sh  /tmp/clean-layer.sh

RUN apt-get update && \
    apt-get install apt-transport-https && \
    /tmp/clean-layer.sh

# libv8-dev is needed for package DiagrammR, which xgboost needs
RUN apt-get update && \
    (echo N; echo N) | apt-get install -y -f r-cran-rgtk2 && \
    apt-get install -y -f libv8-dev libgeos-dev libgdal-dev libproj-dev libsndfile1-dev \
    libtiff5-dev fftw3 fftw3-dev libfftw3-dev libjpeg-dev libhdf4-0-alt libhdf4-alt-dev \
    libhdf5-dev libx11-dev cmake libglu1-mesa-dev libgtk2.0-dev librsvg2-dev libxt-dev \
    patch && \
    # data.table added here because rcran missed it, and xgboost needs it
    # `ncpus` matches the number of CPU offered by the biggest machine available on GCB.
    install2.r --error --ncpus $ncpus --repo http://cran.rstudio.com \
    DiagrammeR mefa gridSVG lattice rgeos rgdal Matrix rARPACK foreign prevR nnet rpart \
    class imager Amelia \
    # Packages necessary for /tmp/package_installs.R
    MASS mgcv survival KernSmooth && \
    # Rattle installation currently broken by missing "cairoDevice" error
    # rattle \
    # XGBoost gets special treatment because the nightlies are hard to build with devtools.
    cd /usr/local/src && git clone --recursive https://github.com/dmlc/xgboost && \
    cd xgboost && make -j $ncpus Rbuild && R CMD INSTALL xgboost_*.tar.gz && \
    # Prereq for installing udunits2 package; see https://github.com/edzer/units
    cd /usr/local/src && wget ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.2.24.tar.gz && \
    tar zxf udunits-2.2.24.tar.gz && cd udunits-2.2.24 && ./configure && make && make install && \
    ldconfig && echo 'export UDUNITS2_XML_PATH="/usr/local/share/udunits/udunits2.xml"' >> ~/.bashrc && \
    export UDUNITS2_XML_PATH="/usr/local/share/udunits/udunits2.xml"

RUN apt-get update && apt-get install -y libatlas-base-dev libopenblas-dev libopencv-dev && \
    cd /usr/local/src && git clone --recursive --depth=1 --branch v1.4.x https://github.com/apache/incubator-mxnet.git mxnet && \
    cd mxnet && make -j $ncpus USE_OPENCV=1 USE_BLAS=openblas && make rpkg && \
    # Needed for "h5" library
    apt-get install -y libhdf5-dev

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
    touch /root/.jupyter/jupyter_nbconvert_config.py && touch /root/.jupyter/migrated

# Tensorflow and Keras
# Keras sets up a virtualenv and installs tensorflow
# in the WORKON_HOME directory, so choose an explicit location for it.
ENV WORKON_HOME=/usr/local/share/.virtualenvs
RUN pip install --user virtualenv && R -e 'keras::install_keras()'

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
RUN Rscript /tmp/package_installs.R
RUN Rscript /tmp/bioconductor_installs.R
RUN Rscript /tmp/install_iR.R

# Py3 handles a read-only environment fine, but Py2.7 needs
# help https://docs.python.org/2/using/cmdline.html#envvar-PYTHONDONTWRITEBYTECODE
ENV PYTHONDONTWRITEBYTECODE=1
# keras::install_keras puts the new libraries inside a virtualenv called r-tensorflow. Importing the
# library triggers a reinstall/rebuild unless the reticulate library gets a strong hint about
# where to find it.
# https://rstudio.github.io/reticulate/articles/versions.html
ENV RETICULATE_PYTHON="/usr/local/share/.virtualenvs/r-tensorflow/bin/python"

CMD ["R"]
