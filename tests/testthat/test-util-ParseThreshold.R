# Test Case 1 - Valid Input
test_that("ParseThreshold with valid input returns sorted numeric vector", {
  expect_equal(ParseThreshold("3,1,4,2"), c(1, 2, 3, 4))
})

# Test Case 2 - Invalid Input (Non-Numeric Values)
test_that("ParseThreshold with non-numeric values returns NULL", {
  expect_snapshot({
    result <- ParseThreshold("a,b,c")
  })
  expect_null(result)
})

# Test Case 3 - Empty String
test_that("ParseThreshold with empty string returns NULL", {
  expect_snapshot({
    result <- ParseThreshold("")
  })
  expect_null(result)
})

# Test Case 4 - Single Value
test_that("ParseThreshold with single value returns numeric vector with one element", {
  expect_equal(ParseThreshold("42"), c(42))
})

# Test Case 5 - Negative Values
test_that("ParseThreshold with negative values returns sorted numeric vector", {
  expect_equal(ParseThreshold("-3,-1,-4,-2"), c(-4, -3, -2, -1))
})

# Test Case 6 - Floating Point Numbers
test_that("ParseThreshold with floating point numbers returns sorted numeric vector", {
  expect_equal(ParseThreshold("3.5,1.2,4.8,2.3"), c(1.2, 2.3, 3.5, 4.8))
})

# Test Case 7 - Mixed Valid and Invalid Input
test_that("ParseThreshold with mixed valid and invalid input returns NULL", {
  expect_warning(
    result <- ParseThreshold("1,2,three,4"),
    "Failed to parse"
  )
  expect_null(result)
})
