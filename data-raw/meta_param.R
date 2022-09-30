## code to prepare `meta_param` dataset goes here
desc <- utils::packageDescription('gsm')
meta_param <- read.csv("data-raw/meta_param.csv")
meta_param$gsm_version <- desc$Version
usethis::use_data(meta_param, overwrite = TRUE)
