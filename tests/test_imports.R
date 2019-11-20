context("import")

Library <- function(libname){
  print(libname)
  suppressPackageStartupMessages(library(libname, character.only=TRUE))
}

# Add packages to that list to ensure they are installed on the image
# and prevent future regression.
test_that("imports", {
  import_pkgs <- function() {
    Library("Rcpp")
    Library("ggrepel")
    Library("ggforce")
    Library("stringr")
    Library("plyr")
    Library("digest")
    Library("reshape2")
    Library("colorspace")
    Library("RColorBrewer")
    Library("scales")
    Library("labeling")
    Library("proto")
    Library("munsell")
    Library("gtable")
    Library("dichromat")
    Library("mime")
    Library("RCurl")
    Library("Rtsne")
    Library("bitops")
    Library("zoo")
    Library("knitr")
    Library("dplyr")
    Library("readr")
    Library("tidyr")
    Library("randomForest")
    Library("xgboost")
    Library("rstan")
    Library("prophet")
    Library("fftw")
    Library("seewave")
    Library("lightgbm")
    # TODO(b/144846502) Fix fslr package installation.
    # Library("fslr")
    Library("imager")
    # TODO(b/144846308) Fix hrbrthemes package installation.
    # Library("hrbrthemes")
  }

  # expect no error to be thrown
  expect_error(import_pkgs(), NA) 
})
