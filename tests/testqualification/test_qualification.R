library(testthat)
library(gsm)

devtools::load_all()
test_dir(here::here("tests", "testqualification", "qualification"), package = "gsm")
