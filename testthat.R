library("testthat")

check_gpu <- function() {
  if (Sys.getenv("CUDA_VERSION") == "") {
    skip("Skipping GPU tests for CPU image")
  }
}

testthat::test_dir("/input/tests")
