context("mxnet")

test_that("mxnet", {
  library("xgboost")
  library("mxnet")
  a = mx.nd.ones(c(2,3))

  expect_equal(6, length(a))
})
