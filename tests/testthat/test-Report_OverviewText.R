test_that("It handles different lSetup group values correctly", {
  lSetup <- list(GroupLevel = "Site", SnapshotDate = "2012-09-30", StudyID = "AA-AA-000-0000")
  lStudy <- list(
    ParticipantCount = "1301",
    SiteCount = "176"
  )

  expect_output(
    Report_OverviewText(lSetup, reportingResults, lStudy),
    "sites"
  )

  lSetup$GroupLevel <- "Country"
  lStudy$CountryCount <- "3"
  expect_output(
    Report_OverviewText(lSetup, reportingResults, lStudy),
    "countries"
  )
})

test_that("Data filtering checks", {
  lSetup <- list(
    GroupLevel = "Site",
    SnapshotDate = "2012-09-30",
    StudyID = "AA-AA-000-0000"
  )
  lStudy <- list(ParticipantCount = "1301", SiteCount = "176")

  expect_output(Report_OverviewText(lSetup, reportingResults, lStudy), "sites have at least one red KRI")
  expect_output(Report_OverviewText(lSetup, reportingResults, lStudy), "sites have at least one red or amber KRI")
  expect_output(Report_OverviewText(lSetup, reportingResults, lStudy), "sites have neither red nor amber KRIs")
})

test_that("Handles empty dataframe cases", {
  lSetup <- list(GroupLevel = "Site", SnapshotDate = "2012-09-30", StudyID = "AA-AA-000-0000")
  lStudy <- list(
    ParticipantCount = "1301",
    SiteCount = "176"
  )
  dfEmptySummary <- data.frame(GroupID = character(), Flag = integer())
  expect_output(
    Report_OverviewText(lSetup, dfEmptySummary, lStudy),
    "0 sites have at least one red KRI",
    fixed = TRUE
  )

  expect_output(
    Report_OverviewText(lSetup, dfEmptySummary, lStudy),
    "0 sites have neither red nor amber KRIs",
    fixed = TRUE
  )
})

test_that("Handles different flag configurations", {
  lSetup <- list(GroupLevel = "Site", SnapshotDate = "2012-09-30", StudyID = "AA-AA-000-0000")
  lStudy <- list(
    ParticipantCount = "6",
    SiteCount = "3"
  )
  dfSummary <- data.frame(
    GroupID = c("A", "A", "B", "C", "C", "C"),
    Flag = c(-2, 2, 1, -1, 0, -2)
  )

  expect_output(Report_OverviewText(lSetup, dfSummary, lStudy), "2 sites have at least one red KRI")
  expect_output(Report_OverviewText(lSetup, dfSummary, lStudy), "3 sites have at least one red or amber KRI")
  expect_output(Report_OverviewText(lSetup, dfSummary, lStudy), "0 sites have neither red nor amber KRIs")
})
