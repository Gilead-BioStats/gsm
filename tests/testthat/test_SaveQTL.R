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
  csv <- read.csv(system.file("qtl_dummy_data", "dummyqtldata.csv", package = "gsm"))
  write.csv(csv, file = paste0(temp, "/test.csv"))

  SaveQTL(strPath = paste0(temp, "/test.csv"), lSnapshot = RunQTL("qtl0006"), bQuiet = FALSE)

  saved_file_name <- paste0(temp, "/test ", Sys.Date(), ".csv")
  final <- read.csv(saved_file_name)

  expect_true("test.csv" %in% list.files(temp))
  expect_true(basename(saved_file_name) %in% list.files(temp))
  expect_true(nrow(final) > nrow(csv))
})
