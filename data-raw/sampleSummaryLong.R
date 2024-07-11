## code to prepare `sampleResults` dataset goes here
sampleResults <- read.csv("data-raw/sampleResults.csv")
usethis::use_data(sampleResults, overwrite = TRUE)
