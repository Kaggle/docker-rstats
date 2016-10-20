source("http://bioconductor.org/biocLite.R")
biocLite(ask=FALSE)
biocLite("EBImage", ask=FALSE)
biocLite("rhdf5", ask=FALSE)
biocLite("limma", ask=FALSE)
# Wrapped in a tryCatch to stop it halting the build because packages like ggrepel and readr are "too new"
tryCatch({biocValid()}, error=function(e){cat("biocValid ERROR:  :",conditionMessage(e), "\n")})

library(devtools)
install_url("http://cran.r-project.org/src/contrib/Archive/biOps/biOps_0.2.2.tar.gz")
