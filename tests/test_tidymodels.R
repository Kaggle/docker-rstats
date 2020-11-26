context("tidymodels")

test_that("tidymodels exists", {
	library(tidymodels)
})

test_that("broom", {
	library(broom)
	fit <- lm(Volume ~ Girth + Height, trees)
	expect_equal(ncol(tidy(fit)), 5)
})