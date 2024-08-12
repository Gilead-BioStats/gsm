reportingGroups <- read.csv("data-raw/reportingGroups.csv")
usethis::use_data(reportingGroups, overwrite = TRUE)
rm(reportingGroups)

analyticsInput <- read.csv("data-raw/analyticsInput.csv")
analyticsInput$GroupID <- as.character(analyticsInput$GroupID)
usethis::use_data(analyticsInput, overwrite = TRUE)
rm(analyticsInput)

reportingMetrics <- read.csv("data-raw/reportingMetrics.csv")
usethis::use_data(reportingMetrics, overwrite = TRUE)
rm(reportingMetrics)

reportingResults <- read.csv("data-raw/reportingResults.csv")
reportingResults$GroupID <- as.character(reportingResults$GroupID)
reportingResults$SnapshotDate <- as.Date(reportingResults$SnapshotDate)
usethis::use_data(reportingResults, overwrite = TRUE)
rm(reportingResults)

analyticsSummary <- read.csv("data-raw/analyticsSummary.csv")
analyticsSummary$GroupID <- as.character(analyticsSummary$GroupID)
usethis::use_data(analyticsSummary, overwrite = TRUE)
rm(analyticsSummary)

reportingBounds <- read.csv("data-raw/reportingBounds.csv")
reportingBounds$SnapshotDate <- as.Date(reportingBounds$SnapshotDate)
usethis::use_data(reportingBounds, overwrite = TRUE)
rm(reportingBounds)
