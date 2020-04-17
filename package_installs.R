library(devtools)
options(repos = c("CRAN" = "http://cran.us.r-project.org"))
options(Ncpus = parallel::detectCores())

# Install the lightGBM installer package
install_github("Laurae2/lgbdl")
lgbdl::lgb.dl(compiler = "gcc")

install_github("hadley/ggplot2")    # ggthemes is built against the latest ggplot2
install_github("jrnold/ggthemes")
install_github("thomasp85/ggraph")
install_github("thomasp85/gganimate")
install_github("elbamos/largevis")  # The package was removed from R CRAN: https://cran.r-project.org/web/packages/largeVis/index.html
install_github("dgrtwo/widyr")
install_github("ellisp/forecastxgb-r-package/pkg")
install_github("rstudio/leaflet")
# install_github fails for catboost.
# Following direct installation instructions instead: https://tech.yandex.com/catboost/doc/dg/installation/r-installation-binary-installation-docpage/
install_url('https://github.com/catboost/catboost/releases/download/v0.12.1.1/catboost-R-Linux-0.12.1.1.tgz', args = c("--no-multiarch"))
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
