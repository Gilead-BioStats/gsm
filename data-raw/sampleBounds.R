## code to prepare `sampleBounds` dataset goes here
sampleBounds <- read.csv("data-raw/sampleBounds.csv")
usethis::use_data(sampleBounds, overwrite = TRUE)
