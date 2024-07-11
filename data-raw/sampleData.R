sampleBounds <- read.csv("data-raw/sampleBounds.csv")
usethis::use_data(sampleBounds, overwrite = TRUE)

sampleGroups <- read.csv("data-raw/sampleGroups.csv")
usethis::use_data(sampleGroups, overwrite = TRUE)

sampleInput <- read.csv("data-raw/sampleInput.csv")
usethis::use_data(sampleInput, overwrite = TRUE)

sampleMetrics <- read.csv("data-raw/sampleMetrics.csv")
usethis::use_data(sampleMetrics, overwrite = TRUE)

sampleResults <- read.csv("data-raw/sampleResults.csv")
usethis::use_data(sampleResults, overwrite = TRUE)

sampleSummary <- read.csv("data-raw/sampleSummary.csv")
usethis::use_data(sampleSummary, overwrite = TRUE)
