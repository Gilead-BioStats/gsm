test_that("MakeBounds makes dfBounds", {
  reportingResults %>% dplyr::count(SnapshotDate)
  expect_snapshot({
    MakeBounds(
      dfResults = dplyr::filter(reportingResults, SnapshotDate == "2012-12-31"),
      dfMetrics = reportingMetrics
    )
  })
})

test_that("MakeBounds uses user-supplied strMetrics", {
  expect_snapshot({
    MakeBounds(
      dfResults = dplyr::filter(reportingResults, SnapshotDate == "2012-12-31"),
      dfMetrics = reportingMetrics,
      strMetrics = "Analysis_kri0001"
    )
  })
})

test_that("MakeBounds fails for NULLed arguments", {
  expect_error(
    {
      MakeBounds(
        dfResults = reportingResults,
        dfMetrics = reportingMetrics,
        strMetrics = NULL
      )
    },
    regexp = "strMetrics",
    class = "gsm_error-null_arg"
  )
  expect_error(
    {
      MakeBounds(
        dfResults = reportingResults,
        dfMetrics = reportingMetrics,
        dSnapshotDate = NULL
      )
    },
    regexp = "dSnapshotDate",
    class = "gsm_error-null_arg"
  )
  expect_error(
    {
      MakeBounds(
        dfResults = reportingResults,
        dfMetrics = reportingMetrics,
        strStudyID = NULL
      )
    },
    regexp = "strStudyID",
    class = "gsm_error-null_arg"
  )
})

test_that("MakeBounds fails gracefully for multiple arg values", {
  expect_warning(
    {
      expect_message(
        {
          dfBounds <- MakeBounds(
            dfResults = reportingResults,
            dfMetrics = reportingMetrics
          )
        },
        "Creating stacked dfBounds data"
      )
    },
    regexp = "SnapshotDate",
    class = "gsm_warning-multiple_values"
  )
  expect_null(dfBounds)
  expect_warning(
    {
      expect_message(
        {
          dfBounds <- MakeBounds(
            dfResults = dplyr::filter(reportingResults, SnapshotDate == "2012-12-31"),
            dfMetrics = reportingMetrics,
            strStudyID = c("a", "b")
          )
        },
        "Creating stacked dfBounds data"
      )
    },
    regexp = "StudyID",
    class = "gsm_warning-multiple_values"
  )
  expect_null(dfBounds)
})

test_that("MakeBounds makes poisson dfBounds", {
  reportingMetrics$Type <- "poisson"
  expect_snapshot({
    MakeBounds(
      dfResults = dplyr::filter(reportingResults, SnapshotDate == "2012-12-31"),
      dfMetrics = reportingMetrics
    )
  })
})

