test_that("Test with valid input and one group", {
  result <- Report_Setup(
    dfGroups = reportingGroups,
    dfMetrics = reportingMetrics,
    dfResults = reportingResults
  )

  expect_equal(result$GroupLevel, "Site")
  expect_equal(result$SnapshotDate, as.Date("2012-12-31"))
  expect_equal(result$StudyID, "AA-AA-000-0000")
  expect_equal(result$red_kris, 13)
  expect_equal(result$amber_kris, 94)
})

test_that("Test with missing SnapshotDate and protocol number/title", {
  reportingResults_alt <- reportingResults %>%
    select(-SnapshotDate)
  reportingGroups_alt <- reportingGroups %>%
    filter(!Param %in% c("protocol_title", "protocol_number"))

  expect_message(
    {
      today <- Sys.Date()
      result <- Report_Setup(reportingGroups_alt, reportingMetrics, reportingResults_alt)
    },
    "No `SnapshotDate`"
  )

  expect_equal(result$GroupLevel, "Site")
  expect_equal(result$SnapshotDate, Sys.Date())
  expect_equal(result$StudyID, "Unknown")
  expect_equal(result$red_kris, 93)
  expect_equal(result$amber_kris, 801)
})

test_that("Test StudyID output with missing protocol number", {
  reportingGroups_alt <- reportingGroups %>%
    filter(Param != "protocol_number")

  result <- Report_Setup(reportingGroups_alt, reportingMetrics, reportingResults)

  expect_equal(result$GroupLevel, "Site")
  expect_equal(result$SnapshotDate, as.Date("2012-12-31"))
  expect_equal(result$StudyID, "Protocol Title")
  expect_equal(result$red_kris, 13)
  expect_equal(result$amber_kris, 94)
})

test_that("dfSummary empty data frame", {
  dfSummary <- tibble(Flag = integer(0))

  expect_message(
    {
      today <- Sys.Date()
      result <- Report_Setup(reportingGroups, reportingMetrics, dfSummary)
    },
    "No `SnapshotDate`"
  )

  expect_equal(result$SnapshotDate, today)
  expect_equal(result$red_kris, 0)
  expect_equal(result$amber_kris, 0)
})
