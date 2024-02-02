test_that("Country_Map_Raw function works correctly", {
  # Create a sample data frame for testing
  test_data <- data.frame(
    country = c("USA", "USA", "Canada", "Canada", "Mexico"),
    enrolled_participants = c(10, 15, 8, 12, 5)
  )

  # Call the function with the test data
  result <- Country_Map_Raw(dfSite = test_data)

  # Define the expected output
  expected_output <- tibble(
    country = c("Canada", "Mexico", "USA"),
    enrolled_participants = c(20, 5, 25)
  )

  # Check if the actual output matches the expected output
  expect_equal(result, expected_output)

  # Check if the error is thrown with function
  error_site <- data.frame(
    site = c("10", "10", "100", "100", "57", "57"),
    participants = c(10, 15, 10, 5, 20, 5)
  )

  expect_error(Country_Map_Raw(error_site))
})
