## code to prepare `sampleMeta` dataset goes here
sampleMeta <- read.csv("data-raw/sampleMeta.csv")
usethis::use_data(sampleMeta, overwrite = TRUE)
