FROM kaggle/rcran

# libv8-dev is needed for package DiagrammR, which xgboost needs
# installing r-cran-rgtk2 to deal w/ error installing R package Rgtk2 ("GTK version 2.8.0 required") which was a dependency
#   for R package rattle. (Suggested here: http://r.789695.n4.nabble.com/RGtk2-on-Debian-Testing-td3311725.html)
#   (I tried a bunch of other things for a long time w/ no success.)

RUN apt-get update \
  && apt-get install -y -f r-cran-rgtk2 libv8-dev libgeos-dev libgdal-dev libgdal1i libproj-dev \
    libtiff5-dev libfftw3-dev libjpeg-dev libhdf4-0-alt libhdf4-alt-dev \
    libhdf5-dev

RUN install2.r --error \
	DiagrammeR \
	mefa \
	gridSVG \
	rgeos \
	rgdal \
	rARPACK \
	Amelia \
	prevR
	
ADD RProfile.R /etc/R/Rprofile.site

# package installation using devtools' install_github function
ADD package_installs.R /tmp/package_installs.R 
    
    # XGBoost gets special treatment because the nightlies are hard to build with devtools.
RUN cd /usr/local/src && git clone --recursive https://github.com/dmlc/xgboost && \
    cd xgboost && make Rbuild && R CMD INSTALL xgboost_*.tar.gz && \
    Rscript /tmp/package_installs.R

    # MXNet
RUN apt-get update && apt-get install -y g++-4.8 libatlas-base-dev && \
    cd /usr/local/src && git clone --recursive https://github.com/dmlc/mxnet && \
    cd /usr/local/src/mxnet && cp make/config.mk . && sed -i 's/CC = gcc/CC = gcc-4.8/' config.mk && \
    sed -i 's/CXX = g++/CXX = g++-4.8/' config.mk && \
    sed -i 's/ADD_LDFLAGS =/ADD_LDFLAGS = -lstdc++/' config.mk && \
    sed -i 's/USE_OPENCV = 1/USE_OPENCV = 0/' config.mk && \
    make all && make rpkg

    # IRKernel
ADD install_iR.R  /tmp/install_iR.R

RUN apt-get install -y libzmq3-dev && \
    Rscript /tmp/install_iR.R  && \
    apt-get install -y python-pip python-dev libcurl4-openssl-dev && \
    pip install jupyter pycurl && \
    R -e 'IRkernel::installspec()' && \
    yes | pip uninstall pyzmq && pip install --no-use-wheel pyzmq && \
# Make sure Jupyter won't try to "migrate" its junk in a read-only container
    mkdir -p /root/.jupyter/kernels && \
    cp -r /root/.local/share/jupyter/kernels/ir /root/.jupyter/kernels && \
    touch /root/.jupyter/jupyter_nbconvert_config.py && touch /root/.jupyter/migrated

CMD ["R"]


