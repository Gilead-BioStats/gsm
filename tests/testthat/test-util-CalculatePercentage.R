test_that("CalculatePercentage calculates percentage and formats correctly", {
  # Sample data
  sample_data <- data.frame(
    current = c(50, 20, 30),
    target = c(100, 50, 60)
  )

  # Run the function
  result <- CalculatePercentage(
    data = sample_data,
    strCurrentCol = "current",
    strTargetCol = "target",
    strPercVal = "percentage",
    strPercStrVal = "formatted_string"
  )

  # Expected values
  expected_percentage <- c(50, 40, 50)
  expected_formatted_string <- c("50 / 100 (50%)", "20 / 50 (40%)", "30 / 60 (50%)")

  # Check if the result matches the expected values
  expect_equal(result$percentage, expected_percentage)
  expect_equal(result$formatted_string, expected_formatted_string)
})
