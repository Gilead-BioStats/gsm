test_logical_assess_parameters <- function(assess_function, dfInput) {
  testthat::expect_snapshot(
    assessment <- assess_function(dfInput, bQuiet = FALSE)
  )

  testthat::expect_true(
    "lChecks" %in% names(assess_function(dfInput, bReturnChecks = TRUE))
  )
}
