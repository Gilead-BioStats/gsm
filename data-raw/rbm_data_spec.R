## code to prepare `rbm_data_spec` dataset goes here

rbm_data_spec <- read.csv("data-raw/rbm_data_spec.csv")

usethis::use_data(rbm_data_spec, overwrite = TRUE)
