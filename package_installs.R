library(devtools)
install_github("hadley/readr")
install_git('dmlc/xgboost', subdir='R-package', args="--recursive")
install_github("jkrijthe/Rtsne")
install_github("slowkow/ggrepel")

source("http://bioconductor.org/biocLite.R")
biocLite("EBImage", ask=FALSE)
install_url("http://cran.r-project.org/src/contrib/Archive/biOps/biOps_0.2.2.tar.gz")
