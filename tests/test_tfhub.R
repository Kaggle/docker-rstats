context("tfhub")

test_that("tfhub", {
    library(tfhub)
    module <- hub_load("https://tfhub.dev/google/tf2-preview/mobilenet_v2/feature_vector/2")
    input <- tf$random$uniform(shape = shape(1,224,224,3), minval = 0, maxval = 1)
    output <- module(input)
})
