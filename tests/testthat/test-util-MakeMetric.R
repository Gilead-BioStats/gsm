test_that("MakeMetric makes dfMetrics", {
  given <- list(
    a = list(
      meta = list(
        Type = "Metric",
        ID = "kri0001",
        GroupLevel = "Site",
        Abbreviation = "AE"
      )
    ),
    b = list(
      meta = list(
        Type = "Metric",
        ID = "kri0002",
        GroupLevel = "Site",
        Abbreviation = "SAE"
      )
    )
  )
  expected <- tibble::tibble(
    Type = "Metric",
    ID = c("kri0001", "kri0002"),
    GroupLevel = "Site",
    Abbreviation = c("AE", "SAE"),
    MetricID = c("Metric_kri0001", "Metric_kri0002")
  )
  expect_identical(
    MakeMetric(given),
    expected
  )
})
