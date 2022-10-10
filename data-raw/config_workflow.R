## code to prepare `config_workflow` dataset goes here
desc <- utils::packageDescription('gsm')
config_workflow <- read.csv("data-raw/config_workflow.csv")
config_workflow$gsm_version <- desc$Version
usethis::use_data(config_workflow, overwrite = TRUE)
