test_that("Report_FlagOverTime returns the expected object", {
  dfResults <- reportingResults %>%
    # Use a subset to keep things fast.
    dplyr::filter(.data$GroupID %in% c("0X035", "0X076", "0X024")) %>%
    dplyr::mutate(
      # Fast-forward the dates so we span 2 years.
      SnapshotDate = .data$SnapshotDate %>%
        lubridate::ymd() %>%
        lubridate::rollforward(roll_to_first = TRUE) %>%
        lubridate::rollforward()
    )
  dfMetrics <- reportingMetrics
  x <- Report_FlagOverTime(dfResults, dfMetrics)
  expect_s3_class(x, "gt_tbl")
  expect_snapshot({
    names(x)
    dplyr::as_tibble(x$`_styles`)
    x$`_styles`$styles
  })
})
