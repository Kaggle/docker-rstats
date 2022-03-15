options(repos = c("CRAN" = "http://cran.us.r-project.org"))
options(Ncpus = parallel::detectCores())

if("devtools" %in% rownames(installed.packages()) == FALSE)
	install.packages("devtools")
library(devtools)

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install(update=FALSE, ask=FALSE)
BiocManager::install("BiocGenerics", update=FALSE, ask=FALSE)
install_version("locfit", version = "1.5.9.4", ask=FALSE)
BiocManager::install("EBImage", update=FALSE, ask=FALSE)
BiocManager::install("rhdf5", update=FALSE, ask=FALSE)
BiocManager::install("limma", update=FALSE, ask=FALSE)
