# Loosely based on http://www.kdnuggets.com/2015/06/top-20-r-packages.html

Library <- function(libname){
  print(libname)
  suppressPackageStartupMessages(library(libname, character.only=TRUE))
}

Library("keras")
print("Testing keras-python connection")
m <- keras_model_sequential()
Library("Rcpp")
Library("gapminder")
Library("gganimate")
Library("ggplot2")
Library("stringr")
Library("plyr")
Library("digest")
Library("reshape2")
Library("colorspace")
Library("RColorBrewer")
Library("scales")
Library("labeling")
Library("proto")
Library("munsell")
Library("gtable")
Library("dichromat")
Library("mime")
Library("RCurl")
Library("bitops")
Library("zoo")
Library("knitr")
Library("dplyr")
Library("readr")
Library("tidyr")
Library("randomForest")
Library("xgboost")
Library("rstan")
Library("prophet")
Library("fftw")
Library("seewave")
Library("mxnet")
Library("lightgbm")

testPlot1 <- ggplot(data.frame(x=1:10,y=runif(10))) + aes(x=x,y=y) + geom_line()
ggsave(testPlot1, filename="plot1.png")

# Test that base graphics will save to .png by default
plot(runif(10))

# Test gganimate.
testPlot2 <- ggplot(gapminder,
                    aes(gdpPercap, lifeExp, size = pop, color = continent, frame = year),
                    transition_states(gear, transition_length = 2, state_length = 1)) +
  geom_point() +
  scale_x_log10()

# Test MXNet
mx.nd.ones(c(2,3))

print("Ok!")
