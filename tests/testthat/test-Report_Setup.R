test_that("Test with valid input and one group", {
  result <- Report_Setup(dfGroups = sampleGroups,
                         dfMetrics = sampleMetrics,
                         dfResults = sampleResults)

  expect_equal(result$Group, "Site")
  expect_equal(result$SnapshotDate, as.Date("2012-01-31"))
  expect_equal(result$StudyID, "AA-AA-000-0000")
  expect_equal(result$red_kris, 0)
  expect_equal(result$amber_kris, 0)
})

test_that("Test with missing SnapshotDate and protocol number/title", {
  sampleResults_alt <- sampleResults %>%
    select(-SnapshotDate)
  sampleGroups_alt <- sampleGroups %>%
    filter(!Param %in% c("protocol_title", "protocol_number"))

  expect_message(
    {
      today <- Sys.Date()
      result <- Report_Setup(sampleGroups_alt, sampleMetrics, sampleResults_alt)
    },
    "No `SnapshotDate`"
  )

  expect_equal(result$Group, "Site")
  expect_equal(result$SnapshotDate, Sys.Date())
  expect_equal(result$StudyID, "Unknown")
  expect_equal(result$red_kris, 45)
  expect_equal(result$amber_kris, 427)
})

test_that("Test StudyID output with missing protocol number", {
  sampleGroups_alt <- sampleGroups %>%
    filter(Param != "protocol_number")

  result <- Report_Setup(sampleGroups_alt, sampleMetrics, sampleResults)

  expect_equal(result$Group, "Site")
  expect_equal(result$SnapshotDate, as.Date("2012-01-31"))
  expect_equal(result$StudyID, "Protocol Title")
  expect_equal(result$red_kris, 0)
  expect_equal(result$amber_kris, 0)
})

test_that("dfSummary empty data frame", {
  dfSummary <- tibble(Flag = integer(0))

  expect_message(
    {
      today <- Sys.Date()
      result <- Report_Setup(sampleGroups, sampleMetrics, dfSummary)
    },
    "No `SnapshotDate`"
  )

  expect_equal(result$red_kris, 0)
  expect_equal(result$amber_kris, 0)
})
