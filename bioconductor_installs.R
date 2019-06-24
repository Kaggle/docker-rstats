if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install()
BiocManager::install("EBImage")
BiocManager::install("rhdf5")
BiocManager::install("limma")

library(devtools)
install_url("http://cran.r-project.org/src/contrib/Archive/biOps/biOps_0.2.2.tar.gz", quiet=TRUE)
