test_that("MakeMetric makes dfMetrics", {
  given <- list(
    a = list(
      meta = list(
        GroupLevel = "Site",
        Abbreviation = "AE"
      )
    ),
    b = list(
      meta = list(
        GroupLevel = "Site",
        Abbreviation = "SAE"
      )
    )
  )
  expected <- tibble::tibble(
    GroupLevel = "Site",
    Abbreviation = c("AE", "SAE")
  )
  expect_identical(
    MakeMetric(given),
    expected
  )
})
