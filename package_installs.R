library(devtools)
install_github("hadley/readr")
install_github("jkrijthe/Rtsne")
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
devtools::install_github("stnava/ANTsR")
devtools::install_github("muschellij2/extrantsr")


