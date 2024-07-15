sampleBounds <- read.csv("data-raw/sampleBounds.csv")
usethis::use_data(sampleBounds, overwrite = TRUE)
rm(sampleBounds)

sampleGroups <- read.csv("data-raw/sampleGroups.csv")
usethis::use_data(sampleGroups, overwrite = TRUE)
rm(sampleGroups)

sampleInput <- read.csv("data-raw/sampleInput.csv")
usethis::use_data(sampleInput, overwrite = TRUE)
rm(sampleInput)

sampleMetrics <- read.csv("data-raw/sampleMetrics.csv")
usethis::use_data(sampleMetrics, overwrite = TRUE)
rm(sampleMetrics)

sampleResults <- read.csv("data-raw/sampleResults.csv")
sampleResults$GroupID <- as.character(sampleResults$GroupID)
usethis::use_data(sampleResults, overwrite = TRUE)
rm(sampleResults)

sampleSummary <- read.csv("data-raw/sampleSummary.csv")
sampleSummary$GroupID <- as.character(sampleSummary$GroupID)
usethis::use_data(sampleSummary, overwrite = TRUE)
rm(sampleSummary)
