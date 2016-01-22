library(devtools)
install_github("hadley/readr")
install_github('dmlc/xgboost',subdir='R-package')
install_github("jkrijthe/Rtsne")
install_github("slowkow/ggrepel")

source("http://bioconductor.org/biocLite.R")
biocLite("EBImage", ask=FALSE)
install_url("http://cran.r-project.org/src/contrib/Archive/biOps/biOps_0.2.2.tar.gz")
