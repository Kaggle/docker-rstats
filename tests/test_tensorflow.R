context("tensorflow")

test_that("gpu imports", {
  check_gpu()

  #TODO(b/143642025): update to TF2.0 compatible and fix potential CUDA issues.
 
  library(tensorflow)
  with(tf$device("/gpu:0"), {
      const <- tf$constant(42)
      expect_equal(42, as.integer(const))
  })

  expect_true(TRUE)
})
