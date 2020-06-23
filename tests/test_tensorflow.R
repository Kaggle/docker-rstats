context("tensorflow")

test_that("gpu imports", {
  check_gpu()
 
  library(tensorflow)
  with(tf$device("/gpu:0"), {
      const <- tf$constant(42)
      expect_equal(42, as.integer(const))
  })

  expect_true(TRUE)
})
