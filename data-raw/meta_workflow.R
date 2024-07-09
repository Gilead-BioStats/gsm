## code to prepare `meta_workflow` dataset goes here
meta_workflow <- read.csv("data-raw/meta_workflow.csv")
usethis::use_data(meta_workflow, overwrite = TRUE)

# Also save an internal version for use as example data.
.meta_workflow <- meta_workflow
usethis::use_data(.meta_workflow, internal = TRUE, overwrite = TRUE)
