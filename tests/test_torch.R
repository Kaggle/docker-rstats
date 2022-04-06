context("torch")

test_that("cpu imports", {
  library(torch)
  x <- array(runif(8), dim = c(2, 2, 2))
  y <- torch_tensor(x, dtype = torch_float64())
  expect_identical(x, as_array(y))
})

# TODO(philmod): find a solution for Torch not working with CUDA 11.4
# https://github.com/mlverse/torch/issues/807
# test_that("gpu imports", {
#   check_gpu()
 
#   library(torch)
#   x <- array(runif(8), dim = c(2, 2, 2))
#   y <- torch_tensor(x, dtype = torch_float64(), device = "cuda")
#   expect_identical(x, as_array(y$cpu()))
# })

