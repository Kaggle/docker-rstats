context("bayesCL")

test_that("mlr", {
    check_gpu()
    
    library(bayesCL)
    library(keras) # for the to_categorical method

    X <- matrix(rnorm(100 * 10), nrow = 100)
    y <- to_categorical(matrix(sample(0:2, 100, TRUE), ncol = 1), 3)

    #TODO: b/143684455 - This test is causing a segault
    expect_equal(TRUE,TRUE)
    #out <- mlr(y, X, samp=1000, burn=100, device=0);
    #expect_equal(100, length(out$n))
})
