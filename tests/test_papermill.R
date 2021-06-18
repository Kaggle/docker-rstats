context("papermill")

test_that("papermill exists", {
	expect_error({
		library(jsonlite)

		results <- system("papermill /input/tests/data/notebook.ipynb -",
			intern = TRUE)
		json <- fromJSON(results, simplifyVector = FALSE)
		expect_equal(json$cells[[1]]$outputs[[1]]$text[[1]], "[1] 999\n")
    }, NA) # expect no error to be thrown
})

test_that("python papermill exists", {
	expect_error({
		system("python --version")
		res <- system("python -c 'import sys;import papermill as pm; print(pm.__version__)'",
			intern = TRUE)
		expect_match(res, "\\d\\.\\d\\.\\d")
    }, NA)
})