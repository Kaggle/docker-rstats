context("fastai")

test_that("cpu imports", {
  library(fastai)

  library(data.table)
	library(magrittr)
	library(fastai)

	# download
	URLs_ADULT_SAMPLE()

	# read data
	df = data.table::fread('adult_sample/adult.csv')

	# variables
	dep_var = 'salary'
	cat_names = c('workclass', 'education', 'marital-status', 'occupation', 'relationship', 'race')
	cont_names = c('age', 'fnlwgt', 'education-num')

	# preprocess strategy
	procs = list(FillMissing(),Categorify(),Normalize())

	# prepare
	dls = TabularDataTable(df, procs, cat_names, cont_names, 
			  y_names = dep_var, splits = list(c(1:32000),c(32001:32561))) %>% 
			  dataloaders(bs = 64)

	# summary
	model = dls %>% tabular_learner(layers=c(200,100), metrics=accuracy)
	model %>% summary()
})
