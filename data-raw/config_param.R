## code to prepare `config_param` dataset goes here
desc <- utils::packageDescription('gsm')
config_param <- read.csv("data-raw/config_param.csv")
config_param$gsm_version <- desc$Version
usethis::use_data(config_param, overwrite = TRUE)
