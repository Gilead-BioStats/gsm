## code to prepare `meta_workflow` dataset goes here
desc <- packageDescription('gsm')
meta_workflow <- read.csv("data-raw/meta_workflow.csv")
meta_workflow$gsm_version <- desc$Version
usethis::use_data(meta_workflow, overwrite = TRUE)
