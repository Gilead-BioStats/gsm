## code to prepare `config_workflow` dataset goes here
config_workflow <- read.csv("data-raw/config_workflow.csv")
usethis::use_data(config_workflow, overwrite = TRUE)

