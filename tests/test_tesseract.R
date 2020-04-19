context("tesseract")

test_that("ocr", {
	library(tesseract)
	eng <- tesseract("eng")
	fpath <- file.path('/input/tests/data/testocr.png')
	text <- tesseract::ocr(fpath, engine = eng)
	expect_match(text, "This is a lot of 12 point text")
})