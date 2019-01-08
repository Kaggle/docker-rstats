library(devtools)
# Install the lightGBM installer package
install_github("Laurae2/lgbdl")
lgbdl::lgb.dl(compiler = "gcc")

install_github("hadley/ggplot2")    # ggthemes is built against the latest ggplot2
install_github("jrnold/ggthemes")
install_github("thomasp85/ggraph")
install_github("thomasp85/gganimate")
install_github("BillPetti/baseballr")
install_github("elbamos/largevis")  # The package was removed from R CRAN: https://cran.r-project.org/web/packages/largeVis/index.html
install_github("dgrtwo/widyr")
install_github("ellisp/forecastxgb-r-package/pkg")
install_github("rstudio/leaflet")
install_github('catboost/catboost@v0.10.2', subdir = 'catboost/R-package') # build is failing against master
install_github("sassalley/hexmapr")
install_github("hadley/multidplyr")
install_github("dselivanov/LSHR")

# install latest sparklyr and Spark (for local mode)
install_github("rstudio/sparklyr")
sparklyr::spark_install()

install.packages("genderdata", repos = "http://packages.ropensci.org")

install.packages("openNLPmodels.en",
                 repos = "http://datacube.wu.ac.at/",
                 type = "source")

install_github("davpinto/fastknn")
install_github("mukul13/rword2vec")

#Packages for Neurohacking in R coursera course
install.packages("oro.nifti")
install.packages("oro.dicom")
devtools::install_github("stnava/ITKR")
install_github("stnava/ANTsRCore")
devtools::install_github("stnava/ANTsR")
devtools::install_github("muschellij2/extrantsr")

install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/latest_stable_R"))) # install the latest stable version of h2o
  
# An upgrade to BH broke rstan, which in turn broke prophet. https://github.com/stan-dev/rstan/issues/441
install_version("BH", version="1.62.0-1")
install.packages("rstan")
install.packages("prophet")

# These signal processing libraries are on CRAN, but they require apt-get dependences that are
# handled in this image's Dockerfile.
install.packages("fftw")
install.packages("seewave")
