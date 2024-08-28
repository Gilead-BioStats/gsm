# example lSpec
lSpec <- list(
  df1 = list(
    a = list(required = TRUE),
    b = list(required = TRUE)
  ),
  df2 = list(
    x = list(required = TRUE),
    y = list(required = TRUE)
  )
)


test_that("All data.frames and columns are present", {
  # Example data
  lData <- list(
    df1 = data.frame(a = 1:3, b = 4:6),
    df2 = data.frame(x = 7:9, y = 10:12)
  )

  expect_message(CheckSpec(lData, lSpec), "All")
})

test_that("Missing data.frames trigger an error", {
  # Example data with one missing data.frame
  lData <- list(
    df1 = data.frame(a = 1:3, b = 4:6)
  )

  expect_error(
    CheckSpec(lData, lSpec),
    regexp = "Missing data.frames: df2"
  )
})

test_that("Missing columns trigger a warning", {
  # Example data with a missing column
  lData <- list(
    df1 = data.frame(a = 1:3),
    df2 = data.frame(x = 7:9, y = 10:12)
  )

  expect_message(
    CheckSpec(lData, lSpec),
    regexp = "missing columns are: df1\\$b"
  )
})

test_that("Multiple missing columns are correctly reported", {
  # Example data with multiple missing columns
  lData <- list(
    df1 = data.frame(a = 1:3),
    df2 = data.frame(x = 7:9)
  )

  expect_message(
    CheckSpec(lData, lSpec),
    regexp = "missing columns are: df1\\$b and df2\\$y"
  )
})

test_that("Missing column only gets a flag when it is required", {
  lData <- list(reporting_groups = gsm::reportingGroups)
  lSpec <- list(
    reporting_groups = list(
      GroupID = list(required = TRUE),
      GroupLevel = list(required = TRUE),
      Param = list(required = TRUE),
      Value = list(required = TRUE),
      NewVar = list(required = FALSE)
    )
  )
  expect_message(
    CheckSpec(lData, lSpec),
    regexp = "All 4 required columns"
  )

  lSpec <- list(
    reporting_groups = list(
      GroupID = list(required = TRUE),
      GroupLevel = list(required = TRUE),
      Param = list(required = TRUE),
      Value = list(required = TRUE),
      NewVar = list(required = TRUE)
    )
  )
  expect_message(
    CheckSpec(lData, lSpec),
    regexp = "Not all required columns"
  )

})
