context("patchwork")

# https://github.com/thomasp85/patchwork#basic-example
test_that("basic example", {
	expect_error({
		library(ggplot2)
		library(patchwork)

		p1 <- ggplot(mtcars) + geom_point(aes(mpg, disp))
		p2 <- ggplot(mtcars) + geom_boxplot(aes(gear, disp, group = gear))

		p1 + p2
	}, NA) # expect no error to be thrown
})
