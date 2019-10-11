context("topicmodels")

# https://eight2late.wordpress.com/2015/09/29/a-gentle-introduction-to-topic-modeling-using-r/
test_that("basic example", {
	expect_error({
		library(topicmodels)

		#Set parameters for Gibbs sampling
		burnin <- 4000
		iter <- 2000
		thin <- 500
		seed <-list(2003,5,63,100001,765)
		nstart <- 5
		best <- TRUE

		#Number of topics
		k <- 5

		#Run LDA using Gibbs sampling
		ldaOut <-LDA(dtm,k, method=”Gibbs”, control=list(nstart=nstart, seed = seed, best=best, burnin = burnin, iter = iter, thin=thin))
	}, NA) # expect no error to be thrown
})
