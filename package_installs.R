library(devtools)
install_github("hadley/readr")

# xgboost has previously been git clone'd
setwd("/usr/local/src/xgboost")
build()
install()

install_github("jkrijthe/Rtsne")
install_github("slowkow/ggrepel")

source("http://bioconductor.org/biocLite.R")
biocLite("EBImage", ask=FALSE)
install_url("http://cran.r-project.org/src/contrib/Archive/biOps/biOps_0.2.2.tar.gz")
