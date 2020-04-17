context("nbconvert")

test_that("nbconvert exists", {
	expect_error({
		library(jsonlite)

		results <- system("jupyter nbconvert --to notebook --template /opt/kaggle/nbconvert-extensions.tpl --execute --stdout /input/tests/data/notebook.ipynb",
			intern = TRUE)
		json <- fromJSON(results, simplifyVector = FALSE)
		expect_equal(json$cells[[1]]$outputs[[1]]$text[[1]], "[1] 999\n")
    }, NA) # expect no error to be thrown
})
