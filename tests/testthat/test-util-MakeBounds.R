test_that("MakeBounds makes dfBounds", {
  expect_snapshot({
    MakeBounds(
      dfResults = reportingResults,
      dfMetrics = reportingMetrics
    )
  })
})

test_that("MakeBounds uses user-supplied strMetrics", {
  expect_snapshot({
    MakeBounds(
      dfResults = reportingResults,
      dfMetrics = reportingMetrics,
      strMetrics = "kri0001"
    )
  })
})

test_that("MakeBounds recovers if a user NULLs strMetrics", {
  expect_snapshot({
    MakeBounds(
      dfResults = reportingResults,
      dfMetrics = reportingMetrics,
      strMetrics = NULL
    )
  })
})
