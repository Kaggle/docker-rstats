FROM kaggle/rcran

# libv8-dev is needed for package DiagrammR, which xgboost needs
# installing r-cran-rgtk2 to deal w/ error installing R package Rgtk2 ("GTK version 2.8.0 required") which was a dependency
#   for R package rattle. (Suggested here: http://r.789695.n4.nabble.com/RGtk2-on-Debian-Testing-td3311725.html)
#   (I tried a bunch of other things for a long time w/ no success.)

RUN date

RUN apt-get update \
  && apt-get install -y -f r-cran-rgtk2 libv8-dev libgeos-dev libgdal-dev libgdal1i libproj-dev \
    libtiff5-dev libfftw3-dev libjpeg-dev libhdf4-0-alt libhdf4-alt-dev \
    libhdf5-dev

RUN date

RUN install2.r --error \
	DiagrammeR \
	mefa \
	gridSVG \
	rgeos \
	rgdal \
	rARPACK \
	Amelia \
	prevR
	
RUN date

ADD RProfile.R /etc/R/Rprofile.site

RUN date

# package installation using devtools' install_github function
ADD package_installs.R /tmp/package_installs.R 

RUN date

RUN Rscript /tmp/package_installs.R

    # MXNet
RUN apt-get install -y g++-4.8 && \
    cd /usr/local/src && git clone --recursive https://github.com/dmlc/mxnet && \
    cd /usr/local/src/mxnet && cp make/config.mk . && sed -i 's/CC = gcc/CC = gcc-4.8/' config.mk && \
    sed -i 's/CXX = g++/CXX = g++-4.8/' config.mk && \
    sed -i 's/ADD_LDFLAGS =/ADD_LDFLAGS = -lstdc++/' config.mk && \
    make && R CMD INSTALL R-package

CMD ["R"]

RUN date

