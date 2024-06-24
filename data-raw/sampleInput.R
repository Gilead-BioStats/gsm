## code to prepare `sampleInput` dataset goes here
sampleInput <- read.csv("data-raw/sampleInput.csv")
usethis::use_data(sampleInput, overwrite = TRUE)
