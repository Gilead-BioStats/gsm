## code to prepare `sampleSummaryLong` dataset goes here
sampleSummaryLong <- read.csv("data-raw/sampleSummaryLong.csv")
usethis::use_data(sampleSummaryLong, overwrite = TRUE)
