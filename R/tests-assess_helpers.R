test_logical_assess_parameters <- function(assess_function, dfInput) {
  expect_snapshot(
    assessment <- assess_function(dfInput, bQuiet = FALSE)
  )

  expect_true(
    "lChecks" %in% names(assess_function(dfInput, bReturnChecks = TRUE))
  )
}
