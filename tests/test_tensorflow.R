context("tensorflow")

test_that("check gpu device", {
  check_gpu()
 
  library(tensorflow)
  gpus = tf$config$experimental$list_physical_devices('GPU')
  expect_gte(length(gpus), 1)
})

test_that("tensorflow with gpu", {
  check_gpu()
 
  library(tensorflow)
  with(tf$device("/gpu:0"), {
      const <- tf$constant(42)
      expect_equal(42, as.integer(const))
  })
})
