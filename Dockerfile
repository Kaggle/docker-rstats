FROM kaggle/rcran

# libv8-dev is needed for package DiagrammR, which xgboost needs

ADD RProfile.R /usr/local/lib/R/etc/Rprofile.site

ADD install_iR.R  /tmp/install_iR.R
ADD bioconductor_installs.R /tmp/bioconductor_installs.R
ADD package_installs.R /tmp/package_installs.R

RUN apt-get update && \
    (echo N; echo N) | apt-get install -y -f r-cran-rgtk2 && \
    apt-get install -y -f libv8-dev libgeos-dev libgdal-dev libproj-dev \
    libtiff5-dev libfftw3-dev libjpeg-dev libhdf4-0-alt libhdf4-alt-dev \
    libhdf5-dev libx11-dev cmake libglu1-mesa-dev libgtk2.0-dev libpq-dev && \
    # data.table added here because rcran missed it, and xgboost needs it
    install2.r --error --repo http://cran.rstudio.com \
	DiagrammeR \
	mefa \
	gridSVG \
	rgeos \
	rgdal \
	rARPACK \
	prevR \
	Amelia \
	rattle && \
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
    apt-get update && apt-get install -y libatlas-base-dev && \
    cd /usr/local/src && git clone --recursive --depth=1 https://github.com/nerdcha/mxnet && \
    cd /usr/local/src/mxnet && cp make/config.mk . && \
    sed -i 's/ADD_LDFLAGS =/ADD_LDFLAGS = -lstdc++/' config.mk && \
    sed -i 's/USE_OPENCV = 1/USE_OPENCV = 0/' config.mk && \
    make all && make rpkg && R CMD INSTALL mxnet_*.tar.gz && \
    # Needed for "h5" library
    apt-get install -y libhdf5-dev && \
    apt-get install -y libzmq3-dev && \
    Rscript /tmp/install_iR.R  && \
    cd /usr/local/src && wget https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    apt-get install -y python-dev libcurl4-openssl-dev && \
    pip install jupyter pycurl && \
    R -e 'IRkernel::installspec()' && \
    yes | pip uninstall pyzmq && pip install --no-use-wheel pyzmq && \
# Make sure Jupyter won't try to "migrate" its junk in a read-only container
    mkdir -p /root/.jupyter/kernels && \
    cp -r /root/.local/share/jupyter/kernels/ir /root/.jupyter/kernels && \
    touch /root/.jupyter/jupyter_nbconvert_config.py && touch /root/.jupyter/migrated

#FSL installation
#RUN wget -O- http://neuro.debian.net/lists/jessie.us-ca.full | tee /etc/apt/sources.list.d/neurodebian.sources.list && \
#    apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 0xA5D32F012649A5A9 && \
#    apt-get update && \
#    apt-get -y install fsl popularity-contest- && \
#    echo 'FSLDIR="/usr/share/fsl/5.0"' >> ~/.bashrc && \
#    echo '. ${FSLDIR}/etc/fslconf/fsl.sh' >> ~/.bashrc  && \
#    echo 'PATH=${FSLDIR}/bin:${PATH}' >> ~/.bashrc && \
#    echo 'export FSLDIR PATH' && \
#    # Disambiguate R version for RStudio server
#    echo 'rsession-which-r=/usr/local/bin/R' >> /etc/rstudio/rserver.conf

CMD ["R"]
