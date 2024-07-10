test_that("Report_FlagOverTime returns the expected object", {
  # When available, use built-in datasets, which are temporarily duplicated in
  # testdata.
  dfSummary <- read.csv(test_path("testdata", "sampleSummaryLong.csv")) %>%
    # Use a subset to keep things fast.
    dplyr::filter(GroupID %in% c(3, 4, 40)) %>%
    dplyr::mutate(
      # Fast-forward the dates so we span 2 years.
      SnapshotDate = SnapshotDate %>%
        lubridate::ymd() %>%
        lubridate::rollforward(roll_to_first = TRUE) %>%
        lubridate::rollforward()
    )
  dfMetrics <- read.csv(test_path("testdata", "sampleMetrics.csv"))
  x <- Report_FlagOverTime(dfSummary, dfMetrics)
  expect_s3_class(x, "gt_tbl")
  expect_snapshot({
    names(x)
    dplyr::as_tibble(x$`_styles`)
    x$`_styles`$styles
  })
})
