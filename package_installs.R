library(devtools)
install_github("hadley/readr")
install_github("jkrijthe/Rtsne")
install_github("slowkow/ggrepel")
install_github("jrnold/ggthemes")

# Based on https://www.datascienceriot.com/how-to-install-openwar-package-in-r-studio-on-linux-and-windows/kris/
install.packages("Sxslt", repos = "http://www.omegahat.org/R", type = "source")
install_github("beanumber/openWAR")

install_github("BillPetti/baseballr")

source("http://bioconductor.org/biocLite.R")
biocLite("EBImage", ask=FALSE)
install_url("http://cran.r-project.org/src/contrib/Archive/biOps/biOps_0.2.2.tar.gz")
