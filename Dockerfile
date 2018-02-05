FROM kaggle/rcran

# libv8-dev is needed for package DiagrammR, which xgboost needs


ADD RProfile.R /usr/local/lib/R/etc/Rprofile.site

ADD install_iR.R  /tmp/install_iR.R
ADD bioconductor_installs.R /tmp/bioconductor_installs.R
ADD package_installs.R /tmp/package_installs.R
ADD patches/ /tmp/patches/
ADD nbconvert-extensions.tpl /opt/kaggle/nbconvert-extensions.tpl

RUN apt-get update && \
    (echo N; echo N) | apt-get install -y -f r-cran-rgtk2 && \
    apt-get install -y -f libv8-dev libgeos-dev libgdal-dev libproj-dev libsndfile1-dev \
    libtiff5-dev fftw3 fftw3-dev libfftw3-dev libjpeg-dev libhdf4-0-alt libhdf4-alt-dev \
    libhdf5-dev libx11-dev cmake libglu1-mesa-dev libgtk2.0-dev patch && \
    # data.table added here because rcran missed it, and xgboost needs it
    install2.r --error --repo http://cran.rstudio.com \
	DiagrammeR \
	mefa \
	gridSVG \
	rgeos \
	rgdal \
	rARPACK \
	prevR \
	# Rattle installation currently broken by missing "cairoDevice" error
	# rattle \
	Amelia && \
    # XGBoost gets special treatment because the nightlies are hard to build with devtools.
    cd /usr/local/src && git clone --recursive https://github.com/dmlc/xgboost && \
    cd xgboost && make Rbuild && R CMD INSTALL xgboost_*.tar.gz && \
    # Prereq for installing udunits2 package; see https://github.com/edzer/units
    cd /usr/local/src && wget ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.2.24.tar.gz && \
    tar zxf udunits-2.2.24.tar.gz && cd udunits-2.2.24 && ./configure && make && make install && \
    ldconfig && echo 'export UDUNITS2_XML_PATH="/usr/local/share/udunits/udunits2.xml"' >> ~/.bashrc && \
    export UDUNITS2_XML_PATH="/usr/local/share/udunits/udunits2.xml" && \
    Rscript /tmp/package_installs.R

RUN Rscript /tmp/bioconductor_installs.R && \
    apt-get update && apt-get install -y libatlas-base-dev libopenblas-dev libopencv-dev && \
    cd /usr/local/src && git clone --recursive --depth=1 --branch 0.11.0 https://github.com/apache/incubator-mxnet.git mxnet && \
    cd mxnet &&  make -j 4 USE_OPENCV=1 USE_BLAS=openblas && \
    cd R-package && Rscript -e "library(devtools); library(methods); options(repos=c(CRAN='https://cran.rstudio.com')); install_deps(dependencies = TRUE)" && \
    cd .. && make rpkg && R CMD INSTALL mxnet_current_r.tar.gz && \
    # Needed for "h5" library
    apt-get install -y libhdf5-dev

RUN apt-get install -y libzmq3-dev && \
    Rscript /tmp/install_iR.R  && \
    cd /usr/local/src && wget https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    apt-get install -y python-dev libcurl4-openssl-dev && \
    pip install jupyter pycurl && \
    R -e 'IRkernel::installspec()' && \
    yes | pip uninstall pyzmq && pip install --no-use-wheel pyzmq && \
    cp -r /root/.local/share/jupyter/kernels/ir /usr/local/share/jupyter/kernels && \
# Make sure Jupyter won't try to "migrate" its junk in a read-only container
    mkdir -p /root/.jupyter/kernels && \
    cp -r /root/.local/share/jupyter/kernels/ir /root/.jupyter/kernels && \
    touch /root/.jupyter/jupyter_nbconvert_config.py && touch /root/.jupyter/migrated

# Tensorflow and Keras
RUN pip install virtualenv && R -e 'keras::install_keras()' 
# Py3 handles a read-only environment fine, but Py2.7 needs 
# help https://docs.python.org/2/using/cmdline.html#envvar-PYTHONDONTWRITEBYTECODE
ENV PYTHONDONTWRITEBYTECODE=1
# keras::install_keras puts the new libraries inside a virtualenv called r-tensorflow. Importing the
# library triggers a reinstall/rebuild unless the reticulate library gets a strong hint about
# where to find it.
# https://rstudio.github.io/reticulate/articles/versions.html
ENV RETICULATE_PYTHON="/root/.virtualenvs/r-tensorflow/bin/python"

# Finally, apply any locally defined patches.
RUN /bin/bash -c \
    "cd / && for p in $(ls /tmp/patches/*.patch); do echo '= Applying patch '\${p}; patch -p2 < \${p}; done"

CMD ["R"]
