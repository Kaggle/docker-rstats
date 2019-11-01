context("graphics")

test_that("plot", {
  testImage <- "/working/base_graphics_test.jpg"
  jpeg(testImage)
  plot(runif(10))
  dev.off()
  expect_true(file.exists(testImage))
})
