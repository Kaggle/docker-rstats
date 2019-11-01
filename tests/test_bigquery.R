context("bigquery")

test_that("bigquery exists", {
    exists('TokenBigQueryKernel')
    exists('query_exec')
})
