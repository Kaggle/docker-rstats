FROM kaggle/rcran

# libv8-dev is needed for package DiagrammR, which xgboost needs
# installing r-cran-rgtk2 to deal w/ error installing R package Rgtk2 ("GTK version 2.8.0 required") which was a dependency
#   for R package rattle. (Suggested here: http://r.789695.n4.nabble.com/RGtk2-on-Debian-Testing-td3311725.html)
#   (I tried a bunch of other things for a long time w/ no success.)
RUN apt-get update \
  && apt-get install -y r-cran-rgtk2 libv8-dev libgeos-dev libgdal-dev libproj-dev

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
RUN Rscript /tmp/package_installs.R

CMD ["R"]
