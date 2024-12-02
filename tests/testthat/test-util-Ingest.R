test_that("Ingest works with optional columns", {
  lSourceData <- list(
    df1 = data.frame(
      a = 1:10,
      b = letters[1:10]
    )
  )
  lSpec <- list(
    df1 = list(
      a = list(required = TRUE, type = "integer"),
      b = list(required = TRUE, type = "character"),
      c = list(required = FALSE, type = "character")
    )
  )
  expect_no_error(expect_message(expect_message({
    test_result <- Ingest(lSourceData, lSpec)
  })))
  expected_result <- list(
    Raw_df1 = lSourceData$df1
  )
  expect_identical(test_result, expected_result)
})
