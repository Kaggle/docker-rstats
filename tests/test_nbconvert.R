context("nbconvert")

test_that("nbconvert to notebook", {
	expect_error({
		library(jsonlite)

		results <- system("jupyter nbconvert --to notebook --template /opt/kaggle/nbconvert-extensions.tpl --execute --stdout /input/tests/data/notebook.ipynb",
			intern = TRUE)
		json <- fromJSON(results, simplifyVector = FALSE)
		expect_equal(json$cells[[1]]$outputs[[1]]$text[[1]], "[1] 999\n")
    }, NA) # expect no error to be thrown
})

test_that("nbconvert to html", {
	expect_error({
		results <- system("jupyter nbconvert --to html --stdout --template /opt/kaggle/nbconvert-extensions.tpl --Exporter.preprocessors=[\\\"nbconvert.preprocessors.ExtractOutputPreprocessor\\\"] \"/input/tests/data/notebook.ipynb\"",
			intern = TRUE)
		expect_match(toString(results), ".*>999<.*")  # [...] <span class="n">x</span> <span class="o">&lt;-</span> <span class="m">999</span> [...]
    }, NA) # expect no error to be thrown
})