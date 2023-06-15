## code to prepare `config_param` dataset goes here
config_param <- read.csv("data-raw/config_param.csv")
usethis::use_data(config_param, overwrite = TRUE)
