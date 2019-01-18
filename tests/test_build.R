context("r packages")

#library("testthat")

Library <- function(libname){
  print(libname)
  suppressPackageStartupMessages(library(libname, character.only=TRUE))
}

check_gpu <- function() {
  if (Sys.getenv("CUDA_VERSION") == "") {
    skip("Skipping GPU tests for CPU image")
  }
}

test_that("imports", {
  Library("keras")
  print("Testing keras-python connection")
  m <- keras_model_sequential()
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
  Library("fslr")
  Library("imager")
  Library("hrbrthemes")

  expect_true(TRUE)
})

test_that("gpu imports", {
  check_gpu()

  print("TODO(rosbo): Add GPU import tests")
  expect_true(TRUE)
})

test_that("ggplot", {
  testImage <- "/working/ggplot_test.png"
  Library("ggplot2")
  testPlot1 <- ggplot(data.frame(x=1:10,y=runif(10))) + aes(x=x,y=y) + geom_line()
  ggsave(testPlot1, filename=testImage)
  expect_true(file.exists(testImage))
})

test_that("base graphics", {
  testImage <- "/working/base_graphics_test.jpg"
  jpeg(testImage)
  plot(runif(10))
  dev.off()
  expect_true(file.exists(testImage))
})

test_that("gganimate", {
  Library("gganimate")
  Library("gapminder")
  testPlot2 <- ggplot(gapminder,
                    aes(gdpPercap, lifeExp, size = pop, color = continent, frame = year),
                    transition_states(gear, transition_length = 2, state_length = 1)) +
  geom_point() +
  scale_x_log10()

  expect_true(TRUE)
})

test_that("mxnet", {
  Library("mxnet")
  a = mx.nd.ones(c(2,3))

  expect_equal(6, length(a))
})
