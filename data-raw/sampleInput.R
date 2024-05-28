## code to prepare `sampleInput` dataset goes here
sampleInput <- read.csv("data-raw/sampleInput.csv", row.names = 1)
usethis::use_data(sampleInput, overwrite = TRUE)
