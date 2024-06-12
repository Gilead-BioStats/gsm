dfSummary <- tibble::tibble(
  GroupID = c("10", "100", "101", "102", "103"),
  GroupLevel = rep("Site", 5),
  Numerator = seq(2,10,2),
  Denomicator = seq(10,50,10),
  Metric = c(0.02, 0.02, 0.02, 0.02, 0.02),
  Score = c(1,3,2,1,1),
  Flag = c(0,2,1,0,0),
  MetricID = rep("kri0001", 5)
)

dfStudy <- clindata::ctms_study %>% rename(StudyID = protocol_number)

dfMetrics <- tibble::tibble(
  metric = "Adverse Event Rate",
  workflowid = "kri0001",
  group = "Site"
)

test_that("Test with valid input and one group", {
  result <- Report_Setup(dfStudy, dfMetrics, dfSummary)

  expect_equal(result$group, "Site")
  expect_equal(result$SnapshotDate, Sys.Date())
  expect_equal(result$StudyID, "AA-AA-000-0000")
  expect_equal(result$red_kris, 1)
  expect_equal(result$amber_kris, 1)
})

test_that("Test with multiple groups", {
  dfStudy <- tibble(SnapshotDate = as.Date("2022-01-01"), StudyID = "S002")
  dfMetrics <- tibble(group = c("test", "check"))
  dfSummary <- tibble(Flag = c(2, -2))

  result <- Report_Setup(dfStudy, dfMetrics, dfSummary)

  expect_equal(result$group, "")
  expect_equal(result$SnapshotDate, as.Date("2022-01-01"))
  expect_equal(result$StudyID, "S002")
  expect_equal(result$red_kris, 2)
  expect_equal(result$amber_kris, 0)
})

test_that("Test group case sensitivity", {
  dfStudy <- tibble(SnapshotDate = as.Date("2022-01-01"), StudyID = "S003")
  dfMetrics <- tibble(group = rep("TEST", 5))
  dfSummary <- tibble(Flag = c(1, -1))

  result <- Report_Setup(dfStudy, dfMetrics, dfSummary)

  expect_equal(result$group, "Test")
})

test_that("Test with missing SnapshotDate and StudyID", {
  dfStudy <- tibble()
  dfMetrics <- tibble(group = rep("test", 5))
  dfSummary <- tibble(Flag = c(2, -2))

  result <- Report_Setup(dfStudy, dfMetrics, dfSummary)

  expect_equal(result$group, "Test")
  expect_equal(result$SnapshotDate, Sys.Date())
  expect_equal(result$StudyID, "Unknown")
  expect_equal(result$red_kris, 2)
  expect_equal(result$amber_kris, 0)
})

test_that("dfSummary empty data frame", {
  dfStudy <- tibble(SnapshotDate = as.Date("2022-01-01"), StudyID = "S001")
  dfMetrics <- tibble(group = rep("test", 5))
  dfSummary <- tibble(Flag = integer(0))

  result <- Report_Setup(dfStudy, dfMetrics, dfSummary)

  expect_equal(result$red_kris, 0)
  expect_equal(result$amber_kris, 0)
})

test_that("dfMetrics are empty", {
  dfStudy <- tibble(SnapshotDate = as.Date("2022-01-01"), StudyID = "S001")
  dfMetrics <- tibble(group = character(0))
  dfSummary <- tibble(Flag = c(2, -2, 0, 1, -1))

  result <- Report_Setup(dfStudy, dfMetrics, dfSummary)
  expect_equal(result$group, "")
})

