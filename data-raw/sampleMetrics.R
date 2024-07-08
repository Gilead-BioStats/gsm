## code to prepare `sampleMetrics` dataset goes here
sampleMetrics <- read.csv("data-raw/sampleMetrics.csv")
usethis::use_data(sampleMetrics, overwrite = TRUE)
