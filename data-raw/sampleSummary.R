## code to prepare `sampleSummary` dataset goes here
sampleSummary <- read.csv("data-raw/sampleSummary.csv")
usethis::use_data(sampleSummary, overwrite = TRUE)
