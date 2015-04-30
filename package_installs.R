library(devtools)
install_github("hadley/readr")
install_github('dmlc/xgboost',subdir='R-package')
install_github("jkrijthe/Rtsne")

# try loading the h2o package
library(h2o)
h2oServer <- h2o.init()
