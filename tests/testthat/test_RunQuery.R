test_that("RunQuery returns correct result", {
  # Create a sample data frame
  df <- data.frame(
    Name = c("John", "Jane", "Bob"),
    Age = c(25, 30, 35),
    Salary = c(50000, 60000, 70000)
  )

  # Define the query and mapping
  query <- "SELECT * FROM df WHERE Age >= 30"

  # Call the RunQuery function
  result <- RunQuery(query, df)

  # Check if the result is correct
  expect_equal(nrow(result), 2)
  expect_equal(colnames(result), c("Name", "Age", "Salary"))
  expect_equal(result$Name, c("Jane", "Bob"))
  expect_equal(result$Age, c(30, 35))
  expect_equal(result$Salary, c(60000, 70000))
})

test_that("RunQuery handles empty df", {
  # Create an empty data frame
  df <- data.frame()

  # Define the query and mapping
  query <- "SELECT * FROM df WHERE Age >= 30"

  # Call the RunQuery function
  result <- RunQuery(query, df)

  # Check if the result is empty
  expect_equal(nrow(result), 0)
})

test_that("RunQuery handles invalid input", {
  # Create a sample data frame
  df <- data.frame(
    Name = c("John", "Jane", "Bob"),
    Age = c(25, 30, 35),
    Salary = c(50000, 60000, 70000)
  )

  # Define the query and mapping with invalid input types
  query <- 123

  # Call the RunQuery function and expect an error
  expect_error(RunQuery(query, df))
})

test_that("RunQuery checks if strQuery contains 'FROM df'", {
  # Create a sample data frame
  df <- data.frame(
    Name = c("John", "Jane", "Bob"),
    Age = c(25, 30, 35),
    Salary = c(50000, 60000, 70000)
  )

  # Define the query and mapping
  query <- "SELECT * FROM mydata WHERE Age >= 30"

  # Call the RunQuery function and expect an error
  expect_error(RunQuery(query, df), "strQuery must contain 'FROM df'")
})

test_that("RunQuery checks if all templated columns are found in lMapping", {
  # Create a sample data frame
  df <- data.frame(
    Name = c("John", "Jane", "Bob"),
    Age = c(25, 30, 35),
    Salary = c(50000, 60000, 70000)
  )

  # Define the query and mapping
  query <- "SELECT * FROM df WHERE Age >= 30"

  # Call the RunQuery function and expect no error
  expect_no_error(RunQuery(query, df))
})

test_that("RunQuery applies schema appropriately", {
  # Create a sample data frame
  df <- data.frame(
    Name = c("John", "Jane", "Bob"),
    Age = c(25, 30, 35),
    Salary = c(50000, 60000, "70000"),
    Birthday = c("1990-01-01", "1987-02-02", "1985-03-03")
  )
  spec <- list(
    Name = list(
      type = "character",
      source_col = "Name"
    ),
    Age = list(
      type = "integer",
      source_col = "Age"
    ),
    Salary = list(
      type = "integer",
      source_col = "Salary"
    ),
    Birthday = list(
      type = "Date",
      source_col = "Birthday"
    )
  )

  # Define the query and mapping
  query <- "SELECT * FROM df WHERE Age >= 30"

  # Call the RunQuery function and expect no error
  expect_no_error(result <- RunQuery(query, df, bUseSchema = T, lColumnMapping = spec))
  expect_equal(class(result$Birthday), "Date")
  expect_equal(class(result$Salary), "integer")
  expect_equal(class(result$Age), "integer")
  expect_equal(class(result$Name), "character")
})
