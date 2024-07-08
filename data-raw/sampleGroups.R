## code to prepare `sampleGroups` dataset goes here
sampleGroups <- read.csv("data-raw/sampleGroups.csv")
usethis::use_data(sampleGroups, overwrite = TRUE)
