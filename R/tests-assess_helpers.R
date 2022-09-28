test_logical_assess_parameters <- function(assess_function, dfInput) {
  testthat::expect_snapshot(
    assessment <- assess_function(dfInput, bQuiet = FALSE)
  )
}
