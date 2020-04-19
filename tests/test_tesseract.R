context("tesseract")

test_that("ocr", {
  library(tesseract)
	eng <- tesseract("eng")
	text <- tesseract::ocr("http://jeroen.github.io/images/testocr.png", engine = eng)
	expect_match(text, "This is a lot of 12 point text")
})
