context("import")

Library <- function(libname){
  print(libname)
  suppressPackageStartupMessages(library(libname, character.only=TRUE))
}

# Add packages to that list to ensure they are installed on the image
# and prevent future regression.
test_that("imports", {
  import_pkgs <- function() {
    Library("bitops")
    Library("colorspace")
    Library("dichromat")
    Library("digest")
    Library("dplyr")
    Library("fftw")
    Library("ggforce")
    Library("ggrepel")
    Library("gtable")
    Library("hrbrthemes")
    Library("imager")
    Library("knitr")
    Library("labeling")
    Library("lightgbm")
    Library("mime")
    Library("munsell")
    Library("plyr")
    Library("proto")
    Library("randomForest")
    Library("RColorBrewer")
    Library("Rcpp")
    Library("RCurl")
    Library("readr")
    Library("reshape2")
    Library("rstan")
    Library("Rtsne")
    Library("scales")
    Library("seewave")
    Library("stringr")
    Library("tesseract")
    Library("tidyr")
    Library("xgboost")
    Library("zoo")

    # bioconductor
    Library("BiocGenerics")
    Library("EBImage")
    Library("limma")
    Library("rhdf5")
  }

  # expect no error to be thrown
  expect_error(import_pkgs(), NA) 
})
