test_that("Report_FlagOverTime returns the expected object", {
  dfResults <- reportingResults %>%
    # Use a subset to keep things fast.
    dplyr::filter(
      .data$GroupID %in% c("0X005", "0X007", "0X159"),
      .data$MetricID %in% c("Analysis_kri0001", "Analysis_kri0002", "Analysis_kri0003"),
      SnapshotDate > "2012-02-01",
      SnapshotDate < "2012-05-01"
    ) %>%
    dplyr::mutate(
      # Rewind the dates so we span 2 years.
      SnapshotDate = .data$SnapshotDate %>%
        lubridate::ymd() %>%
        lubridate::rollbackward() %>%
        lubridate::rollbackward()
    )
  dfMetrics <- reportingMetrics
  x <- Report_FlagOverTime(dfResults, dfMetrics)
  expect_s3_class(x, "gt_tbl")
  expect_snapshot({
    x$`_data`
  })
})
