test_that("It handles different lSetup group values correctly", {
  lSetup <- list(group = "Site", SnapshotDate = "2023-01-01", StudyID = "ST123")
  dfSummary <- data.frame(GroupID = c("A", "B", "C"), Flag = c(2, 1, 0))
  dfStudy <- data.frame(num_enrolled_subj_m = 100, num_site_actl = 5)

  expect_output(
    Report_OverviewText(lSetup, dfSummary, dfStudy),
    "sites"
  )

  lSetup$group <- "Country"
  expect_output(
    Report_OverviewText(lSetup, dfSummary, dfStudy),
    "countries"
  )
})

test_that("Data filtering checks", {
  lSetup <- list(group = "Site", SnapshotDate = "2023-01-01", StudyID = "ST123")
  dfSummary <- data.frame(
    GroupID = c("A", "B", "C", "D", "E"),
    Flag = c(2, -2, 1, -1, 0)
  )
  dfStudy <- data.frame(num_enrolled_subj_m = 300, num_site_actl = 10)

  expect_output(Report_OverviewText(lSetup, dfSummary, dfStudy), "2 sites have at least one red KRI")
  expect_output(Report_OverviewText(lSetup, dfSummary, dfStudy), "4 sites have at least one red or amber KRI")
  expect_output(Report_OverviewText(lSetup, dfSummary, dfStudy), "1 sites have neither red nor amber KRIS and are not shown")
})

test_that("Handles empty dataframe cases", {
  lSetup <- list(group = "Site", SnapshotDate = "2023-01-01", StudyID = "ST123")
  dfEmptySummary <- data.frame(GroupID = character(), Flag = integer())
  dfStudy <- data.frame(num_enrolled_subj_m = 100, num_site_actl = 5)
  expect_output(
    Report_OverviewText(lSetup, dfEmptySummary, dfStudy),
    "0 sites have at least one red KRI",
    fixed = TRUE )

  expect_output(
    Report_OverviewText(lSetup, dfEmptySummary, dfStudy),
    "0 sites have neither red nor amber KRIS and are not shown",
    fixed = TRUE )
})

test_that("Handles different flag configurations", {
  lSetup <- list(group = "Site", SnapshotDate = "2023-01-01", StudyID = "ST123")
  dfSummary <- data.frame(
    GroupID = c("A", "A", "B", "C", "C", "C"),
    Flag = c(-2, 2, 1, -1, 0, -2)
  )
  dfStudy <- data.frame(num_enrolled_subj_m = 500, num_site_actl = 20)

  expect_output(Report_OverviewText(lSetup, dfSummary, dfStudy), "2 sites have at least one red KRI")
  expect_output(Report_OverviewText(lSetup, dfSummary, dfStudy), "3 sites have at least one red or amber KRI")
  expect_output(Report_OverviewText(lSetup, dfSummary, dfStudy), "1 sites have neither red nor amber KRIS and are not shown")
})

