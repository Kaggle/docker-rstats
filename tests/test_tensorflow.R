context("tensorflow")

test_that("gpu imports", {
  check_gpu()

  library(tensorflow)
  sess <- tf$Session()
  with(tf$device("/gpu:0"), {
      const <- tf$constant(42)
      expect_equal(42, sess$run(const))
  })

  expect_true(TRUE)
})
