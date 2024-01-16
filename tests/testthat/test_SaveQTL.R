source(testthat::test_path("testdata/data.R"))

df <- RunQTL("qtl0004", lData = lData)

test_that("incorrect file path returns message", {
  expect_snapshot(SaveQTL(df, strPath = "wxyz"))
})

test_that("qtl with bStatus == FALSE returns message", {
  df_error <- RunQTL("qtl0004", lData = list())

  expect_snapshot(SaveQTL(df_error))
})


test_that("bQuiet = FALSE returns console messages", {
  tf <- tempfile()

  expect_message(
    SaveQTL(
      df,
      bQuiet = FALSE
    )
  )
})

test_that("test file is successfully updated", {
  temp <- tempdir()
  csv <- data.frame(
    stringsAsFactors = FALSE,
    GroupID = c(
      "AA-AA-000-0000",
      "AA-AA-000-0000", "AA-AA-000-0000", "AA-AA-000-0000", "AA-AA-000-0000",
      "AA-AA-000-0000", "AA-AA-000-0000", "AA-AA-000-0000",
      "AA-AA-000-0000", "AA-AA-000-0000", "AA-AA-000-0000"
    ),
    Metric = c(
      0.001, 0.333333333333333,
      0.264411990776326, 0.264411990776326, 0.264411990776326,
      0.264411990776326, 0.264411990776326, 0.264411990776326,
      0.264411990776326, 0.264411990776326, 0.264411990776326
    ),
    Score = c(
      0.001, 0.00840375865961264,
      0.240617526937064, 0.240617526937064, 0.240617526937064,
      0.240617526937064, 0.240617526937064, 0.240617526937064,
      0.240617526937064, 0.240617526937064, 0.240617526937064
    ),
    Flag = c(0L, 1L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L),
    Numerator = c(
      4000L, 1L, 344L, 344L, 344L,
      344L, 344L, 344L, 344L, 344L, 344L
    ),
    Denominator = c(
      90000L, 3L, 1301L, 1301L, 1301L,
      1301L, 1301L, 1301L, 1301L, 1301L, 1301L
    ),
    Method = c(
      "Exact Poisson test",
      "Exact binomial test", "Exact binomial test",
      "Exact binomial test", "Exact binomial test", "Exact binomial test",
      "Exact binomial test", "Exact binomial test",
      "Exact binomial test", "Exact binomial test", "Exact binomial test"
    ),
    ConfLevel = c(
      0.95, 0.95, 0.95, 0.95, 0.95,
      0.95, 0.95, 0.95, 0.95, 0.95, 0.95
    ),
    Estimate = c(
      0.004, 0.333333333333333,
      0.264411990776326, 0.264411990776326, 0.264411990776326,
      0.264411990776326, 0.264411990776326, 0.264411990776326,
      0.264411990776326, 0.264411990776326, 0.264411990776326
    ),
    LowCI = c(
      0.004, 0.00840375865961264,
      0.240617526937064, 0.240617526937064, 0.240617526937064,
      0.240617526937064, 0.240617526937064, 0.240617526937064,
      0.240617526937064, 0.240617526937064, 0.240617526937064
    ),
    UpCI = c(
      0.005, 0.905700675949754,
      0.289275590485121, 0.289275590485121, 0.289275590485121,
      0.289275590485121, 0.289275590485121, 0.289275590485121,
      0.289275590485121, 0.289275590485121, 0.289275590485121
    ),
    snapshot_date = c(
      "2022-06-14", "2023-03-10",
      "2023-03-11", "2023-03-11", "2023-03-11", "2023-03-11",
      "2023-03-11", "2023-03-11", "2023-03-11", "2023-03-11",
      "2023-03-11"
    )
  )



  write.csv(csv, file = paste0(temp, "/test.csv"))

  SaveQTL(strPath = paste0(temp, "/test.csv"), lSnapshot = RunQTL("qtl0006"), bQuiet = FALSE)

  saved_file_name <- paste0(temp, "/test ", Sys.Date(), ".csv")
  final <- read.csv(saved_file_name)

  expect_true("test.csv" %in% list.files(temp))
  expect_true(basename(saved_file_name) %in% list.files(temp))
  expect_true(nrow(final) > nrow(csv))
})
