context("topicmodels")

test_that("basic topic model example", {
	expect_error({
		library(topicmodels)
        	data("AssociatedPress")
		ap_lda <- LDA(AssociatedPress, k = 2, control = list(seed = 1234))
	}, NA) # expect no error to be thrown
})
