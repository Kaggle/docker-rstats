if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install(update=TRUE, ask=FALSE)

BiocManager::install("BiocGenerics", ask=FALSE)
BiocManager::install("EBImage", ask=FALSE)
BiocManager::install("rhdf5", ask=FALSE)
BiocManager::install("limma", ask=FALSE)

library(devtools)
install_url("http://cran.r-project.org/src/contrib/Archive/biOps/biOps_0.2.2.tar.gz", quiet=TRUE)
