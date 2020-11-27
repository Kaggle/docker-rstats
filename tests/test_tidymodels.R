context("tidymodels")

test_that("tidymodels exists", {
	library(tidymodels)
})

test_that("broom", {
	library(broom)
	fit <- lm(mpg ~ wt, mtcars)
        expect_equal(ncol(tidy(fit)), 5)
})
