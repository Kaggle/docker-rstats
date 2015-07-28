library(devtools)
install_github("hadley/readr")
install_github('dmlc/xgboost',subdir='R-package')
install_github("jkrijthe/Rtsne")

source("http://bioconductor.org/biocLite.R")
biocLite("EBImage", ask=FALSE)
