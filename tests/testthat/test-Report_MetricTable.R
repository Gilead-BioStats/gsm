test_that("Empty data frames return default message", {
  dfResults_empty <- reportingResults[-c(1:nrow(reportingResults)), ]
  dfGroups_empty <- reportingGroups[-c(1:nrow(reportingGroups)), ]
  expect_equal(
    Report_MetricTable(dfResults_empty, dfGroups_empty),
    "Nothing flagged for this KRI."
  )
})

test_that("Correct data structure when proper dataframe is passed", {
  reportingResults_filt <- reportingResults %>%
    dplyr::filter(MetricID == unique(reportingResults$MetricID)[1])
  result <- Report_MetricTable(reportingResults_filt, reportingGroups)
  expect_s3_class(result, "gt_tbl")
  expect_true(any(grepl("162", result)))
  expect_true(any(grepl("Kimler", result)))
})

test_that("Flag filtering works correctly", {
  reportingResults_filt <- reportingResults %>%
    dplyr::filter(MetricID == unique(reportingResults$MetricID)[1])
  result <- Report_MetricTable(reportingResults_filt, reportingGroups)
  expect_s3_class(result, "gt_tbl")
  expect_false(any(grepl("Nkaujiaong", result)))
})

test_that("Score rounding works correctly", {
  reportingResults_filt <- reportingResults %>%
    dplyr::filter(MetricID == unique(reportingResults$MetricID)[1])
  result <- Report_MetricTable(reportingResults_filt, reportingGroups)
  expect_true(any(grepl("0.05", result)))
})

test_that("Errors out when multiple MetricIDs passed in", {
  expect_error(Report_MetricTable(reportingResults, reportingGroups))
})

test_that("Runs with just results with NULL group argument", {
  reportingResults_filt <- reportingResults %>%
    dplyr::filter(MetricID == unique(reportingResults$MetricID)[1])
  result <- Report_MetricTable(reportingResults_filt)
  expect_s3_class(result, "gt_tbl")
})

test_that("Output is expected object", {
  zero_flags <- c("0X003", "0x039")
  red_flags <- c("0X113", "0X025")
  amber_flags <- c("0X119", "0X046")

  reportingResults_filt <- reportingResults %>%
    FilterByLatestSnapshotDate() %>%
    dplyr::filter(
      MetricID == unique(reportingResults$MetricID)[[1]],
      GroupID %in% c(zero_flags, red_flags, amber_flags)
    ) %>%
    # Add an NA row back for representation.
    dplyr::bind_rows(
      tibble::tibble(
        GroupID = "0X000",
        GroupLevel = "Site",
        Numerator = 4L,
        Denominator = 8L,
        Metric = 0.5,
        Score = NA,
        Flag = NA,
        MetricID = "kri0001",
        SnapshotDate = as.Date("2012-12-31"),
        StudyID = "ABC-123"
      )
    )
  expect_snapshot({
    Report_MetricTable(reportingResults_filt, reportingGroups)
  })
})
