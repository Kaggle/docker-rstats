library(devtools)
options(repos = c("CRAN" = "http://cran.us.r-project.org"))
options(Ncpus = parallel::detectCores())

# Install the lightGBM installer package
install_github("Laurae2/lgbdl")
lgbdl::lgb.dl(compiler = "gcc", commit = "tags/v2.3.1")

install.packages('ggthemes', dependencies = TRUE)
install_github("thomasp85/ggraph")
install_github("thomasp85/gganimate")
install_github("dgrtwo/widyr")
install_github("ellisp/forecastxgb-r-package/pkg")
install_github("rstudio/leaflet")
# install_github fails for catboost.
# Following direct installation instructions instead: https://tech.yandex.com/catboost/doc/dg/installation/r-installation-binary-installation-docpage/
install_url('https://github.com/catboost/catboost/releases/download/v0.23.2/catboost-R-Linux-0.23.2.tgz', INSTALL_opts = c("--no-multiarch"))
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

# These signal processing libraries are on CRAN, but they require apt-get dependences that are
# handled in this image's Dockerfile.
install.packages("fftw")

# https://github.com/Kaggle/docker-rstats/issues/74
install_github("thomasp85/patchwork")

# https://github.com/Kaggle/docker-rstats/issues/73
install.packages("topicmodels")

install.packages("tesseract")
