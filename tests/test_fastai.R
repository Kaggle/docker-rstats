context("fastai")

test_that("cpu imports", {
  library(fastai)

  library(data.table)
	library(magrittr)
	library(fastai)

	# read data
	df = data.table::fread('data/adult.csv')

	# variables
	dep_var = 'salary'
	cat_names = c('workclass', 'education', 'marital-status', 'occupation', 'relationship', 'race')
	cont_names = c('age', 'fnlwgt', 'education-num')

	# preprocess strategy
	procs = list(FillMissing(), Categorify(), Normalize())

	# prepare
	dls = TabularDataTable(df, procs, cat_names, cont_names, 
		y_names = dep_var, splits = list(c(1:80),c(81:100))) %>% 
		dataloaders(bs = 16)

	print(dls)

	# summary
	model = dls %>% tabular_learner(metrics=accuracy)

	print(model)

	model %>% predict(df[10:15,])
})
