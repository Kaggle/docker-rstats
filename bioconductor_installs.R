options(repos = c("CRAN" = "http://cran.us.r-project.org"))
options(Ncpus = parallel::detectCores())

install.packages("devtools")
library(devtools)

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install(ask=FALSE)

BiocManager::install("BiocGenerics", ask=FALSE)
BiocManager::install("EBImage", ask=FALSE)
BiocManager::install("rhdf5", ask=FALSE)
BiocManager::install("limma", ask=FALSE)

install_url("http://cran.r-project.org/src/contrib/Archive/biOps/biOps_0.2.2.tar.gz", quiet=TRUE)
