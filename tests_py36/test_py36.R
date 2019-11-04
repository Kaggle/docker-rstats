context("py36")

test_that("python 3.6 conda env is installed", {
    Sys.setenv(RETICULATE_PYTHON = "/opt/conda/envs/py36/bin/", required = T)
    library("reticulate")
    py_version <- reticulate::py_config()$python
    expect_equal(py_version, "/opt/conda/envs/py36/bin/python")
})
