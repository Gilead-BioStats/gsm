test_that("All data.frames and columns are present", {
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

  # Example data
  lData <- list(
    df1 = data.frame(a = 1:3, b = 4:6),
    df2 = data.frame(x = 7:9, y = 10:12)
  )

  expect_message(
    expect_message(expect_message(
      expect_message(CheckSpec(lData, lSpec), "All 2 data"),
      "All specified"
    ), "All specified"),
    "All 4 required"
  )
})

test_that("Missing data.frames trigger an error", {
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

  # Example data with a missing column
  lData <- list(
    df1 = data.frame(a = 1:3),
    df2 = data.frame(x = 7:9, y = 10:12)
  )

  expect_message(
    expect_message(expect_message(expect_message(CheckSpec(lData, lSpec), "All 2 data"), "All specified"), "All specified"),
    regexp = "missing columns are: df1\\$b"
  )
})

test_that("Multiple missing columns are correctly reported", {
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

  # Example data with multiple missing columns
  lData <- list(
    df1 = data.frame(a = 1:3),
    df2 = data.frame(x = 7:9)
  )

  expect_message(
    expect_message(expect_message(expect_message(CheckSpec(lData, lSpec), "All 2 data"), "All specified"), "All specified"),
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
    expect_message(expect_message(CheckSpec(lData, lSpec), "All 1 data"), "All specified"),
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
    expect_message(expect_message(CheckSpec(lData, lSpec), "All 1 data"), "All specified"),
    regexp = "Not all required columns"
  )
})

test_that("Validate column type works", {
  lData <- list(reporting_results = gsm::reportingResults)
  lSpec <- list(
    reporting_results = list(
      GroupID = list(required = TRUE, type = "character"),
      GroupLevel = list(required = TRUE, type = "character"),
      Numerator = list(required = TRUE, type = "numeric"),
      Denominator = list(required = TRUE, type = "numeric")
    )
  )
  expect_message(
    expect_message(expect_message(CheckSpec(lData, lSpec), "All 1"), "All 4"),
    regexp = "All specified columns"
  )

  lSpec <- list(
    reporting_results = list(
      GroupID = list(required = TRUE, type = "character"),
      GroupLevel = list(required = TRUE, type = "character"),
      Numerator = list(required = TRUE, type = "character"),
      Denominator = list(required = TRUE, type = "numeric")
    )
  )
  expect_message(
    expect_message(expect_message(CheckSpec(lData, lSpec), "All 1"), "All 4"),
    regexp = "Not all columns"
  )
})

test_that("skip column check when `_all` is specified", {
  # example lSpec
  lSpec <- list(
    df1 = list(
      a = list(required = TRUE),
      b = list(required = TRUE)
    ),
    df2 = list(
      x = list(required = TRUE),
      y = list(required = TRUE)
    ),
    df3 = list(
      `_all` = list(required = TRUE)
    )
  )

  # Example data
  lData <- list(
    df1 = data.frame(a = 1:3, b = 4:6),
    df2 = data.frame(x = 7:9, y = 10:12),
    df3 = data.frame(z = 1:3, t = 20:22)
  )

  expect_message(
    expect_message(expect_message(
      expect_message(CheckSpec(lData, lSpec), "All 3 data"),
      "All specified"
    ), "All specified"),
    "All 4 required"
  )
})

test_that("proper message appears when all data frames require `_all` columns", {
  # example lSpec
  lSpec <- list(
    df1 = list(
      `_all` = list(required = TRUE)
    ),
    df2 = list(
      `_all` = list(required = TRUE)
    ),
    df3 = list(
      `_all` = list(required = TRUE)
    )
  )

  # Example data
  lData <- list(
    df1 = data.frame(a = 1:3, b = 4:6),
    df2 = data.frame(x = 7:9, y = 10:12),
    df3 = data.frame(z = 1:3, t = 20:22)
  )

  expect_message(
    expect_message(CheckSpec(lData, lSpec), "All 3 data"),
    " No required columns specified"
  )
})
