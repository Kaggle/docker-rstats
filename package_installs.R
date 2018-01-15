library(devtools)
install_github("hadley/readr")
install_github("jkrijthe/Rtsne")
install_github("jennybc/gapminder")
install_github("slowkow/ggrepel")
install_github("hadley/ggplot2")    # ggthemes is built against the latest ggplot2
install_github("jrnold/ggthemes")
install_github("thomasp85/ggforce")
install_github("thomasp85/ggraph")
install_github("dgrtwo/gganimate")
install_github("BillPetti/baseballr")
install_github("dahtah/imager")
install_github("elbamos/largevis", ref="develop")  # Using development branch for now, see https://github.com/elbamos/largeVis/issues/40
install_github("dgrtwo/widyr")
install_github("ellisp/forecastxgb-r-package/pkg")
install_github("rstudio/leaflet")
install_github("Microsoft/LightGBM", subdir = "R-package")
install_github("hrbrmstr/hrbrthemes")
install_github('catboost/catboost', subdir = 'catboost/R-package')
install_github("sassalley/hexmapr")
install_github("hadley/multidplyr")
install_github("dselivanov/text2vec")
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
devtools::install_github("muschellij2/fslr")
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
