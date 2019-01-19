context("gg* packages")

test_that("gganimate", {
  library("gganimate")
  library("gapminder")
  testPlot2 <- ggplot(gapminder,
                    aes(gdpPercap, lifeExp, size = pop, color = continent, frame = year),
                    transition_states(gear, transition_length = 2, state_length = 1)) +
  geom_point() +
  scale_x_log10()

  expect_true(TRUE)
})

test_that("ggplot", {
  testImage <- "/working/ggplot_test.png"
  library("ggplot2")
  testPlot1 <- ggplot(data.frame(x=1:10,y=runif(10))) + aes(x=x,y=y) + geom_line()
  ggsave(testPlot1, filename=testImage)
  expect_true(file.exists(testImage))
})
