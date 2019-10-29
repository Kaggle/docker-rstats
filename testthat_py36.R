#!/usr/bin/env Rscript
# Usage: testthat.R [TEST_FILE]
#
# TEST_FILE Run tests for the specified TEST_FILE (e.g. 'test_keras.R').
#
library("testthat")

args = commandArgs(trailingOnly=TRUE)

check_gpu <- function() {
  if (Sys.getenv("CUDA_VERSION") == "") {
    skip("Skipping GPU tests for CPU image")
  }
}

if (length(args)==1) {
  testthat::test_file(paste("/input/tests_py36", args[1], sep="/"))
} else {
  testthat::test_dir("/input/tests_py36")
}
