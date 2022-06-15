test_logical_assess_parameters <- function(assess_function, dfInput) {
  expect_message(
    assess_function(dfInput, bQuiet = FALSE)
  )

  expect_true(
    "lChecks" %in% names(assess_function(dfInput, bReturnChecks = TRUE))
  )
}
